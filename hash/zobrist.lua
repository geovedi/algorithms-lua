local Zobrist = {}
Zobrist.__index = Zobrist

function Zobrist.new(rows, columns)
    local self = setmetatable({}, Zobrist)
    self.ztable = self:generateTable(rows, columns)
    return self
end

function Zobrist:hash(board)
    local hash = 0
    for i, value in ipairs(board) do
        hash = hash ~ self.ztable[i][value]
    end
    return hash
end

function Zobrist:generateTable(rows, columns)
    local ztable = {}
    for i = 1, rows do
        local row = {}
        for j = 1, columns do
            row[j] = math.random(0, 0xFFFFFFFF)
        end
        ztable[i] = row
    end
    return ztable
end

local function testZobrist()
    local zobrist = Zobrist.new(3, 3)
    local testCases = {
        {
            board = {1, 2, 3},
            expected = zobrist:hash({1, 2, 3}),
        },
        {
            board = {2, 3, 1},
            expected = zobrist:hash({2, 3, 1}),
        },
        {
            board = {3, 1, 2},
            expected = zobrist:hash({3, 1, 2}),
        },
        {
            board = {1, 1, 1},
            expected = zobrist:hash({1, 1, 1}),
        },
        {
            board = {3, 3, 3},
            expected = zobrist:hash({3, 3, 3}),
        },
    }

    for i, testCase in ipairs(testCases) do
        local hash = zobrist:hash(testCase.board)
        local passed = hash == testCase.expected
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

testZobrist()
