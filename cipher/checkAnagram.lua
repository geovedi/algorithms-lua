local AnagramChecker = {}
AnagramChecker.__index = AnagramChecker

function AnagramChecker.new()
    return setmetatable({}, AnagramChecker)
end

function AnagramChecker:calculateFrequency(str)
    local freq = {}
    for i = 1, 26 do
        freq[i] = 0
    end

    for char in str:gmatch("[%a]") do
        local index = string.byte(char:lower()) - string.byte('a') + 1
        freq[index] = freq[index] + 1
    end

    return freq
end

function AnagramChecker:check(a, b)
    local freqA = self:calculateFrequency(a)
    local freqB = self:calculateFrequency(b)

    for i = 1, 26 do
        if freqA[i] ~= freqB[i] then
            return false
        end
    end

    return true
end

local function testCheckAnagram()
    local anagramChecker = AnagramChecker.new()
    local testCases = {
        {a = "listen", b = "silent", expected = true},
        {a = "hello", b = "world", expected = false},
        {a = "cinema", b = "iceman", expected = true},
        {a = "rat", b = "car", expected = false},
        {a = "abc", b = "def", expected = false},
        {a = "aab", b = "bba", expected = false},
        {a = "aabbcc", b = "abcabc", expected = true},
        {a = "", b = "", expected = true},  -- Empty strings are anagrams
    }

    for i, testCase in ipairs(testCases) do
        local result = anagramChecker:check(testCase.a, testCase.b)
        local status = result == testCase.expected and "PASSED" or "FAILED"
        print(string.format("Test Case %d: %s", i, status))
        print(string.format("  Input: '%s' and '%s'", testCase.a, testCase.b))
        print(string.format("  Expected: %s", testCase.expected))
        print(string.format("  Result: %s\n", result))
    end
end

-- Run the tests
testCheckAnagram()
