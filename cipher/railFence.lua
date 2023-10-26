local RailFenceCipher = {}
RailFenceCipher.__index = RailFenceCipher

function RailFenceCipher.new(key)
    local self = setmetatable({}, RailFenceCipher)
    self.key = key
    return self
end

function RailFenceCipher:createRailMatrix(text)
    local rail = {}
    for i = 1, self.key do
        rail[i] = {}
    end

    local dirDown = false
    local row, col = 1, 1

    for i = 1, #text do
        rail[row][col] = true
        
        if row == 1 or row == self.key then
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

function RailFenceCipher:encrypt(text)
    local rail = self:createRailMatrix(text)
    local result = ""

    for i = 1, self.key do
        for j = 1, #text do
            if rail[i][j] then
                result = result .. text:sub(j, j)
            end
        end
    end

    return result
end

function RailFenceCipher:decrypt(cipher)
    local rail = self:createRailMatrix(cipher)
    local result = ""
    local index = 1

    for i = 1, self.key do
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

        if row == 1 or row == self.key then
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

local function testRailFence()
    local testCases = {
        {text = "Hello World!", key = 2},
        {text = "Programming is fun!", key = 3},
        {text = "Lua is amazing!", key = 4},
        {text = "Rail Fence Cipher", key = 5},
    }

    for i, testCase in ipairs(testCases) do
        local cipher = RailFenceCipher.new(testCase.key)

        local text = testCase.text
        local encryptedText = cipher:encrypt(text)
        local decryptedText = cipher:decrypt(encryptedText)

        print("Test Case " .. i .. ":")
        print("  Original Text: " .. text)
        print("  Key: " .. testCase.key)
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

testRailFence()
