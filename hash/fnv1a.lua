local FNV1a = {}
FNV1a.__index = FNV1a

function FNV1a.new()
    local self = setmetatable({}, FNV1a)
    self.prime = 0x01000193
    self.hashValue = 0x811c9dc5
    return self
end

function FNV1a:hash(str)
    local hash = self.hashValue
    for i = 1, #str do
        local byte = string.byte(str, i)
        hash = (hash ~ byte) * self.prime
    end
    return hash & 0xffffffff
end

local function testFNV1a()
    local fnv1a = FNV1a.new()
    local testCases = {
        {input = "Hello", expected = 0xf55c314b},
        {input = "World", expected = 0xdd60ed33},
        {input = "Lua!", expected = 0xd41a8e0},
    }
    
    for i, testCase in ipairs(testCases) do
        local hash = fnv1a:hash(testCase.input)
        local passed = hash == testCase.expected
        --print(string.format("%x", hash), string.format("%x", testCase.expected))
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

-- Run tests
testFNV1a()
