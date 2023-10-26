local Node = {}
Node.__index = Node

function Node.new(value)
  local self = setmetatable({}, Node)
  self.value = value
  self.left = nil
  self.right = nil
  return self
end

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
    self:insertNode(self.root, newNode)
  end
end

function BinaryTree:insertNode(root, newNode)
  if newNode.value < root.value then
    if not root.left then
      root.left = newNode
    else
      self:insertNode(root.left, newNode)
    end
  else
    if not root.right then
      root.right = newNode
    else
      self:insertNode(root.right, newNode)
    end
  end
end

function BinaryTree:bfsTraverse()
  local queue = {}
  local result = {}
  if not self.root then return result end
  
  table.insert(queue, self.root)
  
  while #queue > 0 do
    local node = table.remove(queue, 1)
    table.insert(result, node.value)
    
    if node.left then
      table.insert(queue, node.left)
    end
    
    if node.right then
      table.insert(queue, node.right)
    end
  end
  
  return result
end

function testBFS()
  local testCases = {
    {
      values = {5, 3, 8, 1, 4, 7, 9},
      description = "Balanced Binary Tree",
      expected = "5 -> 3 -> 8 -> 1 -> 4 -> 7 -> 9"
    },
    {
      values = {1, 2, 3, 4},
      description = "Skewed Right Binary Tree",
      expected = "1 -> 2 -> 3 -> 4"
    },
    {
      values = {5, 4, 3, 2, 1},
      description = "Skewed Left Binary Tree",
      expected = "5 -> 4 -> 3 -> 2 -> 1"
    }
  }
  
  for i, testCase in ipairs(testCases) do
    local tree = BinaryTree.new()
    for _ , value in ipairs(testCase.values) do
      tree:insert(value)
    end
    
    print("Test Case " .. i .. ": " .. testCase.description)
    local result = table.concat(tree:bfsTraverse(), " -> ")
    print("Elements in BFS order are:\n" .. result .. "\n")
    
    if result == testCase.expected then
      print("Test PASSED\n")
    else
      print("Test FAILED\n")
    end
  end
end

testBFS()
