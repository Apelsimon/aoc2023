local file = io.open(arg[1], "r")
assert(file)

local maybeNumber = function(subStr, searchFromLeft)
    local numbers = {
        ["zero"] = 0,
        ["one"] = 1,
        ["two"] = 2,
        ["three"] = 3,
        ["four"] = 4,
        ["five"] = 5,
        ["six"] = 6,
        ["seven"] = 7,
        ["eight"] = 8,
        ["nine"] = 9
    }

    local limit = 5
    if searchFromLeft then
        for index = 1, limit do
            local maybe = numbers[subStr:sub(1, index)]
            if maybe ~= nil then
                return maybe
            end
        end
    else
        local length = #subStr
        for index = length, (length - limit + 1), -1  do
            local maybe = numbers[subStr:sub(index, length)]
            if maybe ~= nil then
                return maybe
            end
        end
    end

    return nil
end

local sum = 0

for line in file:lines() do
    local length = #line
    local leftIndex = 1
    local rightIndex = length
    local leftNum, rightNum = nil, nil

    while leftIndex <= rightIndex and (leftNum == nil or rightNum == nil) do
        leftNum = leftNum or tonumber(line:sub(leftIndex, leftIndex)) or maybeNumber(line:sub(leftIndex), true)
        rightNum = rightNum or tonumber(line:sub(rightIndex, rightIndex)) or maybeNumber(line:sub(1, rightIndex), false)

        if leftNum == nil then
            leftIndex = leftIndex + 1
        end
        
        if rightNum == nil then
            rightIndex = rightIndex - 1
        end        
    end

    if leftNum ~= nil and rightNum ~= nil then
        sum = sum + tonumber(tostring(leftNum) .. tostring(rightNum))
    elseif leftNum ~= nil then
        sum = sum + tonumber(tostring(leftNum) .. tostring(leftNum))
    elseif rightNum ~= nil then
        sum = sum + tonumber(tostring(rightNum) .. tostring(rightNum))
    end
end

print("sum: " .. sum)

file:close()
