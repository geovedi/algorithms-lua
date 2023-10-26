-- Blum Blum Shub generator implementation
function bbs(seed, p, q)
    local M = p * q
    local state = seed % M

    return function()
        state = (state * state) % M
        return state
    end
end

-- Test function
function test_bbs()
    local test_cases = {
        {seed = 7, p = 11, q = 19, expected = {7*7 % (11*19), (7*7 % (11*19))^2 % (11*19), ((7*7 % (11*19))^2 % (11*19))^2 % (11*19)}},
        {seed = 3, p = 13, q = 23, expected = {3*3 % (13*23), (3*3 % (13*23))^2 % (13*23), ((3*3 % (13*23))^2 % (13*23))^2 % (13*23)}},
        {seed = 5, p = 17, q = 31, expected = {5*5 % (17*31), (5*5 % (17*31))^2 % (17*31), ((5*5 % (17*31))^2 % (17*31))^2 % (17*31)}},
        {seed = 8, p = 37, q = 41, expected = {8*8 % (37*41), (8*8 % (37*41))^2 % (37*41), ((8*8 % (37*41))^2 % (37*41))^2 % (37*41)}},
        {seed = 6, p = 47, q = 53, expected = {6*6 % (47*53), (6*6 % (47*53))^2 % (47*53), ((6*6 % (47*53))^2 % (47*53))^2 % (47*53)}},
    }
    
    for i, test_case in ipairs(test_cases) do
        local generator = bbs(test_case.seed, test_case.p, test_case.q)
        local passed = true
        for j, expected_value in ipairs(test_case.expected) do
            local value = generator()
            if value ~= expected_value then
                passed = false
                break
            end
        end
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

-- Run tests
test_bbs()
