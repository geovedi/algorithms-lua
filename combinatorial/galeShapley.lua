local GaleShapley = {}

function GaleShapley:new(men, women)
    local gs = {
        men = men,
        women = women,
        freeMen = {},
        engagedWomen = {},
        engagedMen = {},
        proposals = {}
    }
    setmetatable(gs, self)
    self.__index = self
    return gs
end

function GaleShapley:run()
    self:initializeFreeMenAndProposals()

    while #self.freeMen > 0 do
        local man = table.remove(self.freeMen)
        local woman = self:propose(man)
        local fiance = self.engagedWomen[woman]

        if not fiance then
            self:engage(man, woman)
        else
            self:resolveEngagement(man, woman, fiance)
        end
    end

    return self.engagedMen
end

function GaleShapley:initializeFreeMenAndProposals()
    for man, _ in pairs(self.men) do
        table.insert(self.freeMen, man)
        self.proposals[man] = 0
    end
end

function GaleShapley:propose(man)
    local manPrefList = self.men[man]
    local womanIndex = self.proposals[man] + 1
    self.proposals[man] = womanIndex
    return manPrefList[womanIndex]
end

function GaleShapley:engage(man, woman)
    self.engagedMen[man] = woman
    self.engagedWomen[woman] = man
end

function GaleShapley:resolveEngagement(man, woman, fiance)
    local womanPrefList = self.women[woman]
    local fianceRank, manRank = self:getRanks(fiance, man, womanPrefList)

    if manRank < fianceRank then
        self:engage(man, woman)
        table.insert(self.freeMen, fiance)
    else
        table.insert(self.freeMen, man)
    end
end

function GaleShapley:getRanks(fiance, man, womanPrefList)
    local fianceRank = 0
    local manRank = 0
    for i, m in ipairs(womanPrefList) do
        if m == fiance then
            fianceRank = i
        elseif m == man then
            manRank = i
        end
    end
    return fianceRank, manRank
end

local function testGaleShapley()
    local testCases = {
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

    for i, testCase in ipairs(testCases) do
        local gs = GaleShapley:new(testCase.men, testCase.women)
        local result = gs:run()

        local failed = false
        for man, woman in pairs(testCase.expected) do
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

testGaleShapley()
