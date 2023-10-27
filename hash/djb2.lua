local DJB2Cipher = {}
DJB2Cipher.__index = DJB2Cipher

function DJB2Cipher:new()
    return setmetatable({}, DJB2Cipher)
end

function DJB2Cipher:encrypt(input)
    local hash = 5381
    for i = 1, #input do
        hash = (hash * 33) + input:byte(i)
    end
    return hash & 0xFFFFFFFF
end

local function testDJB2()
    local cipher = DJB2Cipher:new()
    local testCases = {
        {input = "Hello, world!", expected = 0xE18796AE},
        {input = "The quick brown fox jumps over the lazy dog", expected = 0x34CC38DE},
        {input = "", expected = 0x1505},
    }
    
    for i, testCase in ipairs(testCases) do
        local output = cipher:encrypt(testCase.input)
        local status = output == testCase.expected and "PASSED" or "FAILED"
        print(string.format("Test %d: %s", i, status))
        print(string.format("Input:    '%s'", testCase.input))
        print(string.format("Expected: '%X'", testCase.expected))
        print(string.format("Output:   '%X'", output))
        print()
    end
end

testDJB2()
