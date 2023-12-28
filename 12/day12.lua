package.path = package.path .. ';../help.lua'
local help = require("help")

local file = io.open(arg[1], "r")
assert(file)

local maybeNewString = function(numbers, str, strictCheck)
    local groups = help.splitIntoTable(str, ".")

    if strictCheck then
        if #numbers ~= #groups then
            return nil
        end
    else
        if #numbers < #groups then
            return nil
        end
    end

    for i, group in ipairs(groups) do
        if strictCheck then
            if numbers[i] ~= #group then
                return nil
            end
        else    
            if numbers[i] < #group then
                return nil
            end
        end
    end

    return str
end

BuildValidStrings = function(numbers, record, strings, stringLengths)
    if stringLengths == #record then
        return strings
    end

    local newStrings = {}

    for _, str in ipairs(strings) do
        local char = record:sub(stringLengths + 1, stringLengths + 1)
        local str2, str3

        if char == "?" then
            str2 = maybeNewString(numbers, str .. "#", (#str + 1) == #record)
            str3 = maybeNewString(numbers, str .. ".", (#str + 1) == #record)
        else
            str2 = maybeNewString(numbers, str .. char, (#str + 1) == #record)
        end 

        if str2 then
            table.insert(newStrings, str2)
        end
        if str3 then
            table.insert(newStrings, str3)
        end    
    end

    return BuildValidStrings(numbers, record, newStrings, stringLengths + 1)
end

local partOne = function(lines)
    local sum = 0

    for _, line in ipairs(lines) do
        local record, r2 = help.splitInTwo(line, " ")
        local numbers = help.splitIntoTable(r2, ", ", tonumber)
        sum = sum + #BuildValidStrings(numbers, record, {""}, 0)
    end

    return sum
end

local partTwo = function(lines)
    return 0

    -- local unfold = function(record, numbers)
    --     local r = record
    --     local nrs = help:deepCopy(numbers)

    --     for i = 1, 4 do
    --         r = r .. "?" .. record
    --         for _, nr in ipairs(numbers) do
    --             table.insert(nrs, nr)
    --         end
    --     end
    --     return r, nrs
    -- end

    -- local sum = 0
    -- for _, line in ipairs(lines) do
    --     local record, r2 = help.splitInTwo(line, " ")
    --     local numbers = help.splitIntoTable(r2, ", ", tonumber)
    --     record, numbers = unfold(record, numbers)
    --     sum = sum + #BuildValidStrings(numbers, record, {""}, 0)
    -- end

    -- return sum
end

local lines = {}

for line in file:lines() do
    table.insert(lines, line)
end


print("partOne: " .. partOne(help:deepCopy(lines)))
-- print("partTwo: " .. partTwo(lines))

file:close()