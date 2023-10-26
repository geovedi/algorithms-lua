local Vector = {}
Vector.__index = Vector

function Vector.new()
    local self = setmetatable({}, Vector)
    self.data = {}
    return self
end

function Vector:push(value)
    table.insert(self.data, value)
end

function Vector:size()
    return #self.data
end

function Vector:get(index)
    return self.data[index]
end

function Vector:set(index, value)
    self.data[index] = value
end

function Vector:remove(index)
    table.remove(self.data, index)
end

function Vector:foreach(callback)
    for i, value in ipairs(self.data) do
        callback(value)
    end
end

local function testVector()
    print("Running Vector Tests:")
    
    -- Test Case 1: Creating and adding elements
    local v1 = Vector.new()
    v1:push(10)
    v1:push(20)
    v1:push(30)
    assert(v1:size() == 3, "Test Case 1 FAILED")
    print("Test Case 1 PASSED")
    
    -- Test Case 2: Accessing and updating elements
    local v2 = Vector.new()
    v2:push(5)
    v2:push(15)
    v2:set(2, 25)
    assert(v2:get(2) == 25, "Test Case 2 FAILED")
    print("Test Case 2 PASSED")
    
    -- Test Case 3: Removing elements
    local v3 = Vector.new()
    v3:push(1)
    v3:push(2)
    v3:push(3)
    v3:remove(2)
    assert(v3:size() == 2, "Test Case 3 FAILED")
    print("Test Case 3 PASSED")
    
    -- Test Case 4: Iterating over elements
    local v4 = Vector.new()
    v4:push(100)
    v4:push(200)
    v4:push(300)
    local sum = 0
    v4:foreach(function(value)
        sum = sum + value
    end)
    assert(sum == 600, "Test Case 4 FAILED")
    print("Test Case 4 PASSED")
    
    print("All Vector Tests PASSED")
end

-- Run the vector tests
testVector()
