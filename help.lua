return {
    splitInTwo = function(str, delimiter)
        local it = str:gmatch("[^" .. delimiter .. "]+")
        return it(), it()
    end,

    splitIntoTable = function(str, delimiter, transform)
        local result = {}
        for token in str:gmatch("[^" .. delimiter .. "]+") do
            table.insert(result, transform and transform(token) or token)
        end
        return result
    end,

    deepCopy = function(self, t)
        local copy = {}
        for key, value in pairs(t) do
            if type(value) == "table" then
                copy[key] = self:deepCopy(value)
            else
                copy[key] = value
            end
        end
        return copy
    end,

    queue = {
        create = function ()
            local container = {}
            return {
                pop = function(self)
                    local top = container[1]
                    table.remove(container, 1)
                    return top
                end,
                push = function(self, e)
                    table.insert(container, e)
                end,
                empty = function(self)
                    return #container == 0
                end,
                size = function(self)
                    return #container
                end
            }
        end
    },

    stringToTable = function(str)
        local buffer = {}
        for i = 1, #str do
        buffer[i] = str:sub(i,i)
        end
        return buffer
    end,

    slice = function(t, start, stop)
        local s = {}
        for i = start, stop do
            table.insert(s, t[i])
        end
        return s
    end
}