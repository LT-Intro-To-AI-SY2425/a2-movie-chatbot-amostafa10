from typing import List

def safeIndex(list, index):
    return list[index] if len(list) > index else None

def match(pattern: List[str], source: List[str]) -> List[str]:
    source.append("")
    output = []

    for patternIndex, patternString in enumerate(pattern):
        if len(source) == 0:
            return None

        percentMatchResult = ""
        percentMatchLength = 0
        nextPatternString = safeIndex(pattern, patternIndex + 1)

        for sourceIndex, sourceString in enumerate(source):
            if patternString == "%":
                if sourceString == nextPatternString:
                    output.append(percentMatchResult.strip())
                    source = source[percentMatchLength:]
                    break
                else:
                    if sourceString != "":
                        percentMatchResult += sourceString + " "
                        percentMatchLength += 1
                    if sourceIndex == len(source) - 1:
                        output.append(percentMatchResult.strip())
                        source = source[percentMatchLength:]
            elif patternString == "_":
                output.append(sourceString)
                del source[sourceIndex]
                break
            else:
                if sourceString == patternString:
                    del source[sourceIndex]
                    break
                return None

    return output if safeIndex(source, 0) == "" else None




if __name__ == "__main__":
    assert match(["x", "y", "z"], ["x", "y", "z"]) == [], "test 1 failed"
    assert match(["x", "z", "z"], ["x", "y", "z"]) == None, "test 2 failed"
    assert match(["x", "y"], ["x", "y", "z"]) == None, "test 3 failed"
    assert match(["x", "y", "z", "z"], ["x", "y", "z"]) == None, "test 4 failed"
    assert match(["x", "_", "z"], ["x", "y", "z"]) == ["y"], "test 5 failed"
    assert match(["x", "_", "_"], ["x", "y", "z"]) == ["y", "z"], "test 6 failed"
    assert match(["%"], ["x", "y", "z"]) == ["x y z"], "test 7 failed"
    assert match(["x", "%", "z"], ["x", "y", "z"]) == ["y"], "test 8 failed"
    assert match(["%", "z"], ["x", "y", "z"]) == ["x y"], "test 9 failed"
    assert match(["x", "%", "y"], ["x", "y", "z"]) == None, "test 10 failed"
    assert match(["x", "%", "y", "z"], ["x", "y", "z"]) == [""], "test 11 failed"
    assert match(["x", "y", "z", "%"], ["x", "y", "z"]) == [""], "test 12 failed"
    assert match(["_", "%"], ["x", "y", "z"]) == ["x", "y z"], "test 13 failed"
    assert match(["_", "_", "_", "%"], ["x", "y", "z"]) == [ "x", "y", "z", "",], "test 14 failed"
    assert match(["x", "%", "z"], ["x", "y", "z", "z", "z"]) == None, "test 15 failed"

    print("All tests passed!")
