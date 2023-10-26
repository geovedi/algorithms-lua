local LaggedFibonacciGenerator = {}
LaggedFibonacciGenerator.__index = LaggedFibonacciGenerator

function LaggedFibonacciGenerator.new(s, j, k, m)
    local self = setmetatable({}, LaggedFibonacciGenerator)
    self.state = {}
    self.j = j
    self.k = k
    self.m = m
    self.idx = 0

    for i = 1, math.max(j, k) do
        self.state[i] = s[i % #s + 1]
    end

    return self
end

function LaggedFibonacciGenerator:next()
    self.idx = self.idx % math.max(self.j, self.k) + 1
    self.state[self.idx] = (self.state[(self.idx - self.j - 1) % math.max(self.j, self.k) + 1] + self.state[(self.idx - self.k - 1) % math.max(self.j, self.k) + 1]) % self.m
    return self.state[self.idx] / self.m
end

local function testLaggedFibonacci()
    local testCases = {
        {s = {1, 2, 3, 4, 5}, j = 3, k = 5, m = 9, expected = {6, 8, 5, 2, 0}},
        {s = {6, 7, 8, 9, 10}, j = 4, k = 5, m = 11, expected = {4, 6, 8, 5, 10}},
        {s = {11, 12, 13, 14, 15}, j = 2, k = 3, m = 17, expected = {8, 10, 5, 1, 15}},
        {s = {16, 17, 18, 19, 20}, j = 1, k = 5, m = 21, expected = {12, 9, 7, 6, 1}},
        {s = {21, 22, 23, 24, 25}, j = 3, k = 4, m = 26, expected = {19, 21, 23, 18, 14}},
    }

    for i, testCase in ipairs(testCases) do
        local generator = LaggedFibonacciGenerator.new(testCase.s, testCase.j, testCase.k, testCase.m)
        local passed = true
        for j, expectedValue in ipairs(testCase.expected) do
            local value = math.floor(generator:next() * testCase.m)
            if value ~= expectedValue then
                passed = false
                break
            end
        end
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

testLaggedFibonacci()
