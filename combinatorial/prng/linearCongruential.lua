local LinearCongruentialGenerator = {}
LinearCongruentialGenerator.__index = LinearCongruentialGenerator

function LinearCongruentialGenerator.new(seed, a, c, m)
    return setmetatable({state = seed, a = a, c = c, m = m}, LinearCongruentialGenerator)
end

function LinearCongruentialGenerator:next()
    self.state = (self.a * self.state + self.c) % self.m
    return self.state / self.m
end

local function testLinearCongruential()
    local testCases = {
        {seed = 1, a = 2, c = 3, m = 5, expected = {0.0, 0.6, 0.8, 0.2, 0.0}},
        {seed = 0, a = 2, c = 3, m = 7, expected = {0.42857142857143, 0.28571428571429, 0.0, 0.42857142857143, 0.28571428571429}},
        {seed = 5, a = 3, c = 3, m = 7, expected = {0.57142857142857, 0.14285714285714, 0.85714285714286, 0.0, 0.42857142857143}},
        {seed = 7, a = 4, c = 3, m = 11, expected = {0.81818181818182, 0.54545454545455, 0.45454545454545, 0.090909090909091, 0.63636363636364}},
        {seed = 1, a = 5, c = 5, m = 7, expected = {0.42857142857143, 0.85714285714286, 0.0, 0.71428571428571, 0.28571428571429}},
    }

    for i, testCase in ipairs(testCases) do
        local generator = LinearCongruentialGenerator.new(testCase.seed, testCase.a, testCase.c, testCase.m)
        local passed = true
        for j, expectedValue in ipairs(testCase.expected) do
            local value = generator:next()
            if math.abs(value - expectedValue) > 1e-5 then
                passed = false
                break
            end
        end
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

testLinearCongruential()
