-- BloomFilter class definition
local BloomFilter = {}

function BloomFilter:new(size, numHashFunctions)
    local obj = {
        size = size,                 -- The size of the filter (number of bits)
        numHashFunctions = numHashFunctions, -- Number of hash functions
        filter = {},                 -- The bit array
    }
    setmetatable(obj, self)
    self.__index = self
    return obj:initialize()
end

function BloomFilter:initialize()
    for i = 1, self.size do
        self.filter[i] = false
    end
    return self
end

function BloomFilter:add(value)
    for i = 1, self.numHashFunctions do
        local hash = (self:hash(value, i) % self.size) + 1
        self.filter[hash] = true
    end
end

function BloomFilter:contains(value)
    for i = 1, self.numHashFunctions do
        local hash = (self:hash(value, i) % self.size) + 1
        if not self.filter[hash] then
            return false
        end
    end
    return true
end

-- Test cases
function testBloomFilter()
    local filter = BloomFilter:new(100, 3)

    -- Adding values
    filter:add("apple")
    filter:add("banana")
    filter:add("cherry")

    -- Testing membership
    local test1 = filter:contains("apple")
    local test2 = filter:contains("banana")
    local test3 = filter:contains("cherry")
    local test4 = filter:contains("grape")

    print("Test 1: " .. (test1 and "PASSED" or "FAILED"))
    print("Test 2: " .. (test2 and "PASSED" or "FAILED"))
    print("Test 3: " .. (test3 and "PASSED" or "FAILED"))
    print("Test 4: " .. (not test4 and "PASSED" or "FAILED"))
end

-- Helper function for hashing
function BloomFilter:hash(value, seed)
    local hash = 0
    local multiplier = 31
    for i = 1, #value do
        hash = (hash * multiplier + string.byte(value, i)) + seed
    end
    return hash
end

-- Run the test cases
testBloomFilter()
