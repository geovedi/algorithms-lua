local Rot13Cipher = {}
Rot13Cipher.__index = Rot13Cipher

function Rot13Cipher.new()
    return setmetatable({}, Rot13Cipher)
end

function Rot13Cipher:apply(s)
    local result = {}
    for i = 1, #s do
        local char = s:sub(i, i)
        local byte = char:byte()
        if byte >= 65 and byte <= 90 then
            byte = 65 + (byte - 65 + 13) % 26
        elseif byte >= 97 and byte <= 122 then
            byte = 97 + (byte - 97 + 13) % 26
        end
        result[#result + 1] = string.char(byte)
    end
    return table.concat(result)
end

local function testRot13()
    local cipher = Rot13Cipher.new()
    
    local testCases = {
        {input = "The more I C, the less I see.", expected = "Gur zber V P, gur yrff V frr."},
        {input = "Which witch switched the Swiss wristwatches?", expected = "Juvpu jvgpu fjvgpurq gur Fjvff jevfgjngpurf?"},
        {input = "Juvpu jvgpu fjvgpurq gur Fjvff jevfgjngpurf?", expected = "Which witch switched the Swiss wristwatches?"},
    }
    
    for _, testCase in ipairs(testCases) do
        assert(cipher:apply(testCase.input) == testCase.expected)
    end
    
    print("All tests have successfully passed!")
end

testRot13()
