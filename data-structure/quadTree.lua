-- Point class
local Point = {}
Point.__index = Point

function Point:new(x, y)
  local obj = {
    x = x,
    y = y,
  }
  setmetatable(obj, Point)
  return obj
end

-- Rectangle class
local Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:new(x, y, width, height)
  local obj = {
    x = x,
    y = y,
    width = width,
    height = height,
  }
  setmetatable(obj, Rectangle)
  return obj
end

function Rectangle:contains(point)
  return point.x >= self.x and
         point.x <= self.x + self.width and
         point.y >= self.y and
         point.y <= self.y + self.height
end

-- QuadTree class
local QuadTree = {}
QuadTree.__index = QuadTree

function QuadTree:new(boundary, capacity)
  local obj = {
    boundary = boundary,
    capacity = capacity,
    points = {},
    divided = false,
  }
  setmetatable(obj, QuadTree)
  return obj
end

function QuadTree:subdivide()
  local x = self.boundary.x
  local y = self.boundary.y
  local w = self.boundary.width
  local h = self.boundary.height

  local nw = Rectangle:new(x, y, w / 2, h / 2)
  local ne = Rectangle:new(x + w / 2, y, w / 2, h / 2)
  local sw = Rectangle:new(x, y + h / 2, w / 2, h / 2)
  local se = Rectangle:new(x + w / 2, y + h / 2, w / 2, h / 2)

  self.northwest = QuadTree:new(nw, self.capacity)
  self.northeast = QuadTree:new(ne, self.capacity)
  self.southwest = QuadTree:new(sw, self.capacity)
  self.southeast = QuadTree:new(se, self.capacity)

  self.divided = true
end

function QuadTree:insert(point)
  if not self.boundary:contains(point) then
    return false
  end

  if #self.points < self.capacity then
    table.insert(self.points, point)
    return true
  else
    if not self.divided then
      self:subdivide()
    end

    if self.northwest:insert(point) or
       self.northeast:insert(point) or
       self.southwest:insert(point) or
       self.southeast:insert(point) then
      return true
    end
  end
end

function QuadTree:query(range, found)
  found = found or {}

  if not self.boundary:contains(range) then
    return found
  end

  for _, point in ipairs(self.points) do
    if range:contains(point) then
      table.insert(found, point)
    end
  end

  if self.divided then
    self.northwest:query(range, found)
    self.northeast:query(range, found)
    self.southwest:query(range, found)
    self.southeast:query(range, found)
  end

  return found
end

-- Test
local function testQuadTree()
  local boundary = Rectangle:new(0, 0, 100, 100)
  local qt = QuadTree:new(boundary, 4)

  local p1 = Point:new(25, 25)
  local p2 = Point:new(75, 75)
  local p3 = Point:new(50, 50)
  local p4 = Point:new(10, 10)
  local p5 = Point:new(90, 90)

  assert(qt:insert(p1) == true, "Test 1 FAILED")
  assert(qt:insert(p2) == true, "Test 2 FAILED")
  assert(qt:insert(p3) == true, "Test 3 FAILED")
  assert(qt:insert(p4) == true, "Test 4 FAILED")
  assert(qt:insert(p5) == true, "Test 5 FAILED")

  local range = Rectangle:new(0, 0, 50, 50)
  local found = qt:query(range)
  assert(#found == 3, "Test 6 FAILED")
  print("All tests PASSED")
end

testQuadTree()
