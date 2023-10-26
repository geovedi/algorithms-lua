local AcornGenerator = {}
AcornGenerator.__index = AcornGenerator

function AcornGenerator.new(seed, a, c, m)
    local self = setmetatable({}, AcornGenerator)
    self.state = seed
    self.a = a
    self.c = c
    self.m = m
    return self
end

function AcornGenerator:next()
    self.state = (self.a * self.state + self.c) % self.m
    return self.state / self.m
end

local function testAcorn()
    local testCases = {
        {seed = 1, a = 2, c = 3, m = 5, expected = {0.0, 0.6, 0.8, 0.2, 0.0}},
        {seed = 0, a = 2, c = 3, m = 7, expected = {0.42857, 0.28571, 0.0, 0.42857, 0.28571}},
        {seed = 10, a = 3, c = 13, m = 47, expected = {0.91489, 0.02127, 0.34042, 0.29787, 0.17021}},
        {seed = 23, a = 1, c = 27, m = 87, expected = {0.57471, 0.88505, 0.19540, 0.50574, 0.81609}},
        {seed = 88, a = 20, c = 30, m = 75, expected = {0.86666, 0.73333, 0.06666, 0.73333, 0.06666}},
    }
    
    for i, testCase in ipairs(testCases) do
        local generator = AcornGenerator.new(testCase.seed, testCase.a, testCase.c, testCase.m)
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

testAcorn()
