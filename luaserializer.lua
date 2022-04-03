local SerialzerMeta = {}

function SerialzerMeta.create(pretty, margin)
    local Serializer = {
        pretty = pretty or false,
        margin = margin or string.rep(' ', 4)
    }
    setmetatable(Serializer, SerialzerMeta)
    return Serializer
end

function SerialzerMeta:serialize(any, level)
    assert(type(self) == 'table', '#self required')
    local t = type(any)

    level = level or 0
    assert(type(level) == 'number', 'bad argument #2: number or nil expected')

    if t == 'boolean' or t == 'string' then
        return string.format('%q', any)
    elseif t == 'number' then
        return string.format('%g', any)
    elseif t == 'table' then
        return self:serializeTable(any, level + 1)
    end
end

function SerialzerMeta:serializeTable(tb, level)
    assert(type(self) == 'table', '#self required')
    assert(type(tb) == 'table', 'bad argument #1: table expected')

    level = level or 0

    local result = '{'
    if self.pretty then result = result .. '\n' end

    local k = next(tb, nil)
    while k ~= nil do
        local v, nk = tb[k], next(tb, k)

        local serializedValue = self:serialize(v, level + 1)

        if serializedValue ~= nil then
            if self.pretty == true then
                result = result .. string.rep(self.margin, level)
                result = result .. string.format('[%q] = %s', k, serializedValue)
                if nk ~= nil then result = result .. ',' end
                result = result .. '\n'
            else
                result = result .. string.format('[%q]=%s', k, serializedValue, serializedValue)
                if nk ~= nil then result = result .. ',' end
            end
        end

        k = nk
    end
    if self.pretty == true then result = result .. string.rep(self.margin, level - 1) end
    result = result .. '}'
    return result
end

SerialzerMeta.__index = SerialzerMeta
SerialzerMeta.__metatable = {}

setmetatable(SerialzerMeta, {__metatable = {}})

return SerialzerMeta