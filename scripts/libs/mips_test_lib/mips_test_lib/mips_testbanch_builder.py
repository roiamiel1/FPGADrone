import os
from typing import NamedTuple, List, Tuple

from .mips_objects import MipsObject, MipsInstruction, MipsTestCondition, OpcodeExecutionStage
from .utils import CodePrinter, normalize_tabs, unique, str_format


# TODO: I copy this from somewhere else.
VERILOG_TEST_FORMAT = """
`include "signal_def.v"

module TESTBENCH (
    input clk,
    input rst
);
    reg clk_debug;
    reg rst_debug;
    reg [31:0] cycles;
    
    MIPS_R2000 U_MIPS_R2000(
        .clk(clk_debug),
        .rst(rst_debug)
    );

    initial begin
        $dumpfile("MIPS_R2000_tb.vcd");
        $dumpvars;
        $readmemh("../../tests/hardware/asm/MIPS_R2000_tb.hex", U_MIPS_R2000.U_InstructionMemory.IMem);

        U_MIPS_R2000.U_IFIDReg.StageReg = 0;
        U_MIPS_R2000.U_IDEXReg.StageReg = 0;
        U_MIPS_R2000.U_EXMEMReg.StageReg = 0;
        U_MIPS_R2000.U_MEMWBReg.StageReg = 0;

        clk_debug = 1;
        rst_debug = 0;
        cycles = 0;

        rst_debug = 1;
        #2 rst_debug = 0;
    end
    
    always begin
        #10 clk_debug = ~clk_debug;
    end

    always @ (posedge rst_debug) begin
        cycles = 0;
    end

    always@(posedge clk_debug) begin
        cycles = cycles + 1;
{VALIDATIONS}
    end

endmodule
"""

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
        self._conditions_vars: List[Tuple[str, int]] = []  # tuple of cariable name and bits count
        self._insts: List[MipsInstruction] = []
        
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
        pipe_stage_var_name = TestbanchBuilderSerializer._serialize_pipe_stage_var_name(inst)

        try:
            self._pipe_stage_vars_names.append(pipe_stage_var_name)
            self._pc_triggers.append(InternalBuilderPCTrigger(pipe_stage_var_name, inst.pc))
            for cond in conditions: self._attach_condition(inst, pipe_stage_var_name, cond)
            self._insts.append(inst)
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

        for (key, timed_obj) in cond.operands.items():
            stage = timed_obj.exec_stage
            obj = timed_obj.obj

            if stage == latest_stage or stage == OpcodeExecutionStage.ANY:
               continue
           
            # This is a future operand, let's store it's value.
            future_key = TestbanchBuilderSerializer._serialize_future_operand_var_name(
                inst.pc, obj.name, stage
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
            self._conditions_vars.append((future_key, obj.bits_count))

        # Now build conditions for the latest operands.
        for (key, timed_obj) in cond.operands.items():
            stage = timed_obj.exec_stage
            obj = timed_obj.obj

            if stage != latest_stage:
                continue

            operands_key_to_future_vars[key] = obj.value
            
        self._conditions.append(InternalBuilderCondition(
            pipe_stage_var_name, latest_stage,
            InternalBuilderConditionLogicTest(
                logic_test=str_format(cond.condition, operands_key_to_future_vars),
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
        func = InternalBuilderConditionLogicTest(str_format(
            cond.condition,
            {key: timed_obj.obj.value for (key, timed_obj) in cond.operands.items()}
        ), "Error")
        self._conditions.append(
            InternalBuilderCondition(pipe_stage_var_name, stage, func)
        )
    
    def build_asm(self):
        printer = CodePrinter()
        for inst in self._insts:
            printer.write_line(inst.opcode)

        printer.write_line()
        return printer.assemble()

    def build_tb(self):
        printer = CodePrinter()
        printer.write_line("################### Consts ###################")

        MAX_EXEC_STAGE = max(OpcodeExecutionStage).value
        for exec_stage in OpcodeExecutionStage:            
            serialize_execution_stage = TestbanchBuilderSerializer._serialize_execution_stage(exec_stage)

            # Why `<MAX_EXEC_STAGE> - exec_stage.value`?
            # The test environment count stages from <MAX_EXEC_STAGE> to 0.
            value = MAX_EXEC_STAGE - exec_stage.value
            if exec_stage == OpcodeExecutionStage.ANY:
                value = -1

            printer.write_line(f"`define {serialize_execution_stage} = {value};")
        printer.write_line()

        printer.write_line("################# Initialize #################")
        printer.write_line(os.linesep.join(
            [TestbanchBuilderSerializer._serialize_initiate_pipe_stage_var(x) for x in self._pipe_stage_vars_names]
        ))
        printer.write_line()
        

        printer.write_line("############### Condition Vars ###############")
        printer.write_line(os.linesep.join(
            [TestbanchBuilderSerializer._serialize_condition_var(name, bits) for (name, bits) in self._conditions_vars]
        ))
        printer.write_line()
        
        printer.write_line("########### Update Pipe Stage Vars ###########")
        printer.write_line((os.linesep * 2).join(
            [TestbanchBuilderSerializer._serialize_update_pipe_stage_var(x) for x in self._pipe_stage_vars_names]
        ))
        printer.write_line()
        
        printer.write_line("################# PC Trigger #################")
        printer.write_line((os.linesep * 2).join(
            [TestbanchBuilderSerializer._serialize_inst_pc_trigger(x) for x in self._pc_triggers]
        ))
        printer.write_line()
        
        printer.write_line("################# Conditions #################")
        printer.write_line(os.linesep.join(
            [TestbanchBuilderSerializer._serialize_builder_condition(x) for x in self._conditions]
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
            (timed_obj.exec_stage for timed_obj in cond.operands.values())
        ))


class TestbanchBuilderSerializer(object):
    @classmethod
    def _serialize_builder_condition(cls, cond: InternalBuilderCondition):
        if isinstance(cond.function, InternalBuilderConditionLogicTest):
            function_str = TestbanchBuilderSerializer._serialize_builder_condition_logic_test(cond)
        elif isinstance(cond.function, InternalBuilderConditionVarAssign):
            function_str = TestbanchBuilderSerializer._serialize_builder_condition_var_assign(cond)
        else:
            raise TypeError(f"Unknown function type {type(cond.function)}")
        
        printer = CodePrinter()

        execution_stage = TestbanchBuilderSerializer._serialize_execution_stage(cond.execution_stage)
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
        return f"{cond.function.var_name} = {cond.function.value.value};"

    @classmethod
    def _serialize_condition_var(cls, condition_var_name: str, condition_var_bits_count: int):
        array_def = TestbanchBuilderSerializer._serialize_def_bits_array(condition_var_bits_count)
        bits_value = TestbanchBuilderSerializer._serialize_bits_value(0, condition_var_bits_count)
        return f"reg{array_def} {condition_var_name} = {bits_value};"

    @classmethod
    def _serialize_def_bits_array(cls, bits_count: int):
        assert bits_count >= 1, f"bits_count: {bits_count} must be >= 1"
        if bits_count == 1:
            return ""
        else:
            return f"[{bits_count - 1}:0]"

    @classmethod
    def _serialize_bits_value(cls, value: int, bits_count: int):
        assert bits_count >= 1, f"bits_count: {bits_count} must be >= 1"
        bites_needed = max(1, value.bit_length())
        assert bites_needed <= bits_count, f"Too many bits required: {bites_needed} for value: {value} but has: {bits_count}"
        if bits_count == 1:
            return f"{value}"
        else:
            return f"{bits_count}'d{value}"

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
        var_name = f"future_{pc}_{key.lower()}_{from_stage.name.lower()}"
        assert var_name.isidentifier(), f"Invalid var name: {var_name}"
        return var_name
    
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
