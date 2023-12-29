package.path = package.path .. ';../help.lua'
local help = require("help")

local doMap = function(map, mapIndex, foundReflections, partOne)
    local width, height = #map[1], #map

    -- check columns
    for x = 1, (width - 1) do
        local run = true
        local i = 0

        while run do
            local y = 1
            while y <= height do
                if map[y]:sub(x + i + 1, x + i + 1) ~= map[y]:sub(x - i, x - i) then
                    break
                end
                y = y + 1
            end

            local wholeColumnChecked = y > height

            if wholeColumnChecked then
                i = i + 1
            end

            run = wholeColumnChecked and (x + i + 1 <= width) and (x - i > 0)
        end

        if (x - i == 0) or (x + i + 1 > width) then
            if partOne then
                foundReflections[mapIndex] = {0, x}
                return 0, x
            else
                if foundReflections[mapIndex][1] ~= 0 or foundReflections[mapIndex][2] ~= x then
                    return 0, x
                end
            end
        end
    end

    -- check rows
    for y = 1, (height - 1) do
        local run = true
        local i = 0

        while run do
            local x = 1
            while x <= width do
                if map[y + i + 1]:sub(x, x) ~= map[y - i]:sub(x, x) then
                    break
                end
                x = x + 1
            end

            local wholeRowChecked = x > width

            if wholeRowChecked then
                i = i + 1
            end

            run = wholeRowChecked and (y + i + 1 <= height) and (y - i > 0)
        end

        if (y - i == 0) or (y + i + 1 > height) then
            if partOne then
                foundReflections[mapIndex] = {y, 0}
                return y, 0
            else
                if foundReflections[mapIndex][1] ~= y or foundReflections[mapIndex][2] ~= 0 then
                    return y, 0
                end
            end
        end
    end

    return 0, 0
end

local toggleSmudge = function(map, x, y)
    local smudge = map[y]:sub(x, x) == "." and "#" or "."
    local row = map[y]
    local charArray = {string.byte(row, 1, #row)}
    charArray[x] = string.byte(smudge)
    map[y] = string.char(unpack(charArray))
end

local doSmudgedMap = function(map, mapIndex, foundReflections)
    local width, height = #map[1], #map

    for y = 1, height do
        for x = 1, width do
            toggleSmudge(map, x, y)
            local rows, columns = doMap(map, mapIndex, foundReflections, false)
            if rows ~= 0 or columns ~= 0 then
                return (columns + 100 * rows)
            end
            toggleSmudge(map, x, y)
        end
    end

    return 0
end

local partOne = function(maps, foundReflections)
    local total = 0

    for i, map in ipairs(maps) do
        local rows, columns = doMap(map, i, foundReflections, true)
        total = total + (columns + 100 * rows)
    end

    return total
end

local partTwo = function(maps, foundReflections)
    local total = 0

    for i, map in ipairs(maps) do
        total = total + doSmudgedMap(map, i, foundReflections)
    end

    return total
end

local file = io.open(arg[1], "r")
assert(file)

local it = file:lines()
local maps = {}

while true do
    local map = {}
    local line

    repeat
        line = it()
        if line and line ~= "" then
            table.insert(map, line)
        end
    until not line or line == ""

    table.insert(maps, map)

    if not line then
        break
    end
end

local foundReflections = {}
print("Part one: " .. partOne(help:deepCopy(maps), foundReflections))
print("Part two: " .. partTwo(maps, foundReflections))

file:close()