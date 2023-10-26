-- Define the TrieNode structure
local TrieNode = {}
TrieNode.__index = TrieNode

function TrieNode.new()
    local self = setmetatable({}, TrieNode)
    self.children = {}
    self.isEndOfWord = false
    return self
end

-- Define the Trie structure
local Trie = {}
Trie.__index = Trie

function Trie.new()
    local self = setmetatable({}, Trie)
    self.root = TrieNode.new()
    return self
end

-- Function to insert a word into the Trie
function Trie:insert(word)
    local node = self.root
    for i = 1, #word do
        local char = word:sub(i, i)
        if not node.children[char] then
            node.children[char] = TrieNode.new()
        end
        node = node.children[char]
    end
    node.isEndOfWord = true
end

-- Function to search for a word in the Trie
function Trie:search(word)
    local node = self.root
    for i = 1, #word do
        local char = word:sub(i, i)
        if not node.children[char] then
            return false
        end
        node = node.children[char]
    end
    return node.isEndOfWord
end

-- Test function for Trie
function tests()
    print("Running Trie Tests:")
    
    -- Test Case 1: Insert and search for words
    local trie1 = Trie.new()
    trie1:insert("apple")
    trie1:insert("banana")
    assert(trie1:search("apple"), "Test Case 1 FAILED")
    assert(trie1:search("banana"), "Test Case 1 FAILED")
    assert(not trie1:search("cherry"), "Test Case 1 FAILED")
    print("Test Case 1 PASSED")
    
    -- Test Case 2: Insert and search for prefixes
    local trie2 = Trie.new()
    trie2:insert("cat")
    trie2:insert("category")
    assert(trie2:search("cat"), "Test Case 2 FAILED")
    assert(trie2:search("category"), "Test Case 2 FAILED")
    assert(not trie2:search("car"), "Test Case 2 FAILED")
    print("Test Case 2 PASSED")
    
    -- Test Case 3: Insert and search for empty word
    local trie3 = Trie.new()
    trie3:insert("")
    assert(trie3:search(""), "Test Case 3 FAILED")
    assert(not trie3:search("word"), "Test Case 3 FAILED")
    print("Test Case 3 PASSED")
    
    -- Test Case 4: Insert and search for overlapping words
    local trie4 = Trie.new()
    trie4:insert("apple")
    trie4:insert("app")
    assert(trie4:search("apple"), "Test Case 4 FAILED")
    assert(trie4:search("app"), "Test Case 4 FAILED")
    assert(not trie4:search("ap"), "Test Case 4 FAILED")
    print("Test Case 4 PASSED")
    
    print("All Trie Tests PASSED")
end

-- Run the Trie tests
tests()
