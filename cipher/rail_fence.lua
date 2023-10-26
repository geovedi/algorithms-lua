-- Function to create the rail matrix
function create_rail_matrix(text, key)
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
function encrypt_rail_fence(text, key)
    local rail = create_rail_matrix(text, key)
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
function decrypt_rail_fence(cipher, key)
    local rail = create_rail_matrix(cipher, key)
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
    local test_cases = {
        {text = "Hello World!", key = 2},
        {text = "OpenAI is amazing!", key = 3},
        {text = "Lua is fun!", key = 4},
        {text = "Rail Fence Cipher", key = 5},
    }

    for i, test_case in ipairs(test_cases) do
        local text = test_case.text
        local key = test_case.key

        local encrypted_text = encrypt_rail_fence(text, key)
        local decrypted_text = decrypt_rail_fence(encrypted_text, key)

        print("Test Case " .. i .. ":")
        print("  Original Text: " .. text)
        print("  Key: " .. key)
        print("  Encrypted Text: " .. encrypted_text)
        print("  Decrypted Text: " .. decrypted_text)

        local success = text == decrypted_text

        if success then
            print("  Result: PASSED\n")
        else
            print("  Result: FAILED\n")
        end
    end
end

-- Run the Rail Fence cipher tests
tests()
