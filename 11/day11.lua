package.path = package.path .. ';../help.lua'
local help = require("help")

local getSize = function(matrix)
    return #matrix[1], #matrix
end

local getRows = function(image, w, h)
    local rows = {}

    for y = 1, h do
        local x = 1
        local onlyDots = true
        while x <= w and onlyDots do
            onlyDots = image[y][x] == "."
            x = x + 1
        end

        if onlyDots then
            table.insert(rows, y)
        end
    end

    return rows
end

local getColumns = function(image, w, h)
    local columns = {}

    for x = 1, w do
        local y = 1
        local onlyDots = true
        while y <= h and onlyDots do
            onlyDots = image[y][x] == "."
            y = y + 1
        end

        if onlyDots then
            table.insert(columns, x)
        end
    end

    return columns
end

local makeGalaxies = function(image, w, h)
    local galaxies = {}

    for y = 1, h do
        for x = 1, w do
            if image[y][x] == "#" then
                table.insert(galaxies, {x, y})
            end
        end
    end

    return galaxies
end

local makePairs = function(galaxies)
    local galaxyPairs = {}
    for i = 1, #galaxies do
        for j = i + 1, #galaxies do
            table.insert(galaxyPairs, {g1 = galaxies[i], g2 = galaxies[j]})
        end
    end
    return galaxyPairs
end

local distance = function(g1, g2)
    return math.abs(g1[1] - g2[1]) + math.abs(g1[2] - g2[2])
end

local partX = function(image, multiple)
    local w, h = getSize(image)
    local rows = getRows(image, w, h)
    local columns = getColumns(image, w, h)
    local pairs = makePairs(makeGalaxies(image, w, h))

    local distanceSum = 0
    local expansion = multiple - 1

    for _, pair in ipairs(pairs) do
        local g1 = pair.g1
        local g2 = pair.g2

        local yExpand = 0
        for _, y in ipairs(rows) do
            if (g1[2] < y and y < g2[2]) or (g2[2] < y and y < g1[2]) then
                yExpand = yExpand + expansion
            end
        end

        local xExpand = 0
        for _, x in ipairs(columns) do
            if (g1[1] < x and x < g2[1]) or (g2[1] < x and x < g1[1]) then
                xExpand = xExpand + expansion
            end
        end

        distanceSum = distanceSum + distance(g1, g2) + xExpand + yExpand
    end

    return distanceSum
end

local file = io.open(arg[1], "r")
assert(file)

local image = {}

for line in file:lines() do
    table.insert(image, help.stringToTable(line))
end

print("partOne: " .. partX(image, 2))
print("partTwo: " .. partX(image, 1000000))

file:close()