local brent = {}
brent.__index = brent

function brent.new(f, a, b, tol, max_iter)
    return setmetatable({ f = f, a = a, b = b, tol = tol, max_iter = max_iter }, brent)
end

function brent:sign(x)
    return x < 0 and -1 or 1
end

function brent:find_root()
    local fa, fb = self.f(self.a), self.f(self.b)
    if fa * fb > 0 then return nil, 0 end  -- No root found
    local c, fc = self.a, fa
    local d, e = self.b - self.a, self.b - self.a
    for i = 1, self.max_iter do  -- corrected loop variable
        if math.abs(fc) < math.abs(fb) then
            self.a, self.b, c, fa, fb, fc = self.b, c, self.a, fb, fc, fa
        end
        local tol1 = 0.5 * self.tol
        local xm = 0.5 * (c - self.b)
        if math.abs(xm) <= tol1 or fb == 0 then return self.b, i end  -- Found the root
        if math.abs(e) >= tol1 and math.abs(fa) > math.abs(fb) then
            local s, p, q = fb / fa
            if self.a == c then
                p, q = 2 * xm * s, 1 - s
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
        self.b = math.abs(d) > tol1 and self.b + d or self.b + self:sign(xm) * tol1
        fb = self.f(self.b)
        if fb * fc > 0 then
            c, fc, d, e = self.a, fa, self.b - self.a, self.b - self.a
        end
    end
    return nil, self.max_iter -- Root not found within max iterations
end

local function tests()
    local f1 = function(x) return x^3 + 4*x^2 - 10 end
    local algo1 = brent.new(f1, 1, 2, 1e-6, 100)
    local root1, iter1 = algo1:find_root()
    if root1 then
        print("Test case 1: Root = " .. root1 .. ", Iterations = " .. iter1)
        print("Test case 1: PASSED")
    else
        print("Test case 1: Root = NOT FOUND, Iterations = " .. iter1)
        print("Test case 1: FAILED")
    end

    local f2 = function(x) return x + 3 end
    local algo2 = brent.new(f2, -5, 0, 1e-6, 100)
    local root2, iter2 = algo2:find_root()
    if root2 then
        print("Test case 2: Root = " .. root2 .. ", Iterations = " .. iter2)
        print("Test case 2: PASSED")
    else
        print("Test case 2: Root = NOT FOUND, Iterations = " .. iter2)
        print("Test case 2: FAILED")
    end

    local f3 = function(x) return x^2 - 4 end
    local algo3 = brent.new(f3, 1, 2, 1e-6, 100)
    local root3, iter3 = algo3:find_root()
    if root3 then
        print("Test case 3: Root = " .. root3 .. ", Iterations = " .. iter3)
        print("Test case 3: PASSED")
    else
        print("Test case 3: Root = NOT FOUND, Iterations = " .. iter3)
        print("Test case 3: FAILED")
    end
end

tests()


