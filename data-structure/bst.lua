-- Define the tree node structure
local Node = {}
Node.__index = Node

function Node.new(data)
    local self = setmetatable({}, Node)
    self.data = data
    self.left = nil
    self.right = nil
    return self
end

-- Define the binary tree structure
local BinaryTree = {}
BinaryTree.__index = BinaryTree

function BinaryTree.new()
    local self = setmetatable({}, BinaryTree)
    self.root = nil
    return self
end

function BinaryTree:insert(value)
    local newNode = Node.new(value)
    if not self.root then
        self.root = newNode
    else
        local current = self.root
        local parent
        while current do
            parent = current
            if value < current.data then
                current = current.left
            else
                current = current.right
            end
        end
        if value < parent.data then
            parent.left = newNode
        else
            parent.right = newNode
        end
    end
end

function BinaryTree:deleteNode(value)
    local function findMin(node)
        while node.left do
            node = node.left
        end
        return node
    end

    local function delete(root, val)
        if not root then
            return root
        end

        if val < root.data then
            root.left = delete(root.left, val)
        elseif val > root.data then
            root.right = delete(root.right, val)
        else
            if not root.left then
                return root.right
            elseif not root.right then
                return root.left
            end

            local temp = findMin(root.right)
            root.data = temp.data
            root.right = delete(root.right, temp.data)
        end

        return root
    end

    self.root = delete(self.root, value)
end

function BinaryTree:displayInOrder()
    local function inorderTraversal(node)
        if node then
            inorderTraversal(node.left)
            io.write(node.data .. " ")
            inorderTraversal(node.right)
        end
    end
    inorderTraversal(self.root)
end

function BinaryTree:countLeaves()
    local function countLeaves(node)
        if not node then
            return 0
        elseif not node.left and not node.right then
            return 1
        else
            return countLeaves(node.left) + countLeaves(node.right)
        end
    end
    return countLeaves(self.root)
end

function BinaryTree:countInteriorNodes()
    local function countNodes(node)
        if not node then
            return 0
        elseif node.left or node.right then
            return 1 + countNodes(node.left) + countNodes(node.right)
        else
            return 0
        end
    end
    return countNodes(self.root)
end

function BinaryTree:countNodes()
    return self:countLeaves() + self:countInteriorNodes()
end

-- Function to create a binary tree and perform operations
local function tests()
    local tree = BinaryTree.new()

    -- Define test cases with input values and expected results
    local test_cases = {
        {input = {50, 30, 70, 20, 40, 60, 80}, expected_in_order = "20 40 50 60 70 80", valueToDelete = 30},
        {input = {45, 55, 15, 35, 90}, expected_in_order = "15 35 55 90", valueToDelete = 45},
        {input = {50, 30, 70, 20, 40, 60, 80}, expected_in_order = "20 30 40 50 60 80", valueToDelete = 70},
        {input = {45, 55, 15, 35, 90}, expected_in_order = "35 45 55 90", valueToDelete = 15},
        -- Add more test cases here
    }

    for _, test_case in ipairs(test_cases) do
        tree.root = nil -- Reset the tree for each test case
        for _, value in ipairs(test_case.input) do
            tree:insert(value)
        end

        -- Display the initial tree
        io.write("Initial In-order traversal of the tree: ")
        tree:displayInOrder()
        io.write("\n")

        -- Delete the specified value
        tree:deleteNode(test_case.valueToDelete)

        -- Display the tree after deletion
        io.write("In-order traversal of the tree after deletion: ")
        tree:displayInOrder()
        io.write("\n")

        local result = ""
        local function inorderTraversal(node)
            if node then
                inorderTraversal(node.left)
                result = result .. node.data .. " "
                inorderTraversal(node.right)
            end
        end
        inorderTraversal(tree.root)

        -- Trim leading and trailing whitespace from both result and expected_in_order
        result = result:match("^%s*(.-)%s*$")
        local expected = test_case.expected_in_order:match("^%s*(.-)%s*$")

        print("  Result: " .. result)
        print("  Expected: " .. expected)

        -- Compare the trimmed strings
        if result == expected then
            print("Test PASSED\n")
        else
            print("Test FAILED\n")
        end
    end
end

-- Run the binary tree creation and test
tests()

