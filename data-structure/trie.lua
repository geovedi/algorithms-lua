-- Define the TrieNode structure
local TrieNode = {}
TrieNode.__index = TrieNode

-- Constructor for TrieNode
function TrieNode.new()
    local self = setmetatable({}, TrieNode)
    self.children = {}
    self.isEndOfWord = false
    return self
end

-- Define the Trie structure
local Trie = {}
Trie.__index = Trie

-- Constructor for Trie
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
function testTrie()
    print("Running Trie Tests:")
    testInsertSearchWords()
    testInsertSearchPrefixes()
    testInsertSearchEmptyWord()
    testInsertSearchOverlappingWords()
    print("All Trie Tests PASSED")
end

-- Test Case 1: Insert and search for words
function testInsertSearchWords()
    local trie = Trie.new()
    trie:insert("apple")
    trie:insert("banana")
    assert(trie:search("apple"), "Test Case 1 FAILED")
    assert(trie:search("banana"), "Test Case 1 FAILED")
    assert(not trie:search("cherry"), "Test Case 1 FAILED")
    print("Test Case 1 PASSED")
end

-- Test Case 2: Insert and search for prefixes
function testInsertSearchPrefixes()
    local trie = Trie.new()
    trie:insert("cat")
    trie:insert("category")
    assert(trie:search("cat"), "Test Case 2 FAILED")
    assert(trie:search("category"), "Test Case 2 FAILED")
    assert(not trie:search("car"), "Test Case 2 FAILED")
    print("Test Case 2 PASSED")
end

-- Test Case 3: Insert and search for empty word
function testInsertSearchEmptyWord()
    local trie = Trie.new()
    trie:insert("")
    assert(trie:search(""), "Test Case 3 FAILED")
    assert(not trie:search("word"), "Test Case 3 FAILED")
    print("Test Case 3 PASSED")
end

-- Test Case 4: Insert and search for overlapping words
function testInsertSearchOverlappingWords()
    local trie = Trie.new()
    trie:insert("apple")
    trie:insert("app")
    assert(trie:search("apple"), "Test Case 4 FAILED")
    assert(trie:search("app"), "Test Case 4 FAILED")
    assert(not trie:search("ap"), "Test Case 4 FAILED")
    print("Test Case 4 PASSED")
end

-- Run the Trie tests
testTrie()
