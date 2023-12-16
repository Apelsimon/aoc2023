package.path = package.path .. ';../help.lua'
local help = require("help")

local stringToTable = function(str)
    local buffer = {}
    for i = 1, #str do
    buffer[i] = str:sub(i,i)
    end
    return buffer
end

local sortString = function(input)
    local buffer = stringToTable(input)
    table.sort(buffer)
    return table.concat(buffer)
end

local allEqual = function(str)
    local firstChar = str:sub(1, 1)

    for i = 2, #str do
        if str:sub(i, i) ~= firstChar then
            return false
        end
    end

    return true
end

local getHandType = function(hand)
    if allEqual(hand) then return 7 end

    hand = sortString(hand)
    if allEqual(hand:sub(1, 4)) or allEqual(hand:sub(2, 5)) then return 6 end

    if (allEqual(hand:sub(1, 3)) and allEqual(hand:sub(4, 5))) or
        (allEqual(hand:sub(1, 2)) and allEqual(hand:sub(3, 5))) then return 5 end

    if allEqual(hand:sub(1, 3)) or allEqual(hand:sub(2, 4)) or allEqual(hand:sub(3, 5)) then return 4 end

    local charCount = {}
    for i = 1, #hand do
        local c = hand:sub(i, i)
        charCount[c] = charCount[c] and (charCount[c] + 1) or 1
    end

    local numCharsMoreThanOne = 0

    for _, count in pairs(charCount) do
        if count > 1 then
            numCharsMoreThanOne = numCharsMoreThanOne + 1
        end
    end

    if numCharsMoreThanOne == 2 then return 3 end
    if numCharsMoreThanOne == 1 then return 2 end

    return 1
end

local getCardValue = function(useJoker)
    local cardValues = {
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["T"] = 10,
        ["J"] = useJoker and 1 or 11,
        ["Q"] = 12,
        ["K"] = 13,
        ["A"] = 14,
    }

    return function (card)
        return cardValues[card]
    end
end

local sortByRank = function(getHandTypeFunc, cardValue)
    return function(a, b)
        local t1, t2 = getHandTypeFunc(a.hand), getHandTypeFunc(b.hand)

        if t1 < t2 then return true end
        if t1 > t2 then return false end

        local size = #a.hand
        for i = 1, size do
            if cardValue(a.hand:sub(i, i)) < cardValue(b.hand:sub(i, i)) then return true end
            if cardValue(a.hand:sub(i, i)) > cardValue(b.hand:sub(i, i)) then return false end
        end

        return false
    end
end

local partOne = function(playedHands)
    table.sort(playedHands, sortByRank(getHandType, getCardValue(false)))

    local sum = 0
    for rank, entry in ipairs(playedHands) do
        sum = sum + (rank * entry.bid)
    end

    return sum
end

local partTwo = function(playedHands)
    local hasJokers = function(hand)
        for i = 1, #hand do
            if hand:sub(i, i) == "J" then
                return true
            end
        end
        return false
    end

    local replaceJokers = function(hand)
        if not hasJokers(hand) then return hand end

        local charCount = {}
        for i = 1, #hand do
            local c = hand:sub(i, i)
            charCount[c] = charCount[c] and (charCount[c] + 1) or 1
        end

        local maxChar = nil
        local maxCount = -math.huge

        for c, count in pairs(charCount) do
            if count > maxCount and c ~= "J" then
                maxChar = c
                maxCount = count
            end
        end

        return maxChar and hand:gsub('J', maxChar) or hand
    end

    local getHandTypeWithJoker = function(hand)
        return getHandType(replaceJokers(hand))
    end

    table.sort(playedHands, sortByRank(getHandTypeWithJoker, getCardValue(true)))

    local sum = 0
    for rank, entry in ipairs(playedHands) do
        sum = sum + (rank * entry.bid)
    end

    return sum
end

-- =============================== Main =============================================================

local file = io.open(arg[1], "r")
assert(file)

local data = {}
for line in file:lines() do
    local hand, bid = help.splitInTwo(line, " ")
    table.insert(data, { hand = hand, bid = tonumber(bid)})
end

print("partOne: " .. partOne(help:deepCopy(data)))
print("partTwo: " .. partTwo(data))

file:close()