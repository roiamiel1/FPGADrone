import argparse
from mips_test_lib.test_builder import TestBuilder, FALSE_CONDITION, TRUE_CONDITION


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--insts", type=str, help="input path for test instructions file", required=True)
    parser.add_argument("--hex", type=str, help="input path for hex file, will be loaded to cpu instruction memory", required=True)
    parser.add_argument("--tb", type=str, help="output path for test bench file", required=True)
    parser.add_argument("--asm", type=str, help="output path for asm file", required=True)
    parser.add_argument("--test-out-path", type=str, help="output path for test files", required=True)
    args = parser.parse_args()

    print("Start generate test")

    insts = None
    with open(args.insts, "r") as f:
        copy_locals = locals().copy()
        copy_globals = globals().copy()
        copy_globals["TRUE"] = TRUE_CONDITION
        copy_globals["FALSE"] = FALSE_CONDITION
        exec(f"insts = {f.read()}", copy_globals, copy_locals)
        insts = copy_locals["insts"]
        assert type(insts) is list, f"{args.insts} must contain a list ([...])"
    
    print(f"Found {len(insts)} test instructions")
    
    builder = TestBuilder(hex_path=args.hex, output_folder_path=args.test_out_path)
    builder.attach_instructions(insts).write(
        output_path_tb=args.tb,
        output_path_asm=args.asm
    )

    print(f"Saved tb: {args.tb}")
    print(f"Saved asm: {args.asm}")
    print("Test tb and asm generated successfully!")


if __name__ == "__main__":
    main()

