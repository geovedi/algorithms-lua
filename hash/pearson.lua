local Pearson = {}
Pearson.__index = Pearson

function Pearson:new()
    local T = {}
    for i = 0, 255 do
        T[i] = i
    end

    -- Shuffle T using a fixed random seed for reproducibility
    math.randomseed(0)
    for i = 255, 1, -1 do
        local j = math.random(0, i)
        T[i], T[j] = T[j], T[i]
    end

    return setmetatable({ T = T }, { __index = self })
end

function Pearson:hash(input)
    local h = 0
    for i = 1, #input do
        local byte = string.byte(input, i)
        h = self.T[(h + byte) % 256]
    end
    return h
end

local function testPearson()
    local pearson = Pearson:new()
    local testCases = {
        { input = "Hello", expected = 21 },
        { input = "World", expected = 58 },
        { input = "Lua!", expected = 243 },
    }

    for i, testCase in ipairs(testCases) do
        local hash = pearson:hash(testCase.input)
        local passed = hash == testCase.expected
        print(testCase.input, hash)
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

testPearson()
