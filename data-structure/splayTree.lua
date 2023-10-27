-- Node class
local Node = {}
Node.__index = Node

function Node:new(key)
  local obj = {
    key = key,
    left = nil,
    right = nil,
    parent = nil,
  }
  setmetatable(obj, Node)
  return obj
end

-- SplayTree class
local SplayTree = {}
SplayTree.__index = SplayTree

function SplayTree:new()
  local obj = {
    root = nil,
  }
  setmetatable(obj, SplayTree)
  return obj
end

function SplayTree:leftRotate(x)
  local y = x.right
  if y then
    x.right = y.left
    if y.left then
      y.left.parent = x
    end
    y.parent = x.parent
    if not x.parent then
      self.root = y
    elseif x == x.parent.left then
      x.parent.left = y
    else
      x.parent.right = y
    end
    y.left = x
    x.parent = y
  end
end

function SplayTree:rightRotate(x)
  local y = x.left
  if y then
    x.left = y.right
    if y.right then
      y.right.parent = x
    end
    y.parent = x.parent
    if not x.parent then
      self.root = y
    elseif x == x.parent.left then
      x.parent.left = y
    else
      x.parent.right = y
    end
    y.right = x
    x.parent = y
  end
end

function SplayTree:splay(x)
  while x.parent do
    if not x.parent.parent then
      if x == x.parent.left then
        self:rightRotate(x.parent)
      else
        self:leftRotate(x.parent)
      end
    elseif x == x.parent.left and x.parent == x.parent.parent.left then
      self:rightRotate(x.parent.parent)
      self:rightRotate(x.parent)
    elseif x == x.parent.right and x.parent == x.parent.parent.right then
      self:leftRotate(x.parent.parent)
      self:leftRotate(x.parent)
    elseif x == x.parent.left and x.parent == x.parent.parent.right then
      self:leftRotate(x.parent)
      self:rightRotate(x.parent)
    else
      self:rightRotate(x.parent)
      self:leftRotate(x.parent)
    end
  end
end

function SplayTree:search(key)
  local x = self.root
  while x do
    if key == x.key then
      self:splay(x)
      return x
    elseif key < x.key then
      x = x.left
    else
      x = x.right
    end
  end
  return nil
end

function SplayTree:insert(key)
  local node = Node:new(key)
  if not self.root then
    self.root = node
    return
  end
  local x = self.root
  while true do
    if key == x.key then
      self:splay(x)
      return
    elseif key < x.key then
      if not x.left then
        x.left = node
        node.parent = x
        break
      end
      x = x.left
    else
      if not x.right then
        x.right = node
        node.parent = x
        break
      end
      x = x.right
    end
  end
  self:splay(node)
end

-- Test
local function testSplayTree()
  local tree = SplayTree:new()
  
  tree:insert(3)
  tree:insert(1)
  tree:insert(2)
  
  assert(tree:search(1) ~= nil, "Test 1 FAILED")
  assert(tree:search(2) ~= nil, "Test 2 FAILED")
  assert(tree:search(3) ~= nil, "Test 3 FAILED")
  assert(tree:search(4) == nil, "Test 4 FAILED")
  
  print("All tests PASSED")
end

testSplayTree()
