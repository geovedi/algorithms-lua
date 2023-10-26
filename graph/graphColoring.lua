local GraphColoring = {}
GraphColoring.__index = GraphColoring

function GraphColoring.new(graph)
    local self = setmetatable({}, GraphColoring)
    self.graph = graph
    self.colors = {}
    return self
end

function GraphColoring:colorGraph()
    for node, neighbors in pairs(self.graph) do
        local availableColors = {true, true, true, true}
        for _ , neighbor in ipairs(neighbors) do
            local color = self.colors[neighbor]
            if color then
                availableColors[color] = false
            end
        end
        for color, isAvailable in ipairs(availableColors) do
            if isAvailable then
                self.colors[node] = color
                break
            end
        end
    end
    return self.colors
end

local function testGraphColoring()
    local testCases = {
        {
            graph = {
                A = {'B', 'C'},
                B = {'A', 'C', 'D'},
                C = {'A', 'B', 'D'},
                D = {'B', 'C'},
            },
        },
        {
            graph = {
                A = {'B', 'C'},
                B = {'A', 'C'},
                C = {'A', 'B', 'D', 'E'},
                D = {'C', 'E'},
                E = {'C', 'D'},
            },
        },
    }
    
    for i, testCase in ipairs(testCases) do
        local graphColoring = GraphColoring.new(testCase.graph)
        local colors = graphColoring:colorGraph()
        local passed = true
        for node, neighbors in pairs(testCase.graph) do
            local color = colors[node]
            for _ , neighbor in ipairs(neighbors) do
                if color == colors[neighbor] then
                    passed = false
                    break
                end
            end
            if not passed then
                break
            end
        end
        print("Test case " .. i .. ": " .. (passed and "PASSED" or "FAILED"))
    end
end

-- Run tests
testGraphColoring()
