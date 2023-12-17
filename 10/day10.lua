package.path = package.path .. ';../help.lua'
local help = require("help")

local accessibleNeighbour = function(src, dest, direction)
    local compatibilities = {
        ["S"] = {
            ["north"] = {
                "|",
                "7",
                "F"
            },
            ["south"] = {
                "|",
                "L",
                "J"
            },
            ["west"] = {
                "-",
                "L",
                "F"
            },
            ["east"] = {
                "-",
                "J",
                "7"
            }
        },
        ["|"] = {
            ["north"] = {
                "|",
                "7",
                "F",
                "S"
            },
            ["south"] = {
                "|",
                "L",
                "J",
                "S"
            }
        },
        ["-"] = {
            ["west"] = {
                "-",
                "L",
                "F",
                "S"
            },
            ["east"] = {
                "-",
                "J",
                "7",
                "S"
            }
        },
        ["L"] = {
            ["north"] = {
                "|",
                "7",
                "F",
                "S"
            },
            ["east"] = {
                "-",
                "7",
                "J",
                "S"
            }
        },
        ["J"] = {
            ["north"] = {
                "|",
                "7",
                "F",
                "S"
            },
            ["west"] = {
                "-",
                "L",
                "F",
                "S"
            }
        },
        ["7"] = {
            ["west"] = {
                "-",
                "L",
                "F",
                "S"
            },
            ["south"] = {
                "|",
                "L",
                "J",
                "S"
            }
        },
        ["F"] = {
            ["east"] = {
                "-",
                "J",
                "7",
                "S"
            },
            ["south"] = {
                "|",
                "L",
                "J",
                "S"
            }
        }
    }

    local compatibility = compatibilities[src] and compatibilities[src][direction]
    if not compatibility then return false end

    for _, neighbour in ipairs(compatibility) do
        if neighbour == dest then
            return true
        end
    end

    return false
end

local file = io.open(arg[1], "r")
assert(file)

local startPos
local diagram = {}
local row = 1

for line in file:lines() do
    local rowTiles = {}

    for col = 1, #line do
        local tile = line:sub(col, col)
        rowTiles[col] = tile
        if tile == "S" then
            startPos = {col, row}
        end
    end

    table.insert(diagram, rowTiles)
    row = row + 1
end

local toStringCoordinate = function(pos)
    return "(" .. pos[1] .. ", " .. pos[2] .. ")"
end

local handleNeighbour = function(queue, seen, node, neighbourPos, maxSteps)
    if not seen[toStringCoordinate(neighbourPos)] then
        local steps = node.steps + 1

        queue:push({pos = neighbourPos, steps = steps})

        if steps > maxSteps then
            return steps
        end
    end

    return maxSteps
end

local queue = help.queue.create()
local seen = {}
local maxSteps = 0

queue:push({pos = startPos, steps = 0})

while not queue:empty() do
    local node = queue:pop()
    local nodePos = node.pos

    if not seen[toStringCoordinate(nodePos)] then
        seen[toStringCoordinate(nodePos)] = true
    end

    local src = diagram[nodePos[2]][nodePos[1]]
    local dest = diagram[nodePos[2] + 1] and diagram[nodePos[2] + 1][nodePos[1]]

    if dest and accessibleNeighbour(src, dest, "south") then
        local neighbourPos = {nodePos[1], nodePos[2] + 1}
        maxSteps = handleNeighbour(queue, seen, node, neighbourPos, maxSteps)
    end

    dest = diagram[nodePos[2] - 1] and diagram[nodePos[2] - 1][nodePos[1]]

    if dest and accessibleNeighbour(src, dest, "north") then
        local neighbourPos = {nodePos[1], nodePos[2] - 1}
        maxSteps = handleNeighbour(queue, seen, node, neighbourPos, maxSteps)
    end

    dest = diagram[nodePos[2]] and diagram[nodePos[2]][nodePos[1] + 1]

    if dest and accessibleNeighbour(src, dest, "east") then
        local neighbourPos = {nodePos[1] + 1, nodePos[2]}
        maxSteps = handleNeighbour(queue, seen, node, neighbourPos, maxSteps)
    end

    dest = diagram[nodePos[2]] and diagram[nodePos[2]][nodePos[1] - 1]

    if dest and accessibleNeighbour(src, dest, "west") then
        local neighbourPos = {nodePos[1] - 1, nodePos[2]}
        maxSteps = handleNeighbour(queue, seen, node, neighbourPos, maxSteps)
    end
end

print("partOne: " .. maxSteps)

file:close()