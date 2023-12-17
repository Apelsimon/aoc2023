package.path = package.path .. ';../help.lua'
local help = require("help")

local extrapolate = function(numbers, doEndValue)
    local differences = {numbers}
    local lastRow = differences[1]
    local row = 2

    while true do
        local rowOnlyZeroes = true

        for i = 2, #lastRow do
            local diff = lastRow[i] - lastRow[i - 1]
            if differences[row] then
                table.insert(differences[row], diff)
            else
                differences[row] = { diff }
            end
            rowOnlyZeroes = rowOnlyZeroes and (diff == 0)
        end

        if rowOnlyZeroes then
            if doEndValue then
                table.insert(differences[row], differences[row][#differences[row]])
            else
                table.insert(differences[row], 1, differences[row][1])
            end

            repeat
                local diffs = differences[row]
                local diffs_1 = differences[row - 1]
                if doEndValue then
                    table.insert(diffs_1, diffs_1[#diffs_1] + diffs[#diffs])
                else
                    table.insert(diffs_1, 1, diffs_1[1] - diffs[1])
                end

                row = row - 1
            until row == 1

            return doEndValue and differences[row][#differences[row]] or differences[row][1]
        end

        lastRow = differences[row]
        row = row + 1
    end
end

local partOne = function(rows)
    local sum = 0
    for _, numbers in ipairs(rows) do
        sum = sum + extrapolate(numbers, true)
    end
    return sum
end

local partTwo = function(rows)
    local sum = 0
    for _, numbers in ipairs(rows) do
        sum = sum + extrapolate(numbers, false)
    end
    return sum
end

local file = io.open(arg[1], "r")
assert(file)

local rows = {}

for line in file:lines() do
    table.insert(rows, help.splitIntoTable(line, " ", tonumber))
end

print("partOne: " .. partOne(help:deepCopy(rows)))
print("partTwo: " .. partTwo(rows))

file:close()