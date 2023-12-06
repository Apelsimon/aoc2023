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
    end
}