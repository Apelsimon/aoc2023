local partOne = function(file)
   local isPossible = function(line)
      local MaxCubes = {
         ["red"] = 12,
         ["green"] = 13,
         ["blue"] = 14,
      }

      local gameId = line:match("Game %d+"):sub(6)
      line = line:sub(line:find(gameId) + #tostring(gameId) + 1)

      for set in line:gmatch("[^;]+") do
         for subset in set:gmatch("[^,]+") do
            local amount = tonumber(subset:match("%d+"))
            local color = subset:match("%a+")
            if amount > MaxCubes[color] then
               return gameId, false
            end
         end
      end

      return gameId, true
   end

   local sum = 0

   for line in file:lines() do
      local id, possible = isPossible(line)
      sum = sum + (possible and id or 0)
   end

   return sum
end

local partTwo = function(file)
   local power = function(line)
      local maxCubes = {
         ["red"] = 0,
         ["green"] = 0,
         ["blue"] = 0,
      }

      local gameId = line:match("Game %d+"):sub(6)
      line = line:sub(line:find(gameId) + #tostring(gameId) + 1)

      for set in line:gmatch("[^;]+") do
         for subset in set:gmatch("[^,]+") do
            local amount = tonumber(subset:match("%d+"))
            local color = subset:match("%a+")
            if amount > maxCubes[color] then
               maxCubes[color] = amount
            end
         end
      end

      local product = 1
      for _, value in pairs(maxCubes) do
         product = product * value
      end

      return product
   end

   local sum = 0

   for line in file:lines() do
      sum = sum + power(line)
   end

   return sum
end

local file = io.open(arg[1], "r")
assert(file)

print("part one: " .. partOne(file))
file:seek("set", 0)
print("part two: " .. partTwo(file))

file:close()
