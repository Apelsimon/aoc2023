package.path = package.path .. ';../help.lua'
local help = require("help")

local file = io.open(arg[1], "r")
assert(file)

local it = file:lines()
local instructions = it()
it()

local map = {}
local partTwoPositions = {}

repeat
    local line = it()
    if line then
        local key = line:sub(1, 3)
        local directions = line:sub(8, 15)
        local left, right = help.splitInTwo(directions, ", ")

        map[key] = { ["L"] = left, ["R"] = right }

        if key:sub(3, 3) == "A" then
            table.insert(partTwoPositions, key)
        end
    end
until line == nil

local partOne = function(map)
    local position = "AAA"
    local steps = 0
    local i = 1

    repeat
        local directions = map[position]
        position = directions[instructions:sub(i, i)]
        steps = steps + 1
        i = (i == #instructions) and 1 or (i + 1)
    until position == "ZZZ"

    return steps
end

local partTwo = function(map, positions)
    local function gcd(a, b)
        while b ~= 0 do
            a, b = b, a % b
        end
        return a
    end

    local function lcm(a, b)
        return (a * b) / gcd(a, b)
    end

    local function findCommonDenominator(denominators)
        local result = 1
        for _, denominator in ipairs(denominators) do
            result = lcm(result, denominator)
        end
        return result
    end

    local stepsList = {}

    for _, position in ipairs(positions) do
        local steps = 0
        local i = 1

        repeat
            local directions = map[position]
            position = directions[instructions:sub(i, i)]
            steps = steps + 1
            i = (i == #instructions) and 1 or (i + 1)
        until position:sub(3, 3) == "Z"

        table.insert(stepsList, steps)
    end

    return findCommonDenominator(stepsList)
end

print("partOne: " .. partOne(map))
print("partTwo: " .. partTwo(map, partTwoPositions))
file:close()