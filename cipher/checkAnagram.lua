-- Function to calculate character frequency in a string
function calculateFrequency(str)
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

-- Function to check if two strings are anagrams
function checkAnagram(a, b)
    local freqA = calculateFrequency(a)
    local freqB = calculateFrequency(b)

    for i = 1, 26 do
        if freqA[i] ~= freqB[i] then
            return false
        end
    end

    return true
end

-- Function to run tests and display results
function tests()
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
        local result = checkAnagram(testCase.a, testCase.b)
        local status = result == testCase.expected and "PASSED" or "FAILED"
        print(string.format("Test Case %d: %s", i, status))
        print(string.format("  Input: '%s' and '%s'", testCase.a, testCase.b))
        print(string.format("  Expected: %s", testCase.expected))
        print(string.format("  Result: %s\n", result))
    end
end

-- Run the tests
tests()
