package.path = package.path .. ';../help.lua'
local help = require("help")

local file = io.open(arg[1], "r")
assert(file)

local find = function(str, pattern)
    local start, stop = string.find(str, pattern, 1, true)
    return start ~= nil and stop ~= nil
end

Count = function(cfg, nums, memory)
    if cfg == "" then
        return #nums == 0 and 1 or 0
    end

    if #nums == 0 then
        return (not find(cfg, "#")) and 1 or 0
    end

    if memory[#cfg] ~= nil and memory[#cfg][#nums] ~= nil then
        return memory[#cfg][#nums]
    end

    local result = 0

    if find(".?", cfg:sub(1, 1)) then
        result = result + Count(cfg:sub(2), nums, memory)
    end

    if find("#?", cfg:sub(1, 1)) then
        if (nums[1] <= #cfg) and
            (not find(cfg:sub(1, nums[1]), ".")) and
            (nums[1] == #cfg or (cfg:sub(nums[1] + 1, nums[1] + 1) ~= "#")) 
        then
            result = result + Count(cfg:sub(nums[1] + 2), help.slice(nums, 2, #nums), memory)
        end
    end

    memory[#cfg] = memory[#cfg] or {}
    memory[#cfg][#nums] = result

    return result
end

local partOne = function(lines)
    local total = 0

    for _, line in ipairs(lines) do
        local cfg, nums = help.splitInTwo(line, " ")
        nums = help.splitIntoTable(nums, ",", tonumber)
        total = total + Count(cfg, nums, {})
    end

    return total
end

local partTwo = function(lines)
    local unfold = function(cfg, nums)
        local r = cfg
        local nrs = help:deepCopy(nums)

        for i = 1, 4 do
            r = r .. "?" .. cfg
            for _, nr in ipairs(nums) do
                table.insert(nrs, nr)
            end
        end
        return r, nrs
    end

    local total = 0
    for i, line in ipairs(lines) do
        local cfg, nums = help.splitInTwo(line, " ")
        nums = help.splitIntoTable(nums, ",", tonumber)
        cfg, nums = unfold(cfg, nums)
        total = total + Count(cfg, nums, {})
    end

    return total
end

local lines = {}

for line in file:lines() do
    table.insert(lines, line)
end

-- kudos: https://www.youtube.com/watch?v=g3Ms5e7Jdqo
print("Part one: " .. partOne(help:deepCopy(lines)))
print("Part two: " .. partTwo(lines))

file:close()