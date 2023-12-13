package.path = package.path .. ';../help.lua'
local help = require("help")

local calculateBounds = function(time, distance)
    local sqrtDiscriminant = math.sqrt(time * time - 4 * distance)
    local lowerBound = (time - sqrtDiscriminant) / 2
    lowerBound = lowerBound ~= math.ceil(lowerBound) and math.ceil(lowerBound) or (lowerBound + 1)

    local upperBound = (time + sqrtDiscriminant) / 2
    upperBound = upperBound ~= math.floor(upperBound) and math.floor(upperBound) or (upperBound - 1)

    return lowerBound, upperBound
end

local partOne = function(file)
    local it = file:lines()
    local _, times = help.splitInTwo(it(), ":")
    local _, distances = help.splitInTwo(it(), ":")

    times = help.splitIntoTable(times, " ", tonumber)
    distances = help.splitIntoTable(distances, " ", tonumber)
    local size = #times

    local product = 1
    for i = 1, size do
        local lowerBound, upperBound = calculateBounds(times[i], distances[i])
        product = product * (upperBound - lowerBound + 1)
    end

    return product
end

local partTwo = function(file)
    local it = file:lines()
    local _, times = help.splitInTwo(it(), ":")
    local _, distances = help.splitInTwo(it(), ":")

    local concat = function(t)
        local number = ""
        for _, value in ipairs(t) do
            number = number .. value
        end
        return tonumber(number)
    end

    local time = concat(help.splitIntoTable(times, " ", tonumber))
    local distance = concat(help.splitIntoTable(distances, " ", tonumber))
    local lowerBound, upperBound = calculateBounds(time, distance)

    return upperBound - lowerBound + 1
end

local file = io.open(arg[1], "r")
assert(file)
print("partOne: " .. partOne(file))
file:seek("set", 0)
print("partTwo: " .. partTwo(file))

file:close()