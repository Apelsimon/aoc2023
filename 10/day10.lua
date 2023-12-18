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

local handleNeighbour2 = function(queue, seen, neighbourPos)
    if not seen[toStringCoordinate(neighbourPos)] then
        queue:push({pos = neighbourPos})
    end
end

local partOne = function(startPos, diagram)
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

    return maxSteps
end

-- kudos: https://github.com/OskarSigvardsson/adventofcode/blob/master/2023/day10/day10.py
local partTwo = function(startPos, diagram)
    local queue = help.queue.create()
    local seen = {}
    local polygonBounds = {
        minX = startPos[1],
        maxX = startPos[1],
        minY = startPos[2],
        maxY = startPos[2]
    }

    queue:push({pos = startPos})

    while not queue:empty() do
        local node = queue:pop()
        local nodePos = node.pos

        if not seen[toStringCoordinate(nodePos)] then
            seen[toStringCoordinate(nodePos)] = true

            if nodePos[1] < polygonBounds.minX then
                polygonBounds.minX = nodePos[1]
            end
            if nodePos[1] > polygonBounds.maxX then
                polygonBounds.maxX = nodePos[1]
            end
            if nodePos[2] < polygonBounds.minY then
                polygonBounds.minY = nodePos[2]
            end
            if nodePos[2] > polygonBounds.maxY then
                polygonBounds.maxY = nodePos[2]
            end
        end

        local src = diagram[nodePos[2]][nodePos[1]]
        local dest = diagram[nodePos[2] + 1] and diagram[nodePos[2] + 1][nodePos[1]]

        if dest and accessibleNeighbour(src, dest, "south") then
            local neighbourPos = {nodePos[1], nodePos[2] + 1}
            handleNeighbour2(queue, seen, neighbourPos)
        end

        dest = diagram[nodePos[2] - 1] and diagram[nodePos[2] - 1][nodePos[1]]

        if dest and accessibleNeighbour(src, dest, "north") then
            local neighbourPos = {nodePos[1], nodePos[2] - 1}
            handleNeighbour2(queue, seen, neighbourPos)
        end

        dest = diagram[nodePos[2]] and diagram[nodePos[2]][nodePos[1] + 1]

        if dest and accessibleNeighbour(src, dest, "east") then
            local neighbourPos = {nodePos[1] + 1, nodePos[2]}
            handleNeighbour2(queue, seen, neighbourPos)
        end

        dest = diagram[nodePos[2]] and diagram[nodePos[2]][nodePos[1] - 1]

        if dest and accessibleNeighbour(src, dest, "west") then
            local neighbourPos = {nodePos[1] - 1, nodePos[2]}
            handleNeighbour2(queue, seen, neighbourPos)
        end
    end

    local outOfBounds = function (point, bounds)
        return (point[1] < bounds.minX) or (point[1] > bounds.maxX) or (point[2] < bounds.minY) or (point[2] > bounds.maxY)
    end

    local size = {#diagram[1], #diagram}
    local enclosedArea = 0

    for y = 1, size[2] do
        for x = 1, size[1] do
            if not seen[toStringCoordinate({x, y})] and not outOfBounds({x, y}, polygonBounds) then
                local xi, yi = x, y
                local crossings = 0

                while xi <= size[1] and yi > 0 do
                    local tile = diagram[yi][xi]
                    if seen[toStringCoordinate({xi, yi})] and (tile ~= "J" and tile ~= "F") then
                        crossings = crossings + 1
                    end
                    xi = xi + 1
                    yi = yi - 1
                end

                if (crossings % 2) == 1 then
                    enclosedArea = enclosedArea + 1
                end
            end
        end
    end

    return enclosedArea
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

print("partOne: " .. partOne(startPos, diagram))
print("partTwo: " .. partTwo(startPos, diagram))

file:close()