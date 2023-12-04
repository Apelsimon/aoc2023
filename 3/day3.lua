local file = io.open(arg[1], "r")
assert(file)

local partOne = function(file)
    local numbers = {}
    local schematic = {}
    local rows = 1

    for line in file:lines() do
        local searchStart = 1
        for number in line:gmatch("%d+") do
            local startId, endId = line:find(number, searchStart)
            searchStart = endId
            table.insert(numbers, {value = number, info = {pos = {startId, rows}, size = (endId - startId + 1)}})
        end

        schematic[rows] = line
        rows = rows + 1
    end

    local rowSize = #schematic[1]
    local sum = 0

    local includeNumber = function(info)
        local pos = info.pos
        for y = pos[2] - 1, pos[2] + 1 do
            for x = pos[1] - 1, pos[1] + info.size do
                if (x >= 1 and x <= rowSize and y >= 1 and y < rows) and
                    (y ~= pos[2] or (x == (pos[1] - 1) or x == (pos[1] + info.size))) 
                then
                    if schematic[y]:sub(x, x) ~= "." then
                        return true
                    end
                end
            end
        end

        return false
    end

    for _, number in ipairs(numbers) do
        if includeNumber(number.info) then
            sum = sum + tonumber(number.value)
        end
    end

    return sum
end

local partTwo = function(file)
    local numbers = {}
    local schematic = {}
    local rows = 1

    for line in file:lines() do
        local searchId = 1
        for number in line:gmatch("%d+") do
            local startId, endId = line:find(number, searchId)
            searchId = endId
            table.insert(numbers, {value = number, info = {pos = {startId, rows}, size = (endId - startId + 1)}})
        end

        schematic[rows] = line
        rows = rows + 1
    end

    local rowSize = #schematic[1]
    local sum = 0

    local checkNumber = function(info)
        local pos = info.pos
        local doInclude = false
        local adjacentAsterisks = {}

        for y = pos[2] - 1, pos[2] + 1 do
            for x = pos[1] - 1, pos[1] + info.size do
                if (x >= 1 and x <= rowSize and y >= 1 and y < rows) and
                    (y ~= pos[2] or (x == (pos[1] - 1) or x == (pos[1] + info.size))) 
                then
                    local char = schematic[y]:sub(x, x)
                    if char ~= "." then
                        doInclude = true
                        if char == "*" then
                            table.insert(adjacentAsterisks, {x, y})
                        end
                    end
                end
            end
        end

        return doInclude, adjacentAsterisks
    end

    local asterisks = {}

    for _, number in ipairs(numbers) do
        local include, adjacentAsterisks = checkNumber(number.info)
        if include then
            for _, pos in ipairs(adjacentAsterisks) do
                if asterisks[pos[2]] == nil then
                    asterisks[pos[2]] = {}
                end

                if asterisks[pos[2]][pos[1]] == nil then
                    asterisks[pos[2]][pos[1]] = {number.value}
                else
                    table.insert(asterisks[pos[2]][pos[1]], number.value)
                end
            end
        end
    end

    local sum = 0
    for _, row in pairs(asterisks) do
        for _, numbers in pairs(row) do
            if #numbers == 2 then
                sum = sum + (numbers[1] * numbers[2])
            end
        end
    end

    return sum
end

print("partOne: " .. partOne(file))
file:seek("set", 0)
print("partTwo: " .. partTwo(file))

file:close()