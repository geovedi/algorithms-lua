-- Lagged Fibonacci generator implementation
function lagged_fibonacci(s, j, k, m)
    local state = {}
    local idx = 0

    for i = 1, math.max(j, k) do
        state[i] = s[i % #s + 1]
    end

    return function()
        idx = idx % math.max(j, k) + 1
        state[idx] = (state[(idx - j - 1) % math.max(j, k) + 1] + state[(idx - k - 1) % math.max(j, k) + 1]) % m
        return state[idx] / m
    end
end

-- Test function
function tests()
    local test_cases = {
        {
            s = {1, 2, 3, 4, 5},
            j = 3,
            k = 5,
            m = 9,
            expected = {6, 8, 5, 2, 0},
        },
        {
            s = {6, 7, 8, 9, 10},
            j = 4,
            k = 5,
            m = 11,
            expected = {4, 6, 8, 5, 10},
        },
        {
            s = {11, 12, 13, 14, 15},
            j = 2,
            k = 3,
            m = 17,
            expected = {8, 10, 5, 1, 15},
        },
        {
            s = {16, 17, 18, 19, 20},
            j = 1,
            k = 5,
            m = 21,
            expected = {12, 9, 7, 6, 1},
        },
        {
            s = {21, 22, 23, 24, 25},
            j = 3,
            k = 4,
            m = 26,
            expected = {19, 21, 23, 18, 14},
        },
    }


    for i, test_case in ipairs(test_cases) do
        local generator = lagged_fibonacci(test_case.s, test_case.j, test_case.k, test_case.m)
        local passed = true
        for j, expected_value in ipairs(test_case.expected) do
            local value = math.floor(generator() * test_case.m)
            if value ~= expected_value then
                passed = false
                break
            end
        end
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

-- Run tests
tests()
