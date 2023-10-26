-- number of characters in our alphabet (printable ASCII characters)
local ALPHABET_SIZE = 95

-- used to convert a printable byte (32 to 126) to an element of the group Z_95 (0 to 94)
local Z95_CONVERSION_CONSTANT = 32

-- Calculate the modular multiplicative inverse of a modulo m
local function modular_multiplicative_inverse(a, m)
    local x = {1, 0}
    local div_result = {}

    if m == 0 then
        return 0
    end

    a = a % m

    if a == 0 then
        return 0
    end

    div_result.rem = a

    while div_result.rem > 0 do
        div_result.quot = math.floor(m / a)
        div_result.rem = m % a

        m = a
        a = div_result.rem

        -- Calculate the value of x for this iteration
        local next = x[2] - (x[1] * div_result.quot)

        x[2] = x[1]
        x[1] = next
    end

    return x[2]
end


-- Encrypts a plaintext string using an affine cipher
local function affine_encrypt(plaintext, a, b)
    local ciphertext = ""

    for i = 1, #plaintext do
        local c = string.byte(plaintext, i)
        c = c - Z95_CONVERSION_CONSTANT
        c = c * a
        c = c + b
        c = c % ALPHABET_SIZE
        ciphertext = ciphertext .. string.char(c + Z95_CONVERSION_CONSTANT)
    end

    return ciphertext
end

-- Calculates the inverse key for an affine cipher key
local function inverse_key(a, b)
    local c = (modular_multiplicative_inverse(a, ALPHABET_SIZE) + ALPHABET_SIZE) % ALPHABET_SIZE
    local d = -(b % ALPHABET_SIZE) + ALPHABET_SIZE

    return c, d
end

-- Decrypts a ciphertext string using an affine cipher with an inverse key
local function affine_decrypt(ciphertext, a, b)
    local plaintext = ""
    local c = modular_multiplicative_inverse(a, ALPHABET_SIZE)
    
    if not c then
        return "Invalid key" -- Handle the case where a doesn't have an inverse
    end
    
    local d = -(b % ALPHABET_SIZE) + ALPHABET_SIZE

    for i = 1, #ciphertext do
        local char_code = string.byte(ciphertext, i) - Z95_CONVERSION_CONSTANT
        char_code = (c * (char_code + d)) % ALPHABET_SIZE
        plaintext = plaintext .. string.char(char_code + Z95_CONVERSION_CONSTANT)
    end

    return plaintext
end



-- Test multiple strings
local function tests()
    local function test_string(plaintext, expected_ciphertext, a, b)
        local ciphertext = affine_encrypt(plaintext, a, b)
        assert(ciphertext == expected_ciphertext, "Encryption failed for '" .. plaintext .. "'")
        local decrypted_plaintext = affine_decrypt(ciphertext, a, b)
        assert(decrypted_plaintext == plaintext, "Decryption failed for '" .. plaintext .. "'")
    end

    test_string("Hello!", "&3ddy2", 7, 11)
    test_string("TheAlgorithms/C", "DNC}=jHS2zN!7;E", 67, 67)
    test_string("0123456789", "840,($ {ws", 91, 88)
    test_string("7W@;cdeRT9uL", "JDfa*we?z&bL", 77, 76)
    test_string("~Qr%^-+++$leM", "r'qC0$sss;Ahf", 8, 90)
    test_string("The quick brown fox jumps over the lazy dog", "K7: .*6<4 =-0(1 90' 5*2/, 0):- +7: 3>%& ;08", 94, 0)
    test_string("One-1, Two-2, Three-3, Four-4, Five-5, Six-6, Seven-7, Eight-8, Nine-9, Ten-10", "H&60>\\2*uY0q\\2*p4660E\\2XYn40x\\2XDB60L\\2VDI0 \\2V6B6&0S\\2%D=p;0'\\2tD&60Z\\2*6&0>j", 51, 18)

    print("All tests have successfully passed!")
end

-- Run the tests
tests()
