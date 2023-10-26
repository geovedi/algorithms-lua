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

local HopcroftKarp = {}
HopcroftKarp.__index = HopcroftKarp

function HopcroftKarp.new(graph, U, V)
    local self = setmetatable({}, HopcroftKarp)
    self.graph = graph
    self.U = U
    self.V = V
    self.pairU = {}
    self.pairV = {}
    self.dist = {}
    self.NIL = 0

    for u in pairs(self.U) do self.pairU[u] = self.NIL end
    for v in pairs(self.V) do self.pairV[v] = self.NIL end

    return self
end

function HopcroftKarp:bfs()
    local queue = {}
    for u in pairs(self.U) do
        if self.pairU[u] == self.NIL then
            self.dist[u] = 0
            table.insert(queue, u)
        else
            self.dist[u] = math.huge
        end
    end
    self.dist[self.NIL] = math.huge

    while #queue > 0 do
        local u = table.remove(queue, 1)
        if self.dist[u] < self.dist[self.NIL] then
            for _, v in ipairs(self.graph[u]) do
                if self.dist[self.pairV[v]] == math.huge then
                    self.dist[self.pairV[v]] = self.dist[u] + 1
                    table.insert(queue, self.pairV[v])
                end
            end
        end
    end
    return self.dist[self.NIL] ~= math.huge
end

function HopcroftKarp:dfs(u)
    if u ~= self.NIL then
        for _, v in ipairs(self.graph[u]) do
            if self.dist[self.pairV[v]] == self.dist[u] + 1 and self:dfs(self.pairV[v]) then
                self.pairV[v] = u
                self.pairU[u] = v
                return true
            end
        end
        self.dist[u] = math.huge
        return false
    end
    return true
end

function HopcroftKarp:run()
    local matching = 0
    while self:bfs() do
        for u in pairs(self.U) do
            if self.pairU[u] == self.NIL and self:dfs(u) then
                matching = matching + 1
            end
        end
    end
    return matching
end


local function testHopcroftKarp()
    local testCases = {
        {
            graph = {[1] = {1, 2}, [2] = {1}, [3] = {2}},
            U = {1, 2, 3},
            V = {1, 2},
            expected = 2,
        },
        {
            graph = {[1] = {1}, [2] = {2}, [3] = {1, 3}},
            U = {1, 2, 3},
            V = {1, 2, 3},
            expected = 3,
        },
        {
            graph = {[1] = {1, 2, 3}, [2] = {1, 3}, [3] = {2, 3}},
            U = {1, 2, 3},
            V = {1, 2, 3},
            expected = 3,
        },
    }

    for i, testCase in ipairs(testCases) do
        local hk = HopcroftKarp.new(testCase.graph, testCase.U, testCase.V)
        local out = hk:run()
        local status = out == testCase.expected and "PASSED" or "FAILED"
        print("Test Case " .. i .. ": " .. status)
        print("  Graph: " .. dumpTable(testCase.graph))
        print("  U: " .. table.concat(testCase.U, ", "))
        print("  V: " .. table.concat(testCase.V, ", "))
        print("  Expected Matching: " .. testCase.expected)
        print("  Actual Matching: " .. out)
    end
end

testHopcroftKarp()
