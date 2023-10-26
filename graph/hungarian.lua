-- Function to dump a table to a string
local function dumpTable(t, indent)
    indent = indent or ""
    local s = ""
    if type(t) == 'table' then
        s = "{\n"
        for k, v in pairs(t) do
            local formattedKey = type(k) == 'number' and "[" .. k .. "]" or '["' .. k .. '"]'
            s = s .. indent .. "  " .. formattedKey .. " = " .. dumpTable(v, indent .. "  ") .. ",\n"
        end
        s = s .. indent .. "}"
    else
        s = tostring(t)
    end
    return s
end

-- Matrix class for easier handling of matrices
local Matrix = {}
Matrix.__index = Matrix

function Matrix:new(rows, cols)
    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = 0
        end
    end
    return setmetatable({ rows = rows, cols = cols, data = matrix }, { __index = Matrix })
end

function Matrix:copy()
    local newMatrix = Matrix:new(self.rows, self.cols)
    for i = 1, self.rows do
        for j = 1, self.cols do
            newMatrix.data[i][j] = self.data[i][j]
        end
    end
    return newMatrix
end

function Matrix:setValue(row, col, value)
    self.data[row][col] = value
end

function Matrix:getValue(row, col)
    return self.data[row][col]
end

-- Hungarian algorithm class
local Hungarian = {}
Hungarian.__index = Hungarian

function Hungarian:new(matrix)
    local hungarian = {}
    hungarian.originalMatrix = matrix:copy()
    hungarian.matrix = matrix:copy()
    hungarian.rows = matrix.rows
    hungarian.cols = matrix.cols
    hungarian.rowCover = {}
    hungarian.colCover = {}
    hungarian.assignment = {}
    hungarian.z0_r = 0
    hungarian.z0_c = 0
    return setmetatable(hungarian, self)
end

function Hungarian:execute()
    self:step1()
    self:step2()
    while true do
        local done, r, c = self:step3()
        if done then
            break
        end
        self:step4(r, c)
    end
end

function Hungarian:step1()
    for i = 1, self.rows do
        local minVal = math.huge
        for j = 1, self.cols do
            minVal = math.min(minVal, self.matrix:getValue(i, j))
        end
        for j = 1, self.cols do
            self.matrix:setValue(i, j, self.matrix:getValue(i, j) - minVal)
        end
    end
end

function Hungarian:step2()
    for i = 1, self.rows do
        for j = 1, self.cols do
            if self.matrix:getValue(i, j) == 0 and not self.rowCover[i] and not self.colCover[j] then
                self.rowCover[i] = true
                self.colCover[j] = true
                self.assignment[i] = j
            end
        end
    end
    self:clearCovers()
end

function Hungarian:clearCovers()
    for i = 1, self.rows do
        self.rowCover[i] = false
    end
    for j = 1, self.cols do
        self.colCover[j] = false
    end
end

function Hungarian:step3()
    while true do
        local r, c = self:findUncoveredZero()
        if not r then
            return true
        end
        self.rowCover[r] = true
        self.colCover[c] = false
        local starCol = self:findStarInRow(r)
        if starCol then
            self.assignment[r] = c
            c = starCol
            self.rowCover[r] = false
            self.colCover[c] = true
        else
            return false, r, c
        end
    end
end

function Hungarian:findUncoveredZero()
    for i = 1, self.rows do
        if not self.rowCover[i] then
            for j = 1, self.cols do
                if not self.colCover[j] and self.matrix:getValue(i, j) == 0 then
                    return i, j
                end
            end
        end
    end
    return nil, nil
end

function Hungarian:findStarInRow(r)
    for j = 1, self.cols do
        if self.assignment[r] == j then
            return j
        end
    end
    return nil
end

function Hungarian:step4(primeRow, primeCol)
    local path = {}
    local pathIndex = 1
    path[pathIndex] = { primeRow, primeCol }
    local done = false

    while not done do
        local r = self:findStarInCol(path[pathIndex][2])
        if r then
            pathIndex = pathIndex + 1
            path[pathIndex] = { r, path[pathIndex - 1][2] }
        else
            done = true
        end

        if not done then
            local c = self:findPrimeInRow(path[pathIndex][1])
            pathIndex = pathIndex + 1
            path[pathIndex] = { path[pathIndex - 1][1], c }
        end
    end

    self:augmentPath(path)
    self:clearCovers()
    self:clearPrimes()
end

function Hungarian:findPrimeInRow(row)
    for j = 1, self.cols do
        if self.matrix:getValue(row, j) == 2 then
            return j
        end
    end
    return nil
end

function Hungarian:findStarInCol(col)
    for i = 1, self.rows do
        if self.assignment[i] == col then
            return i
        end
    end
    return nil
end

function Hungarian:augmentPath(path)
    for i = 1, #path do
        local r = path[i][1]
        local c = path[i][2]
        if self.assignment[r] == c then
            self.assignment[r] = nil
        else
            self.assignment[r] = c
        end
    end
end

function Hungarian:clearPrimes()
    for i = 1, self.rows do
        for j = 1, self.cols do
            if self.matrix:getValue(i, j) == 2 then
                self.matrix:setValue(i, j, 0)
            end
        end
    end
end

-- Function to assert that two tables are equal
function assertTablesEqual(actual, expected)
    if #actual ~= #expected then
        error("Tables have different lengths")
    end

    for i, value in ipairs(actual) do
        if value ~= expected[i] then
            error("Tables differ at index " .. i)
        end
    end
end

-- Testing the Hungarian algorithm
function runTests()
    local function assertEqual(actual, expected)
        if #actual ~= #expected then
            return "FAILED"
        end
        for i = 1, #actual do
            if actual[i] ~= expected[i] then
                return "FAILED"
            end
        end
        return "PASSED"
    end

    local testCases = {
        {
            matrix = Matrix:new(3, 3),
            expected = {3, 2, 3},
        },
        {
            matrix = Matrix:new(5, 5),
            expected = {5, 2, 3, 4, 5},
        },
        -- Add more test cases as needed
    }

    for i, testCase in ipairs(testCases) do
        local hungarian = Hungarian:new(testCase.matrix)
        hungarian:execute()

        local assignment = hungarian.assignment
        local expected = testCase.expected

        -- Use assertTablesEqual to check for equality
        assertTablesEqual(assignment, expected)
        print("Test " .. i .. ": " .. assertEqual(assignment, expected))
    end
end

-- Run the tests
runTests()
