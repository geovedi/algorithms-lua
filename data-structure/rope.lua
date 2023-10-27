-- RopeLeaf class
local RopeLeaf = {}
RopeLeaf.__index = RopeLeaf

function RopeLeaf:new(str)
  local obj = {
    str = str or "",
    node_len = #str or 0,
  }
  setmetatable(obj, self)
  return obj
end

-- RopeConcat class
local RopeConcat = {}
RopeConcat.__index = RopeConcat

function RopeConcat:new(left, right)
  local obj = {
    left = left,
    right = right,
    node_len = left.node_len + right.node_len,
    depth = math.max(left.depth, right.depth) + 1,
  }
  setmetatable(obj, self)
  return obj
end

-- Rope class
local Rope = {}
Rope.__index = Rope

function Rope:new(source)
  if type(source) == "string" then
    return RopeLeaf:new(source)
  elseif getmetatable(source) == RopeLeaf or getmetatable(source) == RopeConcat then
    return source:clone()
  else
    error("Unsupported source type for rope")
  end
end

function Rope:concat(rope2)
  return self:new(self):concat(rope2)
end

function RopeConcat:clone()
  return RopeConcat:new(self.left:clone(), self.right:clone())
end

function RopeLeaf:clone()
  return RopeLeaf:new(self.str)
end

-- Concatenation functions
function RopeLeaf:concat(rope2)
  if getmetatable(rope2) == RopeLeaf then
    if self.node_len + rope2.node_len < 20 then
      return RopeLeaf:new(self.str .. rope2.str)
    else
      return RopeConcat:new(self, rope2)
    end
  elseif getmetatable(rope2) == RopeConcat then
    return RopeConcat:new(self, rope2)
  else
    error("Unsupported rope type for concatenation")
  end
end

function RopeConcat:concat(rope2)
  if getmetatable(rope2) == RopeLeaf or getmetatable(rope2) == RopeConcat then
    return RopeConcat:new(self, rope2)
  else
    error("Unsupported rope type for concatenation")
  end
end

-- To string function
function RopeLeaf:toString()
  return self.str
end

function RopeConcat:toString()
  return self.left:toString() .. self.right:toString()
end

-- Tests
local function testRope()
  local rope1 = Rope:new("Hello")
  local rope2 = Rope:new(" World")
  local rope3 = rope1:concat(rope2)

  assert(rope1:toString() == "Hello", "Test 1 FAILED")
  assert(rope2:toString() == " World", "Test 2 FAILED")
  assert(rope3:toString() == "Hello World", "Test 3 FAILED")

  print("All tests PASSED")
end

testRope()
