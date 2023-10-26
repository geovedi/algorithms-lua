-- Create a vector
local vector = {}

-- Function to initialize a new vector
function vector.new()
    return {}
end

-- Function to add an element to the vector
function vector.push(v, value)
    table.insert(v, value)
end

-- Function to get the size of the vector
function vector.size(v)
    return #v
end

-- Function to access an element by index
function vector.get(v, index)
    return v[index]
end

-- Function to update an element by index
function vector.set(v, index, value)
    v[index] = value
end

-- Function to remove an element by index
function vector.remove(v, index)
    table.remove(v, index)
end

-- Function to iterate over the vector elements
function vector.foreach(v, callback)
    for i, value in ipairs(v) do
        callback(value)
    end
end

-- Test function
function tests()
    print("Running Vector Tests:")
    
    -- Test Case 1: Creating and adding elements
    local v1 = vector.new()
    vector.push(v1, 10)
    vector.push(v1, 20)
    vector.push(v1, 30)
    assert(vector.size(v1) == 3, "Test Case 1 FAILED")
    print("Test Case 1 PASSED")
    
    -- Test Case 2: Accessing and updating elements
    local v2 = vector.new()
    vector.push(v2, 5)
    vector.push(v2, 15)
    vector.set(v2, 2, 25)
    assert(vector.get(v2, 2) == 25, "Test Case 2 FAILED")
    print("Test Case 2 PASSED")
    
    -- Test Case 3: Removing elements
    local v3 = vector.new()
    vector.push(v3, 1)
    vector.push(v3, 2)
    vector.push(v3, 3)
    vector.remove(v3, 2)
    assert(vector.size(v3) == 2, "Test Case 3 FAILED")
    print("Test Case 3 PASSED")
    
    -- Test Case 4: Iterating over elements
    local v4 = vector.new()
    vector.push(v4, 100)
    vector.push(v4, 200)
    vector.push(v4, 300)
    local sum = 0
    vector.foreach(v4, function(value)
        sum = sum + value
    end)
    assert(sum == 600, "Test Case 4 FAILED")
    print("Test Case 4 PASSED")
    
    print("All Vector Tests PASSED")
end

-- Run the vector tests
tests()
