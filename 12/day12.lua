package.path = package.path .. ';../help.lua'
local help = require("help")

local file = io.open(arg[1], "r")
assert(file)

local numCharsInString = function(str, char)
    local sum = 0
    for i = 1, #str do
        if str:sub(i, i) == char then
            sum = sum + 1
        end
    end
    return sum
end

Permutations = function(char1, char2, length, accumulator, container)
    accumulator = accumulator or ""
    container = container or {}

    if length == 0 then
        table.insert(container, accumulator)
    else
        Permutations(char1, char2, length - 1, accumulator .. char1, container)
        Permutations(char1, char2, length - 1, accumulator .. char2, container)
    end

    return container
end

local makeTestString = function(str, permutation)
    local pIt = 1
    local length = #str
    local i = 1

    while i <= length do
        if str:sub(i, i) == "?" then
            str = str:sub(1, i - 1) .. permutation:sub(pIt, pIt) .. str:sub(i + 1)
            pIt = pIt + 1
        end

        i = i + 1
    end

    return str
end

local isValid = function(numbers, str)
    local i = 1
    local doCount = false
    local count = 0
    local numIt = 1

    while i <= #str do
        local isHash = str:sub(i, i) == "#"

        if not doCount and isHash then
            doCount = true
            count = 1

            if numIt > #numbers then
                return false
            end
        elseif doCount then
            if isHash then
                count = count + 1
            else
                if numbers[numIt] ~= count then
                    return false
                end

                count = 0
                numIt = numIt + 1
                doCount = false
            end
        end

        i = i + 1
    end

    if doCount and numIt <= #numbers then
        if numbers[numIt] ~= count then
            return false
        end

        numIt = numIt + 1
    end

    return numIt > #numbers
end

local sum = 0

for line in file:lines() do
    local record, r2 = help.splitInTwo(line, " ")
    local numbers = help.splitIntoTable(r2, ", ", tonumber)
    local permutations = Permutations(".", "#", numCharsInString(record, "?"))

    local numValidPermutations = 0

    for _, p in ipairs(permutations) do
        if isValid(numbers, makeTestString(record, p)) then
            numValidPermutations = numValidPermutations + 1
        end
    end

    sum = sum + numValidPermutations
end

print("sum: " .. sum)

file:close()