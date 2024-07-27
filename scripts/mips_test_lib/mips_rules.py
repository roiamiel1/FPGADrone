from typing import Any, Callable


class MipsRule(object):
    def __init__(self, generate_function: Callable[[int], str]) -> None:
        super().__init__()
        self._generate_function = generate_function

    def __call__(self, *args: Any, **kwds: Any) -> Any:
        return self._generate_function(*args, **kwds)


class MipsRuleAssert(MipsRule):
    def __init__(self, actual_expression, logical_operator, expected_expression) -> None:
        def __inner_function__(inst: str, instruction_index: int):
            return f"""
if (cycles == {instruction_index + 5} && !({actual_expression} {logical_operator} {expected_expression})) begin
    $display("ASSERTION FAILED `{inst}`: signal(%8X) != value(%8X)", {actual_expression}, {expected_expression});
    $finish;
end
            """
        super().__init__(__inner_function__)
