local RootFinder = {}
RootFinder.__index = RootFinder

function RootFinder.new(f, a, b, tol, maxIter)
    return setmetatable({ f = f, a = a, b = b, tol = tol, maxIter = maxIter }, RootFinder)
end

function RootFinder:sign(x)
    return x < 0 and -1 or 1
end

function RootFinder:findRoot()
    local fa, fb = self.f(self.a), self.f(self.b)
    if fa * fb > 0 then return nil, 0 end
    local c, fc = self.a, fa
    local d, e = self.b - self.a, self.b - self.a
    for i = 1, self.maxIter do
        if math.abs(fc) < math.abs(fb) then
            self.a, self.b, c, fa, fb, fc = self.b, c, self.a, fb, fc, fa
        end
        local tol1 = 0.5 * self.tol
        local xm = 0.5 * (c - self.b)
        if math.abs(xm) <= tol1 or fb == 0 then return self.b, i end
        local s = fb / fa
        local p, q
        if math.abs(e) >= tol1 and math.abs(fa) > math.abs(fb) then
            if self.a == c then
                p = 2 * xm * s
                q = 1 - s
            else
                local r = fa / fc
                q = (fa / fb) - 1
                p = s * (2 * xm * q * (q - r) - (self.b - self.a) * (r - 1))
                q = (q - 1) * (r - 1) * (s - 1)
            end
            if p > 0 then q = -q end
            p = math.abs(p)
            if 2 * p < math.min(3 * xm * q - math.abs(tol1 * q), math.abs(e * q)) then
                e, d = d, p / q
            else
                d, e = xm, d
            end
        else
            d, e = xm, d
        end
        self.a, fa = self.b, fb
        if math.abs(d) > tol1 then
            self.b = self.b + d
        else
            self.b = self.b + self:sign(xm) * tol1
        end
        fb = self.f(self.b)
        if fb * fc > 0 then
            c, fc, d, e = self.a, fa, self.b - self.a, self.b - self.a
        end
    end
    return nil, self.maxIter
end

local function testRootFinder()
    local tests = {
        { f = function(x) return x^3 + 4*x^2 - 10 end, a = 1, b = 2, expected = true },
        { f = function(x) return x + 3 end, a = -5, b = 0, expected = true },
        { f = function(x) return x^2 - 4 end, a = 1, b = 2, expected = true },
    }
    local tol, maxIter = 1e-6, 100

    for i, test in ipairs(tests) do
        local finder = RootFinder.new(test.f, test.a, test.b, tol, maxIter)
        local root, iter = finder:findRoot()
        local passed = root ~= nil
        print(string.format("Test case %d: Root = %s, Iterations = %d", i, root or "NOT FOUND", iter))
        print("Test case " .. i .. ": " .. (passed == test.expected and "PASSED" or "FAILED"))
    end
end

testRootFinder()
