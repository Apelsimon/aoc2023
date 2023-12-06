package.path = package.path .. ';../help.lua'
local help = require("help")

local file = io.open(arg[1], "r")
assert(file)

local hasNumber = function(numbers, number)
    for _, nr in ipairs(numbers) do
        if nr == number then
            return true
        end
    end

    return false
end

local numberOfMatches = function(numbers, winningNumbers)
    local matches = 0
    for _, number in ipairs(numbers) do
        if hasNumber(winningNumbers, number) then
            matches = matches + 1
        end
    end
    return matches
end

local partOne = function(file)
    local sum = 0

    for line in file:lines() do
        _, line = help.splitInTwo(line, ":")
        local winningNumbers, numbers  = help.splitInTwo(line, "|")
        winningNumbers = help.splitIntoTable(winningNumbers, " ")
        numbers = help.splitIntoTable(numbers, " ")
        
        local matches = numberOfMatches(numbers, winningNumbers)
        sum = sum + (matches > 0 and (2 ^ (matches - 1)) or 0)
    end

    return sum
end

local partTwo = function(file)
    local currentCard = 1
    local numCardInstances = {}

    local initOrIncrement = function(instances, key, value)
        if instances[key] == nil then
            instances[key] = value
        else
            instances[key] = instances[key] + value
        end
    end

    for line in file:lines() do
        _, line = help.splitInTwo(line, ":")
        local winningNumbers, numbers  = help.splitInTwo(line, "|")
        winningNumbers = help.splitIntoTable(winningNumbers, " ")
        numbers = help.splitIntoTable(numbers, " ")

        initOrIncrement(numCardInstances, currentCard, 1)
        local matches = numberOfMatches(numbers, winningNumbers)

        for i = 1, matches do
            initOrIncrement(numCardInstances, currentCard + i, numCardInstances[currentCard])
        end

        currentCard = currentCard + 1
    end

    local sum = 0
    for i, instances in ipairs(numCardInstances) do
        sum = sum + instances
    end

    return sum
end


print("partOne: " .. partOne(file))
file:seek("set", 0)
print("partTwo: " .. partTwo(file))

file:close()