local AtbashCipher = {}
AtbashCipher.__index = AtbashCipher

function AtbashCipher:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function AtbashCipher:encrypt(plaintext)
    local ciphertext = ""
    for i = 1, #plaintext do
        local c = plaintext:sub(i, i)
        local byte = string.byte(c)
        if byte >= 65 and byte <= 90 then
            ciphertext = ciphertext .. string.char(90 - (byte - 65))
        elseif byte >= 97 and byte <= 122 then
            ciphertext = ciphertext .. string.char(122 - (byte - 97))
        else
            ciphertext = ciphertext .. c
        end
    end
    return ciphertext
end

-- Tests
local function testAtbashCipher()
    local cipher = AtbashCipher:new()
    local testCases = {
        {"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "ZYXWVUTSRQPONMLKJIHGFEDCBA"},
        {"abcdefghijklmnopqrstuvwxyz", "zyxwvutsrqponmlkjihgfedcba"},
        {"1234567890", "1234567890"},
        {"HELLO WORLD", "SVOOL DLIOW"},
        {"Atbash Cipher", "Zgyzhs Xrksvi"},
    }

    for i, testCase in ipairs(testCases) do
        local plaintext, expectedCiphertext = table.unpack(testCase)
        local actualCiphertext = cipher:encrypt(plaintext)
        --print(plaintext, expectedCiphertext, actualCiphertext)
        local status = expectedCiphertext == actualCiphertext and "PASSED" or "FAILED"
        print(string.format("Test %d: %s", i, status))
    end
end

testAtbashCipher()
