local PlayfairCipher = {}
PlayfairCipher.__index = PlayfairCipher

function PlayfairCipher:new(key)
    local obj = {
        key = key,
        matrix = self:generate_matrix(key),
    }
    setmetatable(obj, self)
    return obj
end

function PlayfairCipher:generate_matrix(key)
    local alphabet = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
    local key = key:upper():gsub("J", "I")
    local seen = {}
    local matrix = {}
    local row = {}

    local function add_char(c)
        if not seen[c] then
            table.insert(row, c)
            seen[c] = true
            if #row == 5 then
                table.insert(matrix, row)
                row = {}
            end
        end
    end

    for i = 1, #key do
        add_char(key:sub(i, i))
    end

    for i = 1, #alphabet do
        add_char(alphabet:sub(i, i))
    end

    return matrix
end


function PlayfairCipher:encrypt(plaintext)
    local plaintext = plaintext:upper():gsub("J", "I"):gsub("[^A-Z]", "")
    local ciphertext = ""

    local function find_position(c)
        for row = 1, 5 do
            for col = 1, 5 do
                if self.matrix[row][col] == c then
                    return row, col
                end
            end
        end
    end

    local function encrypt_pair(a, b)
        local row1, col1 = find_position(a)
        local row2, col2 = find_position(b)

        if row1 == row2 then
            col1 = (col1 % 5) + 1
            col2 = (col2 % 5) + 1
        elseif col1 == col2 then
            row1 = (row1 % 5) + 1
            row2 = (row2 % 5) + 1
        else
            local temp = col1
            col1 = col2
            col2 = temp
        end

        return self.matrix[row1][col1] .. self.matrix[row2][col2]
    end

    local i = 1
    while i <= #plaintext do
        local a = plaintext:sub(i, i)
        local b = i + 1 <= #plaintext and plaintext:sub(i + 1, i + 1) or "X"

        if a == b then
            b = "X"
        else
            i = i + 1
        end

        ciphertext = ciphertext .. encrypt_pair(a, b)
        i = i + 1
    end

    return ciphertext
end

-- Tests
local function testPlayfair()
    local cipher = PlayfairCipher:new("KEY")
    assert(cipher:encrypt("HELLO WORLD") == "DBNVMIZMQMGV", "Test 1 FAILED")
    assert(cipher:encrypt("PLAYFAIR CIPHER") == "QIBAGYMPIPTCYQ", "Test 2 FAILED")
    assert(cipher:encrypt("ABCD") == "BKDF", "Test 3 FAILED")

    print("All tests PASSED")
end

testPlayfair()
