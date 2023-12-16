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
    end
}