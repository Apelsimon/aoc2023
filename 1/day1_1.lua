local file = io.open(arg[1], "r")
assert(file)

local sum = 0

for line in file:lines() do
    local length = #line
    local leftIndex = 1
    local rightIndex = length
    local leftNum, rightNum = nil, nil

    while leftIndex <= rightIndex and (leftNum == nil or rightNum == nil) do
        leftNum = leftNum or tonumber(line:sub(leftIndex, leftIndex))
        rightNum = rightNum or tonumber(line:sub(rightIndex, rightIndex))

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
