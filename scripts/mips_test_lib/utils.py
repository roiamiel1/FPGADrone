import os
from io import StringIO
from pyprinter import printer
from typing import List, Any, Generator, Dict
from string import Formatter


class CodePrinter(printer.Printer):
    def __init__(self):
        string_io = StringIO()
        writer = printer.DefaultWriter(string_io)
        super().__init__(writer, colors=False, width_limit=False)
        self._string_io = string_io

    def assemble(self):
        return self._string_io.getvalue()


def twos_complement(value, bitWidth):
    result = 2 ** bitWidth - value
    assert result > 0, f"Value: {value} out of range for {bitWidth}-bit two complement."
    return result 


def normalize_tabs(text):
    """
    This function rearrange tabs for a given text block.
    for example: `"\tHello\n\tThere" -> "Hello\nThere"`.
    it's good when you want to normalize triple-double-quote block (i.e. \"\"\").
    """
    lines = text.split(os.linesep)

    # Find the line with the shortest whitespace prefix
    shortest_prefix_len = -1 if lines else 0
    for l in lines:
        lstip_len = len(l.lstrip())
        if lstip_len <= 0:
            # This is an empty line -> we will not count it.
            continue
        
        prefix_len = len(l) - lstip_len
        if shortest_prefix_len == -1 or prefix_len < shortest_prefix_len:
            shortest_prefix_len = prefix_len
        
    if shortest_prefix_len > 0:
        # Strip every line to `shortest_prefix_len`.
        lines = [l[shortest_prefix_len:] for l in lines]

    return os.linesep.join(lines).strip()


def extract_format_fields(format_str: str) -> List[str]:
    """
    This function extract the fields names from a given string format,
    for example: `extract_format_fields('{A} and {B} is {C}') -> ['A', 'B', 'C']`
    """
    fmt = Formatter()
    
    format_fields = []
    for (_, field_name, _, _) in fmt.parse(format_str):
        if field_name:
            format_fields.append(field_name)

    return format_fields


def str_format(format_str: str, args: Dict[str, str]) -> str:
    format_keys = set(extract_format_fields(format_str))
    args_keys = set(args.keys())
    assert format_keys.issubset(args_keys), "Missing keys in `args`."

    for key in format_keys:
        assert "{" not in key, "Key can't contain '{'"
        assert "}" not in key, "Key can't contain '}'"
        format_str = format_str.replace("{" + key + "}", args[key])

    return format_str


def unique(l: Generator[Any, None, None]) -> List[Any]:
    """
    This function return a unique list copy of a given generator.
    """
    return list(set(l))