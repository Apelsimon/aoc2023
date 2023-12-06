package.path = package.path .. ';../help.lua'
local help = require("help")

local doUntilEmptyLineOrEof = function (it, func)
    local line = it()
    while line ~= nil and line ~= "" do
        func(line)
        line = it()
    end
end

local parseMap = function (it)
    local map = {}

    it() -- Get rid of "header"
    doUntilEmptyLineOrEof(it, function(line)
        table.insert(map, help.splitIntoTable(line, " ", tonumber))
    end)

    return map
end

local mapValue = function(value, map)
    for _, row in ipairs(map) do
        if row[2] <= value and value < row[2] + row[3] then
            return row[1] + (value - row[2])
        end
    end

    return value
end

-- ====================== Main ====================================

local file = io.open(arg[1], "r")
assert(file)

local partOne = function(file)
    local it = file:lines()
    local seeds = {}

    -- Parse seeds
    doUntilEmptyLineOrEof(it, function(line)
        local _, s = help.splitInTwo(line, ":")
        seeds = help.splitIntoTable(s, " ", tonumber)
    end)

    local seedToSoil = parseMap(it)
    local soilToFert = parseMap(it)
    local fertToWater = parseMap(it)
    local waterToLight = parseMap(it)
    local lightToTemp = parseMap(it)
    local tempToHum = parseMap(it)
    local humToLoc = parseMap(it)

    local lowest
    for i = 1, #seeds do
        local result = mapValue(mapValue(mapValue(mapValue(mapValue(mapValue(mapValue(seeds[i], seedToSoil), soilToFert), fertToWater), waterToLight), lightToTemp), tempToHum), humToLoc)
        lowest = lowest and (result < lowest and result or lowest) or result
    end

    return lowest
end

local partTwo = function(file)
    return 0

    -- local it = file:lines()
    -- local ranges = {}

    -- -- Parse seeds
    -- doUntilEmptyLineOrEof(it, function(line)
    --     local _, r = help.splitInTwo(line, ":")
    --     ranges = help.splitIntoTable(r, " ", tonumber)
    -- end)

    -- local seedToSoil = parseMap(it)
    -- local soilToFert = parseMap(it)
    -- local fertToWater = parseMap(it)
    -- local waterToLight = parseMap(it)
    -- local lightToTemp = parseMap(it)
    -- local tempToHum = parseMap(it)
    -- local humToLoc = parseMap(it)
    
    -- local lowest
    -- for i = 1, #ranges, 2 do
    --     local start, stop = ranges[i], ranges[i + 1]
    --     for seed = start, start + stop do
    --         local result = mapValue(mapValue(mapValue(mapValue(mapValue(mapValue(mapValue(seed, seedToSoil), soilToFert), fertToWater), waterToLight), lightToTemp), tempToHum), humToLoc)
    --         lowest = lowest and (result < lowest and result or lowest) or result
    --     end
    -- end

    -- return lowest
end


print("partOne: " .. partOne(file))
file:seek("set", 0)
print("partTwo: " .. partTwo(file))

file:close()