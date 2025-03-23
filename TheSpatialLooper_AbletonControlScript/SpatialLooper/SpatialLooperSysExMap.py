def SYSEX_COLOR_CHANGE(padID, red, green, blue):
    return (0xF0, 0, padID, red, green, blue, 0xF7)

def SYSEX_CLIP_PRESENT(padID, isPresent):
    presenceBit = 1 if isPresent else 0
    return (0xF0, 0, padID, presenceBit, 0xF7)