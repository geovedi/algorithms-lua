function fnv1a(str)
    local prime = 0x01000193
    local hash = 0x811c9dc5
    for i = 1, #str do
        local byte = string.byte(str, i)
        hash = (hash ~ byte) * prime
    end
    return hash & 0xffffffff
end

function test_fnv1a()
    local test_cases = {
        {input = "Hello", expected = 0xf55c314b},
        {input = "World", expected = 0xdd60ed33},
        {input = "Lua!", expected = 0xd41a8e0},
    }
    
    for i, test_case in ipairs(test_cases) do
        local hash = fnv1a(test_case.input)
        local passed = hash == test_case.expected
        print(string.format("%x", hash), string.format("%x", test_case.expected))
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

-- Run tests
test_fnv1a()
