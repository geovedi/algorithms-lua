local CaesarCipher = {}
CaesarCipher.__index = CaesarCipher

function CaesarCipher.new(key)
    local self = setmetatable({}, CaesarCipher)
    self.key = key
    self.alphabetSize = 26
    return self
end

function CaesarCipher:encrypt(text)
    return self:process(text, self.key)
end

function CaesarCipher:decrypt(text)
    return self:process(text, -self.key)
end

function CaesarCipher:process(text, key)
    local result = {}
    for i = 1, #text do
        local char = text:sub(i, i)
        local isUpperCase = char:match("[%u]")
        local isLowerCase = char:match("[%l]")

        if isUpperCase or isLowerCase then
            local base = isUpperCase and string.byte('A') or string.byte('a')
            local index = (string.byte(char) - base + key) % self.alphabetSize
            if index < 0 then
                index = index + self.alphabetSize
            end
            local processedChar = string.char(base + index)
            result[#result + 1] = processedChar
        else
            result[#result + 1] = char
        end
    end
    return table.concat(result)
end

local function testCaesar()
    local testCases = {
        {key = 1, text = "Hello World!", encrypted = "Ifmmp Xpsme!"},
        {key = 3, text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", encrypted = "DEFGHIJKLMNOPQRSTUVWXYZABC"},
        {key = 5, text = "The Quick Brown Fox", encrypted = "Ymj Vznhp Gwtbs Ktc"},
        {key = 13, text = "Caesar Cipher", encrypted = "Pnrfne Pvcure"},
    }

    for i, testCase in ipairs(testCases) do
        local caesarCipher = CaesarCipher.new(testCase.key)
        local encryptedText = caesarCipher:encrypt(testCase.text)
        local decryptedText = caesarCipher:decrypt(encryptedText)

        print("Test Case " .. i .. ":")
        print("  Key: " .. testCase.key)
        print("  Original Text: " .. testCase.text)
        print("  Encrypted Text: " .. encryptedText)
        print("  Decrypted Text: " .. decryptedText)

        local encryptionSuccess = encryptedText == testCase.encrypted
        local decryptionSuccess = decryptedText == testCase.text

        if encryptionSuccess and decryptionSuccess then
            print("  Result: PASSED\n")
        else
            print("  Result: FAILED\n")
        end
    end
end

-- Run the Caesar cipher tests
testCaesar()
