local ALPHABET_SIZE = 95
local Z95_CONVERSION_CONSTANT = 32

function modularInverse(a, m)
    local x0, x1 = 1, 0
    local original_m = m

    while m ~= 0 do
        local q, r = a // m, a % m
        local next_x = x0 - q * x1

        a, m, x0, x1 = m, r, x1, next_x
    end

    if a > 1 then
        error("Inverse does not exist")
    end

    return x0 < 0 and x0 + original_m or x0
end


local AffineCipher = {}
AffineCipher.__index = AffineCipher

function AffineCipher.new(a, b)
    local self = setmetatable({}, AffineCipher)
    self.a = a
    self.b = b
    return self
end

function AffineCipher:encrypt(plaintext)
    local ciphertext = {}
    for i = 1, #plaintext do
        local charCode = string.byte(plaintext, i) - Z95_CONVERSION_CONSTANT
        charCode = ((charCode * self.a) + self.b) % ALPHABET_SIZE
        ciphertext[i] = string.char(charCode + Z95_CONVERSION_CONSTANT)
    end
    return table.concat(ciphertext)
end

function AffineCipher:decrypt(ciphertext)
    local aInverse = modularInverse(self.a, ALPHABET_SIZE)
    if not aInverse then
        return "Invalid key"
    end

    local bInverse = -(self.b % ALPHABET_SIZE) + ALPHABET_SIZE
    local plaintext = {}
    for i = 1, #ciphertext do
        local charCode = string.byte(ciphertext, i) - Z95_CONVERSION_CONSTANT
        charCode = (aInverse * (charCode + bInverse)) % ALPHABET_SIZE
        plaintext[i] = string.char(charCode + Z95_CONVERSION_CONSTANT)
    end
    return table.concat(plaintext)
end

function testAffine()
    local testCases = {
        {plaintext = "Hello!", expectedCiphertext = "&3ddy2", a = 7, b = 11},
        {plaintext = "TheAlgorithms/C", expectedCiphertext = "DNC}=jHS2zN!7;E", a = 67, b = 67},
        {plaintext = "0123456789", expectedCiphertext = "840,($ {ws", a = 91, b = 88},
        {plaintext = "7W@;cdeRT9uL", expectedCiphertext = "JDfa*we?z&bL", a = 77, b = 76},
        {plaintext = "~Qr%^-+++$leM", expectedCiphertext = "r'qC0$sss;Ahf", a = 8, b = 90},
        {plaintext = "The quick brown fox jumps over the lazy dog", expectedCiphertext = "K7: .*6<4 =-0(1 90' 5*2/, 0):- +7: 3>%& ;08", a = 94, b = 0},
        {plaintext = "One-1, Two-2, Three-3, Four-4, Five-5, Six-6, Seven-7, Eight-8, Nine-9, Ten-10", expectedCiphertext = "H&60>\\2*uY0q\\2*p4660E\\2XYn40x\\2XDB60L\\2VDI0 \\2V6B6&0S\\2%D=p;0'\\2tD&60Z\\2*6&0>j", a = 51, b = 18},
    }

    for _, testCase in ipairs(testCases) do
        local cipher = AffineCipher.new(testCase.a, testCase.b)
        local ciphertext = cipher:encrypt(testCase.plaintext)
        --print(testCase.plaintext, ciphertext)
        assert(ciphertext == testCase.expectedCiphertext, "Encryption failed for '" .. testCase.plaintext .. "'")
        local decryptedPlaintext = cipher:decrypt(ciphertext)
        --print(ciphertext, decryptedPlaintext)
        assert(decryptedPlaintext == testCase.plaintext, "Decryption failed for '" .. testCase.plaintext .. "'")
    end

    print("All tests have successfully passed!")
end

testAffine()
