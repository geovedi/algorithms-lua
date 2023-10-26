-- Define the node structure
local node = {
    value = 0,
    left = nil,
    right = nil
}

-- Function to insert a new node into the tree
local function insert(new, root)
    if new.value > root.value then
        if root.right == nil then
            root.right = new
        else
            insert(new, root.right)
        end
    elseif new.value < root.value then
        if root.left == nil then
            root.left = new
        else
            insert(new, root.left)
        end
    end
end

-- Function for breadth-first traversal of the tree
local function bfs_traverse(root, queue)
    if root == nil then
        return
    end

    table.insert(queue, root.value)

    bfs_traverse(root.left, queue)
    bfs_traverse(root.right, queue)
end

-- Function to create a binary tree with predefined values and test BFS traversal
local function testBinaryTree()
    -- Test Case 1: Balanced Binary Tree
    local balancedTree = {
        value = 5,
        left = {
            value = 3,
            left = {
                value = 1,
                left = nil,
                right = nil
            },
            right = {
                value = 4,
                left = nil,
                right = nil
            }
        },
        right = {
            value = 8,
            left = {
                value = 7,
                left = nil,
                right = nil
            },
            right = {
                value = 9,
                left = nil,
                right = nil
            }
        }
    }

    -- Test Case 2: Skewed Right Binary Tree
    local skewedRightTree = {
        value = 1,
        left = nil,
        right = {
            value = 2,
            left = nil,
            right = {
                value = 3,
                left = nil,
                right = {
                    value = 4,
                    left = nil,
                    right = nil
                }
            }
        }
    }

    -- Test Case 3: Skewed Left Binary Tree
    local skewedLeftTree = {
        value = 5,
        left = {
            value = 4,
            left = {
                value = 3,
                left = {
                    value = 2,
                    left = {
                        value = 1,
                        left = nil,
                        right = nil
                    },
                    right = nil
                },
                right = nil
            },
            right = nil
        },
        right = nil
    }

    local testCases = {
        {tree = balancedTree, description = "Balanced Binary Tree", expected = "5 -> 3 -> 1 -> 4 -> 8 -> 7 -> 9"},
        {tree = skewedRightTree, description = "Skewed Right Binary Tree", expected = "1 -> 2 -> 3 -> 4"},
        {tree = skewedLeftTree, description = "Skewed Left Binary Tree", expected = "5 -> 4 -> 3 -> 2 -> 1"}
    }

    for i, testCase in ipairs(testCases) do
        local tree = testCase.tree
        local description = testCase.description
        local expected = testCase.expected

        local queue = {}

        print("Test Case " .. i .. ": " .. description)
        print("Elements in BFS order are:")
        bfs_traverse(tree, queue)

        local result = table.concat(queue, " -> ")

        print(result .. "\n")

        -- Check if the result matches the expected order
        if result == expected then
            print("Test PASSED\n")
        else
            print("Test FAILED\n")
        end
    end
end

-- Run the binary tree tests
testBinaryTree()
