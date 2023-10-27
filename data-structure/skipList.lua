-- Node class
local Node = {}
Node.__index = Node

function Node:new(value, level)
  local obj = {
    value = value,
    forward = {},
    level = level,
  }
  setmetatable(obj, Node)
  return obj
end

-- SkipList class
local SkipList = {}
SkipList.__index = SkipList

function SkipList:new(max_level)
  local obj = {
    max_level = max_level or 4,
    header = Node:new(nil, max_level),
    level = 1,
  }
  setmetatable(obj, SkipList)
  return obj
end

function SkipList:random_level()
  local level = 1
  while math.random() < 0.5 and level < self.max_level do
    level = level + 1
  end
  return level
end

function SkipList:insert(value)
  local update = {}
  local current = self.header
  for i = self.level, 1, -1 do
    while current.forward[i] and current.forward[i].value < value do
      current = current.forward[i]
    end
    update[i] = current
  end
  
  local level = self:random_level()
  if level > self.level then
    for i = self.level + 1, level do
      update[i] = self.header
    end
    self.level = level
  end
  
  local new_node = Node:new(value, level)
  for i = 1, level do
    new_node.forward[i] = update[i].forward[i]
    update[i].forward[i] = new_node
  end
end

function SkipList:search(value)
  local current = self.header
  for i = self.level, 1, -1 do
    while current.forward[i] and current.forward[i].value < value do
      current = current.forward[i]
    end
  end
  current = current.forward[1]
  if current and current.value == value then
    return true
  else
    return false
  end
end

-- Tests
local function testSkipList()
  local skip_list = SkipList:new()
  
  skip_list:insert(3)
  skip_list:insert(6)
  skip_list:insert(7)
  skip_list:insert(9)
  skip_list:insert(12)
  skip_list:insert(19)
  
  assert(skip_list:search(3) == true, "Test 1 FAILED")
  assert(skip_list:search(6) == true, "Test 2 FAILED")
  assert(skip_list:search(7) == true, "Test 3 FAILED")
  assert(skip_list:search(9) == true, "Test 4 FAILED")
  assert(skip_list:search(12) == true, "Test 5 FAILED")
  assert(skip_list:search(19) == true, "Test 6 FAILED")
  assert(skip_list:search(4) == false, "Test 7 FAILED")
  
  print("All tests PASSED")
end

testSkipList()
