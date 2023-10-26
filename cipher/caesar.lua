-- Function to apply the Caesar cipher
function caesar(key, text, operation)
    local offset = string.byte('A')
    local alphabetSize = 26
    local result = {}

    if operation == 'd' then
        key = -key
    end

    for i = 1, #text do
        local char = text:sub(i, i)
        local isUpperCase = char:match("[%u]")
        local isLowerCase = char:match("[%l]")

        if isUpperCase or isLowerCase then
            local base = isUpperCase and string.byte('A') or string.byte('a')
            local index = (string.byte(char) - base + key) % alphabetSize

            if index < 0 then
                index = index + alphabetSize
            end

            local encryptedChar = string.char(base + index)
            result[#result + 1] = encryptedChar
        else
            result[#result + 1] = char
        end
    end

    return table.concat(result)
end

-- Function to test the Caesar cipher
function test_caesar()
    local test_cases = {
        {key = 1, text = "Hello World!", encrypted = "Ifmmp Xpsme!", decrypted = "Hello World!"},
        {key = 3, text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", encrypted = "DEFGHIJKLMNOPQRSTUVWXYZABC", decrypted = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"},
        {key = 5, text = "The Quick Brown Fox", encrypted = "Ymj Vznhp Gwtbs Ktc", decrypted = "The Quick Brown Fox"},
        {key = 13, text = "Caesar Cipher", encrypted = "Pnrfne Pvcure", decrypted = "Caesar Cipher"},
    }

    for i, test_case in ipairs(test_cases) do
        local key = test_case.key
        local text = test_case.text
        local encrypted_text = caesar(key, text, 'e')
        local decrypted_text = caesar(key, encrypted_text, 'd')

        print("Test Case " .. i .. ":")
        print("  Key: " .. key)
        print("  Original Text: " .. text)
        print("  Encrypted Text: " .. encrypted_text)
        print("  Decrypted Text: " .. decrypted_text)

        local encryption_success = encrypted_text == test_case.encrypted
        local decryption_success = decrypted_text == test_case.decrypted

        if encryption_success and decryption_success then
            print("  Result: PASSED\n")
        else
            print("  Result: FAILED\n")
        end
    end
end

-- Run the Caesar cipher tests
test_caesar()
