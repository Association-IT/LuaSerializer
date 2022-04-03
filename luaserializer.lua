local SerialzerMeta = {}

function SerialzerMeta.create(pretty, space)
    local tspace = type(space)
    if tspace == 'nil' then
        space = string.rep(' ', 4)
    elseif tspace == 'number' then
        space = string.rep(' ', space)
    elseif tspace ~= 'string' then
        error('bad argument #2: number or string expected')
    end

    local o = {
        pretty = pretty or false,
        space = space
    }
    assert(type(o.pretty) == 'boolean', 'bad argument #1: boolean expected')

    setmetatable(o, SerialzerMeta)
    return o
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
                result = result ..
                    string.rep(self.space, level) .. string.format('[%q] = %s', k, serializedValue)
                if nk ~= nil then result = result .. ',' end
                result = result .. '\n'
            else
                result = result .. string.format('[%q]=%s', k, serializedValue, serializedValue)
                if nk ~= nil then result = result .. ',' end
            end
        end

        k = nk
    end
    if self.pretty == true then result = result .. string.rep(self.space, level - 1) end
    result = result .. '}'
    return result
end

SerialzerMeta.__index = SerialzerMeta
SerialzerMeta.__metatable = {}

setmetatable(SerialzerMeta, {__metatable = {}})

return SerialzerMeta