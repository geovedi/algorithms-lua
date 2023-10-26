local function floyd(f, x0)
    local tortoise = f(x0)
    local hare = f(f(x0))
    while tortoise ~= hare do
        tortoise = f(tortoise)
        hare = f(f(hare))
    end

    local mu = 0
    tortoise = x0
    while tortoise ~= hare do
        tortoise = f(tortoise)
        hare = f(hare)
        mu = mu + 1
    end

    local lam = 1
    hare = f(tortoise)
    while tortoise ~= hare do
        hare = f(hare)
        lam = lam + 1
    end

    return lam, mu
end

local function test_floyd()
    local function test1(x) return (x * x + 1) % 255 end
    local function test2(x) return (x * x + 1) % 254 end
    local function test3(x) return (x * x + 2) % 255 end

    local lam1, mu1 = floyd(test1, 1)
    local expected_lambda_1, expected_mu_1 = 6, 1
    print("Test 1: lambda = " .. lam1 .. ", mu = " .. mu1)
    print(lam1 == expected_lambda_1 and mu1 == expected_mu_1 and "Test 1: PASSED" or "Test 1: FAILED")

    local lam2, mu2 = floyd(test2, 1)
    local expected_lambda_2, expected_mu_2 = 2, 9
    print("Test 2: lambda = " .. lam2 .. ", mu = " .. mu2)
    print(lam2 == expected_lambda_2 and mu2 == expected_mu_2 and "Test 2: PASSED" or "Test 2: FAILED")

    local lam3, mu3 = floyd(test3, 1)
    local expected_lambda_3, expected_mu_3 = 4, 1
    print("Test 3: lambda = " .. lam3 .. ", mu = " .. mu3)
    print(lam3 == expected_lambda_3 and mu3 == expected_mu_3 and "Test 3: PASSED" or "Test 3: FAILED")
end

test_floyd()
