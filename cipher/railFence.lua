-- Function to create the rail matrix
function createRailMatrix(text, key)
    local rail = {}
    for i = 1, key do
        rail[i] = {}
    end

    local dirDown = false
    local row, col = 1, 1

    for i = 1, #text do
        rail[row][col] = true
        
        if row == 1 or row == key then
            dirDown = not dirDown
        end

        if dirDown then
            row = row + 1
        else
            row = row - 1
        end

        col = col + 1
    end

    return rail
end

-- Function to encrypt a message using Rail Fence cipher
function encryptRailFence(text, key)
    local rail = createRailMatrix(text, key)
    local result = ""

    for i = 1, key do
        for j = 1, #text do
            if rail[i][j] then
                result = result .. text:sub(j, j)
            end
        end
    end

    return result
end

-- Function to decrypt a message encrypted with Rail Fence cipher
function decryptRailFence(cipher, key)
    local rail = createRailMatrix(cipher, key)
    local result = ""
    local index = 1

    for i = 1, key do
        for j = 1, #cipher do
            if rail[i][j] then
                rail[i][j] = cipher:sub(index, index)
                index = index + 1
            end
        end
    end

    local dirDown = false
    local row, col = 1, 1

    for i = 1, #cipher do
        result = result .. rail[row][col]

        if row == 1 or row == key then
            dirDown = not dirDown
        end

        if dirDown then
            row = row + 1
        else
            row = row - 1
        end

        col = col + 1
    end

    return result
end

-- Function to test the Rail Fence cipher
function tests()
    local testCases = {
        {text = "Hello World!", key = 2},
        {text = "OpenAI is amazing!", key = 3},
        {text = "Lua is fun!", key = 4},
        {text = "Rail Fence Cipher", key = 5},
    }

    for i, testCase in ipairs(testCases) do
        local text = testCase.text
        local key = testCase.key

        local encryptedText = encryptRailFence(text, key)
        local decryptedText = decryptRailFence(encryptedText, key)

        print("Test Case " .. i .. ":")
        print("  Original Text: " .. text)
        print("  Key: " .. key)
        print("  Encrypted Text: " .. encryptedText)
        print("  Decrypted Text: " .. decryptedText)

        local success = text == decryptedText

        if success then
            print("  Result: PASSED\n")
        else
            print("  Result: FAILED\n")
        end
    end
end

-- Run the Rail Fence cipher tests
tests()
