-- Apply the ROT13 cipher
function rot13(s)
    local result = {}
    for i = 1, #s do
        local char = s:sub(i, i)
        local byte = char:byte()
        if byte >= 65 and byte <= 90 then
            -- Uppercase letters
            byte = 65 + (byte - 65 + 13) % 26
        elseif byte >= 97 and byte <= 122 then
            -- Lowercase letters
            byte = 97 + (byte - 97 + 13) % 26
        end
        result[#result + 1] = string.char(byte)
    end
    return table.concat(result)
end

-- Self-test implementations
function tests()
    local test_01 = "The more I C, the less I see."
    assert(rot13(test_01) == "Gur zber V P, gur yrff V frr.")

    local test_02 = "Which witch switched the Swiss wristwatches?"
    assert(rot13(test_02) == "Juvpu jvgpu fjvgpurq gur Fjvff jevfgjngpurf?")

    local test_03 = "Juvpu jvgpu fjvgpurq gur Fjvff jevfgjngpurf?"
    assert(rot13(test_03) == "Which witch switched the Swiss wristwatches?")

    print("All tests have successfully passed!")
end

tests()