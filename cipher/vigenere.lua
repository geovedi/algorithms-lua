-- Vigenère Cipher class
local VigenereCipher = {}
VigenereCipher.__index = VigenereCipher

function VigenereCipher:new(key)
    local obj = {
        key = key
    }
    setmetatable(obj, self)
    return obj
end

function VigenereCipher:encrypt(text)
    local encrypted = {}
    local keyIndex = 1
    for i = 1, #text do
        local char = text:sub(i, i)
        local charCode = char:byte()
        if charCode >= 65 and charCode <= 90 then
            local offset = self.key:sub(keyIndex, keyIndex):byte() - 65
            table.insert(encrypted, string.char((charCode - 65 + offset) % 26 + 65))
            keyIndex = keyIndex % #self.key + 1
        else
            table.insert(encrypted, char)
        end
    end
    return table.concat(encrypted)
end

function VigenereCipher:decrypt(text)
    local decrypted = {}
    local keyIndex = 1
    for i = 1, #text do
        local char = text:sub(i, i)
        local charCode = char:byte()
        if charCode >= 65 and charCode <= 90 then
            local offset = self.key:sub(keyIndex, keyIndex):byte() - 65
            table.insert(decrypted, string.char((charCode - 65 - offset + 26) % 26 + 65))
            keyIndex = keyIndex % #self.key + 1
        else
            table.insert(decrypted, char)
        end
    end
    return table.concat(decrypted)
end

-- Tests
local function testVigenereCipher()
    local cipher = VigenereCipher:new("KEY")
    local text = "HELLO WORLD"
    local encrypted = cipher:encrypt(text)
    local decrypted = cipher:decrypt(encrypted)
  
    assert(encrypted ~= text, "Test 1 FAILED")
    assert(decrypted == text, "Test 2 FAILED")
    assert(cipher:encrypt("ABC") == cipher:encrypt("ABC"), "Test 3 FAILED")

    print("All tests PASSED")
end

testVigenereCipher()
