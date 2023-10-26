function graph_coloring(graph)
    local colors = {}
    for node, neighbors in pairs(graph) do
        local available_colors = {true, true, true, true}  -- Assume we have at most 4 colors
        for _, neighbor in ipairs(neighbors) do
            local color = colors[neighbor]
            if color then
                available_colors[color] = false
            end
        end
        for color, is_available in ipairs(available_colors) do
            if is_available then
                colors[node] = color
                break
            end
        end
    end
    return colors
end

function test_graph_coloring()
    local test_cases = {
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
        -- Add more test cases here
    }
    
    for i, test_case in ipairs(test_cases) do
        local colors = graph_coloring(test_case.graph)
        local passed = true
        for node, neighbors in pairs(test_case.graph) do
            local color = colors[node]
            for _, neighbor in ipairs(neighbors) do
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
test_graph_coloring()
