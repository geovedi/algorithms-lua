local Adler32Cipher = {}
Adler32Cipher.__index = Adler32Cipher

function Adler32Cipher:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end

function Adler32Cipher:encrypt(input)
    local MOD_ADLER = 65521
    local a, b = 1, 0
    for i = 1, #input do
        a = (a + input:byte(i)) % MOD_ADLER
        b = (b + a) % MOD_ADLER
    end
    return (b * 65536) + a
end

-- Tests
local function testAdler32Cipher()
    local cipher = Adler32Cipher:new()
    
    local test_cases = {
        {input = "Wikipedia", expected = 0x11E60398},
        {input = "Hello, world!", expected = 0x205E048A},
        {input = "", expected = 0x1},
    }
    
    for i, test_case in ipairs(test_cases) do
        local output = cipher:encrypt(test_case.input)
        local status = output == test_case.expected and "PASSED" or "FAILED"
        print(string.format("Test %d: input='%s', expected='%08X', output='%08X' - %s",
                            i, test_case.input, test_case.expected, output, status))
    end
end

testAdler32Cipher()
