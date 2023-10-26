local function gale_shapley(men, women)
    local free_men = {}
    local engaged_women = {}
    local engaged_men = {}
    local proposals = {}

    for man, _ in pairs(men) do
        table.insert(free_men, man)
        proposals[man] = 0
    end

    while #free_men > 0 do
        local man = table.remove(free_men)
        local man_pref_list = men[man]
        local woman_index = proposals[man] + 1
        proposals[man] = woman_index
        local woman = man_pref_list[woman_index]
        local fiance = engaged_women[woman]

        if not fiance then
            engaged_men[man] = woman
            engaged_women[woman] = man
        else
            local woman_pref_list = women[woman]
            local fiance_rank = 0
            local man_rank = 0
            for i, m in ipairs(woman_pref_list) do
                if m == fiance then
                    fiance_rank = i
                elseif m == man then
                    man_rank = i
                end
            end
            if man_rank < fiance_rank then
                engaged_men[man] = woman
                engaged_women[woman] = man
                table.insert(free_men, fiance)
            else
                table.insert(free_men, man)
            end
        end
    end

    return engaged_men
end

local function tests()
    local test_cases = {
        {
            men = {
                a = {'Y', 'X', 'Z'},
                b = {'Z', 'Y', 'X'},
                c = {'X', 'Z', 'Y'}
            },
            women = {
                X = {'b', 'a', 'c'},
                Y = {'c', 'b', 'a'},
                Z = {'a', 'c', 'b'}
            },
            expected = {a = 'Y', b = 'Z', c = 'X'}
        },
        {
            men = {
                a = {'Y', 'X', 'Z'},
                b = {'Y', 'X', 'Z'},
                c = {'X', 'Z', 'Y'}
            },
            women = {
                X = {'b', 'a', 'c'},
                Y = {'a', 'b', 'c'},
                Z = {'c', 'b', 'a'}
            },
            expected = {a = 'Y', b = 'X', c = 'Z'}
        },
        {
            men = {
                A = {'B', 'C', 'D'},
                B = {'C', 'A', 'D'},
                C = {'A', 'B', 'D'},
                D = {'A', 'B', 'C'}
            },
            women = {
                A = {'C', 'B', 'D', 'A'},
                B = {'D', 'B', 'A', 'C'},
                C = {'B', 'A', 'D', 'C'},
                D = {'C', 'A', 'B', 'D'}
            },
            expected = {A = 'D', B = 'C', C = 'A', D = 'B'}
        },
    }

    for i, test_case in ipairs(test_cases) do
        local men = test_case.men
        local women = test_case.women
        local expected = test_case.expected
        local result = gale_shapley(men, women)

        local failed = false
        for man, woman in pairs(expected) do
            if result[man] ~= woman then
                failed = true
                break
            end
        end
        if failed then
            print("Test case " .. i .. ": FAILED")
        else
            print("Test case " .. i .. ": PASSED")
        end
    end
end

tests()
