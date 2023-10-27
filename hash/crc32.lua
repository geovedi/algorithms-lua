local CRC32Cipher = {}
CRC32Cipher.__index = CRC32Cipher

function CRC32Cipher:new()
    return setmetatable({}, CRC32Cipher)
end

function CRC32Cipher:encrypt(input)
    local crc = 0xFFFFFFFF
    for i = 1, #input do
        local byte = input:byte(i)
        crc = crc ~ byte
        for _ = 1, 8 do
            local mask = -(crc & 1)
            crc = (crc >> 1) ~ (0xEDB88320 & mask)
        end
    end
    return ~crc & 0xFFFFFFFF
end

local function testCRC32()
    local cipher = CRC32Cipher:new()
    local testCases = {
        {input = "Hello, world!", expected = 0xDBF04392},
        {input = "The quick brown fox jumps over the lazy dog", expected = 0x414FA339},
        {input = "", expected = 0x00000000},
    }
    
    for i, testCase in ipairs(testCases) do
        local output = cipher:encrypt(testCase.input)
        local status = output == testCase.expected and "PASSED" or "FAILED"
        print(string.format("Test %d: %s", i, status))
        print(string.format("Input:    '%s'", testCase.input))
        print(string.format("Expected: '%08X'", testCase.expected))
        print(string.format("Output:   '%08X'", output))
        print()
    end
end

testCRC32()
