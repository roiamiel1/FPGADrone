def twos_complement(value, bitWidth):
    result = 2 ** bitWidth - value
    assert result > 0, f"Value: {value} out of range for {bitWidth}-bit two complement."
    return result 
