import os
from enum import Enum, IntEnum
from io import StringIO
from pyprinter import printer
from typing import NamedTuple, Any, List, Dict, Tuple
from utils import normalize_tabs, extract_format_fields, unique


class CodePrinter(printer.Printer):
    def __init__(self):
        string_io = StringIO()
        writer = printer.DefaultWriter(string_io)
        super().__init__(writer, colors=False, width_limit=False)
        self._string_io = string_io

    def assemble(self):
        return self._string_io.getvalue()


class OpcodeExecutionStage(IntEnum):
    """
    This enum represent a timing for an mips object relative to opode execution.
    """
    ANY         = -1    # this is ignored execution stage.
    BEFORE      = 0     # before the execution start.
    AFTER_IF    = 1     # after instruction fetch.
    AFTER_ID    = 2     # after instruction decode.
    AFTER_EX    = 3     # after instruction execution.
    AFTER_MEM   = 4     # after instruction write to mem.
    AFTER       = 5     # after the execution ends.
    # NOTE! values must be sorted by stage order. 


class MipsObject(object):
    """
    This is class represent a mips arch internal object.
    May be register, ALU-flag, Memory address, etc...
    Value is the code that access the spesific object, for example:
    EAX -> MIPSU.REGISTERS[0] 
    PC -> MIPSU.PC
    etc....
    """
    def __init__(self, value) -> None:
        super().__init__()
        self._value = value

    @property
    def value(self) -> str:
        return self._value


class MipsObjects(Enum):
    EAX = MipsObject("REGISTERS[0]")
    EBX = MipsObject("REGISTERS[1]")


class MipsTestCondition(object):
    def __init__(self, condition: str, operands: Dict[str, Tuple[MipsObject, OpcodeExecutionStage]]) -> None:
        """
        1. `condition` - Logical condition containing Mips operands such as registers (`EAX`, `PC` etc...).
        2. `operands` - should contains all the operands in (`value`, `OpcodeExecutionStage`).

        for example:
        `condition`: "{PC_Before} + 4 == {PC_After}"
        `operands`: {
            'PC_Before': (MipsInternalRegisters.PC, OpcodeExecutionStage.BEFORE),
            'PC_After': (MipsInternalRegisters.PC, OpcodeExecutionStage.AFTER)
        }
        TODO: maybe we can do it with exec("(MipsInternalRegisters.PC, OpcodeExecutionStage.BEFORE)")
        """
        super().__init__()
        self._condition = condition

        # Check that `kwargs` contains all the operands needed in `condition`.
        condition_operands = extract_format_fields(condition)
        operands_keys = operands.keys()
        assert set(condition_operands).issubset(set(operands_keys)), "Missing operands for the given condition"

        # Extract just the needed operands.
        self._operands = {key: operands[key] for key in condition_operands}

    @property
    def condition(self) -> str:
        return self._condition

    @property
    def operands(self) -> Dict[str, Tuple[Any, OpcodeExecutionStage]]:
        return self._operands
    

class MipsInstruction(NamedTuple):
    """
    This class represent one instruction.
    Each instruction has:
    1. `pc` index of the instruction/opcode in the program.
    2. `opcode` a string that store the assembly opcode, i.e. `addi $a0, $s0, 5`.
    """
    pc: int
    opcode: str


class InternalBuilderPCTrigger(NamedTuple):
    pipe_stage_var_name: str
    pc: int


class InternalBuilderConditionLogicTest(NamedTuple):
    logic_test: str
    assertion_message: str


class InternalBuilderConditionVarAssign(NamedTuple):
    var_name: str
    value: MipsObject


class InternalBuilderCondition(NamedTuple):
    pipe_stage_var_name: str
    execution_stage: OpcodeExecutionStage
    function: object


class TestbanchBuilder(object):
    def __init__(self) -> None:
        super().__init__()
        self.clear()

    def clear(self):
        """
        This function clear the internal state of the builder.
        """
        self._pipe_stage_vars_names: List[str] = []
        self._pc_triggers: List[InternalBuilderPCTrigger] = []
        self._conditions: List[InternalBuilderCondition] = []
        self._conditions_vars: List[str] = []
        
    def attach_inst(
        self, 
        inst: MipsInstruction, 
        conditions: List[MipsTestCondition]
    ) -> None:
        """
        This function append a given `MipsInstruction` to the builder internal state.
        `inst` - The `MipsInstruction` to attach to this builder.
        `conditions` - List of conditions need to be checked before/while/after the instruction.
        """
        pipe_stage_var_name = TestbanchBuilder._serialize_pipe_stage_var_name(inst)

        try:
            self._pipe_stage_vars_names.append(pipe_stage_var_name)
            self._pc_triggers.append(InternalBuilderPCTrigger(pipe_stage_var_name, inst.pc))
            for cond in conditions: self._attach_condition(inst, pipe_stage_var_name, cond)
        except Exception as e:
            # In case an error happend while attachment, clear the whole internal state, 
            # cause we don't know what cause it exactly.
            self.clear()
            raise Exception("Error while incomplete attachment, clearing internal state...") from e

    def _attach_condition(
        self, 
        inst: MipsInstruction, 
        pipe_stage_var_name: str,
        cond: MipsTestCondition
    ) -> None:
        """
        This function attach a given condition to the internal state.
        """
        if (TestbanchBuilder._is_multi_stage_condition(cond)):
            # Condition is multi stage.
            return self._attach_multi_stage_condition(inst, pipe_stage_var_name, cond)
        else:
            # Condition is single stage.
            return self._attach_single_stage_condition(inst, pipe_stage_var_name, cond)
    
    def _attach_multi_stage_condition(
        self, 
        inst: MipsInstruction, 
        pipe_stage_var_name: str,
        cond: MipsTestCondition
    ) -> None:
        """
        This function attach a given multi stage condition to the internal state.
        """
        assert TestbanchBuilder._is_multi_stage_condition(cond)

        # Store future operands value.
        # "Future operands" are operands that needs for condition check in the future.
        execution_stages = TestbanchBuilder._get_actual_execution_stages(cond)
        latest_stage = max(execution_stages)

        # This dict store a map between future operand keys and thier actual values
        operands_key_to_future_vars = {}

        for (key, (obj, stage)) in cond.operands.items():
            if stage == latest_stage or stage == OpcodeExecutionStage.ANY:
               continue
           
            # This is a future operand, let's store it's value.
            future_key = TestbanchBuilder._serialize_future_operand_var_name(
                inst.pc, key, stage
            )
            operands_key_to_future_vars[key] = future_key

            # Append the condition and vars to the builder internal state.
            self._conditions.append(InternalBuilderCondition(
                pipe_stage_var_name, stage,
                InternalBuilderConditionVarAssign(
                    var_name=future_key,
                    value=obj
                )
            ))
            self._conditions_vars.append(future_key)

        # Now build conditions for the latest operands.
        for (key, (obj, stage)) in cond.operands.items():
            if stage != latest_stage:
                continue

            operands_key_to_future_vars[key] = obj.value.value
            
        self._conditions.append(InternalBuilderCondition(
            pipe_stage_var_name, stage,
            InternalBuilderConditionLogicTest(
                logic_test=cond.condition.format(**operands_key_to_future_vars),
                assertion_message="Error"
            )
        ))
                 
    def _attach_single_stage_condition(
        self, 
        inst: MipsInstruction, 
        pipe_stage_var_name: str,
        cond: MipsTestCondition
    ) -> None:
        """
        This function attach a given single stage condition to the internal state.
        """
        assert TestbanchBuilder._is_single_stage_condition(cond)
        stage = TestbanchBuilder._get_actual_execution_stages(cond)[0] # There is exactly 1.
        func = InternalBuilderConditionLogicTest(cond.condition.format(
            **{key: mips_obj.value.value for (key, (mips_obj, exec_stage)) in cond.operands.items()}
        ), "Error")
        self._conditions.append(
            InternalBuilderCondition(pipe_stage_var_name, stage, func)
        )
    
    @classmethod
    def _serialize_execution_stage(cls, exec_stage: OpcodeExecutionStage):
        return {
            OpcodeExecutionStage.ANY: "STAGE_NOT_IN_PIPE",
            OpcodeExecutionStage.BEFORE: "STAGE_BEFORE_PIPE",
            OpcodeExecutionStage.AFTER_IF: "STAGE_AFTER_IF",
            OpcodeExecutionStage.AFTER_ID: "STAGE_AFTER_ID",
            OpcodeExecutionStage.AFTER_EX: "STAGE_AFTER_EX",
            OpcodeExecutionStage.AFTER_MEM: "STAGE_AFTER_MEM",
            OpcodeExecutionStage.AFTER: "STAGE_AFTER_PIPE"
        }.get(exec_stage)

    def build(self):
        printer = CodePrinter()
        printer.write_line("################### Consts ###################")

        MAX_EXEC_STAGE = max(OpcodeExecutionStage).value
        for exec_stage in OpcodeExecutionStage:            
            serialize_execution_stage = TestbanchBuilder._serialize_execution_stage(exec_stage)

            # Why `<MAX_EXEC_STAGE> - exec_stage.value`?
            # The test environment count stages from <MAX_EXEC_STAGE> to 0.
            printer.write_line(f"`define {serialize_execution_stage} = {MAX_EXEC_STAGE - exec_stage.value};")
        printer.write_line()

        printer.write_line("################# Initialize #################")
        printer.write_line(os.linesep.join(
            [TestbanchBuilder._serialize_initiate_pipe_stage_var(x) for x in self._pipe_stage_vars_names]
        ))
        printer.write_line()
        

        printer.write_line("############### Condition Vars ###############")
        printer.write_line(os.linesep.join(
            [TestbanchBuilder._serialize_condition_var(x) for x in self._conditions_vars]
        ))
        printer.write_line()
        
        printer.write_line("########### Update Pipe Stage Vars ###########")
        printer.write_line((os.linesep * 2).join(
            [TestbanchBuilder._serialize_update_pipe_stage_var(x) for x in self._pipe_stage_vars_names]
        ))
        printer.write_line()
        
        printer.write_line("################# PC Trigger #################")
        printer.write_line((os.linesep * 2).join(
            [TestbanchBuilder._serialize_inst_pc_trigger(x) for x in self._pc_triggers]
        ))
        printer.write_line()
        
        printer.write_line("################# Conditions #################")
        printer.write_line(os.linesep.join(
            [TestbanchBuilder._serialize_builder_condition(x) for x in self._conditions]
        ))
        printer.write_line()

        return printer.assemble()
    
    @classmethod
    def _is_single_stage_condition(cls, cond: MipsTestCondition):
        """
        Opposite of `TestbanchBuilder._is_multi_stage_condition`.
        """
        return not TestbanchBuilder._is_multi_stage_condition(cond)

    @classmethod
    def _is_multi_stage_condition(cls, cond: MipsTestCondition):
        """
        This function check if a given condition operands are muti stages or single stage.
        """
        if len(cond.operands) <= 1:
            return False
        
        execution_stages = TestbanchBuilder._get_actual_execution_stages(cond)

        assert len(execution_stages) > 0, "No actual execution stage"

        if len(execution_stages) == 1:
            # There is only one execution stage.
            return False
        
        return True

    @classmethod
    def _get_actual_execution_stages(cls, cond: MipsTestCondition) -> List[OpcodeExecutionStage]:
        """
        This function retunrs a unique list of the actual execution stages (that are not `ANY`).
        """
        return unique(filter(
            lambda x: x != OpcodeExecutionStage.ANY, 
            (ex_stage for (_, ex_stage) in cond.operands.values())
        ))

    @classmethod
    def _serialize_builder_condition(cls, cond: InternalBuilderCondition):
        if isinstance(cond.function, InternalBuilderConditionLogicTest):
            function_str = TestbanchBuilder._serialize_builder_condition_logic_test(cond)
        elif isinstance(cond.function, InternalBuilderConditionVarAssign):
            function_str = TestbanchBuilder._serialize_builder_condition_var_assign(cond)
        else:
            raise TypeError(f"Unknown function type {type(cond.function)}")
        
        printer = CodePrinter()

        execution_stage = TestbanchBuilder._serialize_execution_stage(cond.execution_stage)
        printer.write_line(normalize_tabs(f"""
            if ({cond.pipe_stage_var_name} == {execution_stage}) begin
        """))

        with printer.group(indent=4):
            printer.write_line(function_str)

        printer.write_line("end")

        return printer.assemble()

    @classmethod
    def _serialize_builder_condition_logic_test(cls, cond: InternalBuilderCondition):
        assert isinstance(cond.function, InternalBuilderConditionLogicTest)
        return normalize_tabs(f"""
            if ({cond.function.logic_test}) begin
                $display("{cond.function.assertion_message}");
                $finish;
            end
        """)

    @classmethod
    def _serialize_builder_condition_var_assign(cls, cond: InternalBuilderCondition):
        assert isinstance(cond.function, InternalBuilderConditionVarAssign)
        return f"{cond.function.var_name} = {cond.function.value.value.value}"

    @classmethod
    def _serialize_condition_var(cls, condition_var_name: str):
        return f"{condition_var_name} = 0;"

    @classmethod
    def _serialize_initiate_pipe_stage_var(cls, pipe_stage_var_name: str):
        return f"{pipe_stage_var_name} = STAGE_NOT_IN_PIPE;"
    
    @classmethod
    def _serialize_update_pipe_stage_var(cls, pipe_stage_var_name: str):
        return normalize_tabs(f"""
        if ({pipe_stage_var_name} > STAGE_NOT_IN_PIPE) begin
            {pipe_stage_var_name} -= 1;
        end
        """)

    @classmethod
    def _serialize_inst_pc_trigger(cls, trigger: InternalBuilderPCTrigger):
        return normalize_tabs(f"""
        if (pc == {trigger.pc}) begin
            if ({trigger.pipe_stage_var_name} != STAGE_NOT_IN_PIPE) begin
                $display("Instruction already in pipeline");
                $finish;
            end
            
            {trigger.pipe_stage_var_name} = STAGE_BEFORE_PIPE;
        end
        """)
    
    @classmethod
    def _serialize_pipe_stage_var_name(cls, inst: MipsInstruction):
        return f"inst{inst.pc}_pipe_stage"
    
    @classmethod
    def _serialize_future_operand_var_name(cls, pc: int, key: str, from_stage: OpcodeExecutionStage):
        return f"future_{pc}_{key}_{from_stage}"


############## Other stuff ##############

#class MipsObject(object):
#    def __init__(self, value_expression) -> None:
#        self._value_expression = value_expression
#        self._timing = MipsExecutionStageObject.AFTER
#    
#    def __lt__(self, other):
#        return self._generic_comperator(other, "<")
#
#    def __le__(self, other):
#        return self._generic_comperator(other, "<=")
#
#    def __eq__(self, other):
#        return self._generic_comperator(other, "==")
#
#    def __ne__(self, other):
#        return self._generic_comperator(other, "!=")
#
#    def __ge__(self, other):
#        return self._generic_comperator(other, ">=")
#
#    def __gt__(self, other):
#        return self._generic_comperator(other, ">")
#    
#    def _generic_comperator(self, other, logical_operator):
#        other_expression = None
#        if (isinstance(other, int)):
#            other_expression = f"32'd{twos_complement(abs(other), 32) if other < 0 else other}"
#        elif (isinstance(other, MipsObject)):
#            other_expression = other._value_expression
#        else:
#            raise Exception(f"Unsupported type {type(other)}")
#
#        return MipsRuleAssert(self._value_expression, logical_operator, other_expression)
#
#    def __call__(self, *args: Any, **kwds: Any) -> Any:
#        return self._value_expression
#
#    @property
#    def timing(self):
#        return self._timing
#
#    @property
#    def value(self):
#        return self()
#
#class Register(MipsObject):
#    _MIPS_REGISTERS_ARRAY = "U_MIPS_R2000.U_GPR.gprRegisters"
#
#    def __init__(self, reg: str) -> None:
#        lower_reg = reg.lower()
#        assert lower_reg in ALL_REGISTERS, f"Unknown expression {reg}"
#        super().__init__(f"{Register._MIPS_REGISTERS_ARRAY}[{REGISTER_TO_INDEX[lower_reg]}]")
#
#class PC(MipsObject):
#    def __init__(self) -> None:
#        super().__init__("U_MIPS_R2000.U_PCU.PC")
#
#class REGS():
#    ZERO = Register(REGISTERS.REG_ZERO)
#    AT = Register(REGISTERS.REG_AT)
#    V0 = Register(REGISTERS.REG_V0)
#    V1 = Register(REGISTERS.REG_V1)
#    A0 = Register(REGISTERS.REG_A0)
#    A1 = Register(REGISTERS.REG_A1)
#    A2 = Register(REGISTERS.REG_A2)
#    A3 = Register(REGISTERS.REG_A3)
#    T0 = Register(REGISTERS.REG_T0)
#    T1 = Register(REGISTERS.REG_T1)
#    T2 = Register(REGISTERS.REG_T2)
#    T3 = Register(REGISTERS.REG_T3)
#    T4 = Register(REGISTERS.REG_T4)
#    T5 = Register(REGISTERS.REG_T5)
#    T6 = Register(REGISTERS.REG_T6)
#    T7 = Register(REGISTERS.REG_T7)
#    S0 = Register(REGISTERS.REG_S0)
#    S1 = Register(REGISTERS.REG_S1)
#    S2 = Register(REGISTERS.REG_S2)
#    S3 = Register(REGISTERS.REG_S3)
#    S4 = Register(REGISTERS.REG_S4)
#    S5 = Register(REGISTERS.REG_S5)
#    S6 = Register(REGISTERS.REG_S6)
#    S7 = Register(REGISTERS.REG_S7)
#    T8 = Register(REGISTERS.REG_T8)
#    T9 = Register(REGISTERS.REG_T9)
#    K0 = Register(REGISTERS.REG_K0)
#    K1 = Register(REGISTERS.REG_K1)
#    GP = Register(REGISTERS.REG_GP)
#    SP = Register(REGISTERS.REG_SP)
#    FP = Register(REGISTERS.REG_FP)
#    RA = Register(REGISTERS.REG_RA)
