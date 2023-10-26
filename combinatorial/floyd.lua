local Floyd = {}

function Floyd:new(f, x0)
    local obj = {
        f = f,
        x0 = x0,
        lam = 0,
        mu = 0,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Floyd:run()
    local tortoise = self.f(self.x0)
    local hare = self.f(self.f(self.x0))
    while tortoise ~= hare do
        tortoise = self.f(tortoise)
        hare = self.f(self.f(hare))
    end

    self.mu = 0
    tortoise = self.x0
    while tortoise ~= hare do
        tortoise = self.f(tortoise)
        hare = self.f(hare)
        self.mu = self.mu + 1
    end

    self.lam = 1
    hare = self.f(tortoise)
    while tortoise ~= hare do
        hare = self.f(hare)
        self.lam = self.lam + 1
    end
end

local function testFloyd()
    local tests = {
        { f = function(x) return (x * x + 1) % 255 end, x0 = 1, expectedLambda = 6, expectedMu = 1 },
        { f = function(x) return (x * x + 1) % 254 end, x0 = 1, expectedLambda = 2, expectedMu = 9 },
        { f = function(x) return (x * x + 2) % 255 end, x0 = 1, expectedLambda = 4, expectedMu = 1 },
    }

    for i, test in ipairs(tests) do
        local floyd = Floyd:new(test.f, test.x0)
        floyd:run()
        print("Test " .. i .. ": lambda = " .. floyd.lam .. ", mu = " .. floyd.mu)
        print(floyd.lam == test.expectedLambda and floyd.mu == test.expectedMu and "Test " .. i .. ": PASSED" or "Test " .. i .. ": FAILED")
    end
end

testFloyd()
