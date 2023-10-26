local BlumBlumShubGenerator = {}
BlumBlumShubGenerator.__index = BlumBlumShubGenerator

function BlumBlumShubGenerator.new(seed, p, q)
    local self = setmetatable({}, BlumBlumShubGenerator)
    self.M = p * q
    self.state = seed % self.M
    return self
end

function BlumBlumShubGenerator:next()
    self.state = (self.state * self.state) % self.M
    return self.state
end

local function testBBS()
    local testCases = {
        {seed = 7, p = 11, q = 19, expected = {7*7 % (11*19), (7*7 % (11*19))^2 % (11*19), ((7*7 % (11*19))^2 % (11*19))^2 % (11*19)}},
        {seed = 3, p = 13, q = 23, expected = {3*3 % (13*23), (3*3 % (13*23))^2 % (13*23), ((3*3 % (13*23))^2 % (13*23))^2 % (13*23)}},
        {seed = 5, p = 17, q = 31, expected = {5*5 % (17*31), (5*5 % (17*31))^2 % (17*31), ((5*5 % (17*31))^2 % (17*31))^2 % (17*31)}},
        {seed = 8, p = 37, q = 41, expected = {8*8 % (37*41), (8*8 % (37*41))^2 % (37*41), ((8*8 % (37*41))^2 % (37*41))^2 % (37*41)}},
        {seed = 6, p = 47, q = 53, expected = {6*6 % (47*53), (6*6 % (47*53))^2 % (47*53), ((6*6 % (47*53))^2 % (47*53))^2 % (47*53)}},
    }
    
    for i, testCase in ipairs(testCases) do
        local generator = BlumBlumShubGenerator.new(testCase.seed, testCase.p, testCase.q)
        local passed = true
        for j, expectedValue in ipairs(testCase.expected) do
            local value = generator:next()
            if value ~= expectedValue then
                passed = false
                break
            end
        end
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

testBBS()
