local function createSerializer(config)
    -- 参数检测
    config = config or {}
    assert(type(config) == 'table', 'bad argument #2: table expected')

    local tspace = type(config.space)
    local space, pretty

    if tspace == 'nil' then
        space = string.rep(' ', 4)
    elseif tspace == 'number' then
        space = string.rep(' ', config.space)
    elseif tspace ~= 'string' then
        error('bad argument #1: config: number or string expected')
    end

    pretty = config.pretty or false
    if type(pretty) ~= 'boolean' then
        error('bad argument #1: config: boolean expected')
    end

    -- 对象创建
    local self = {pretty = pretty, space = space}

    -- 序列化表的代码
    local function serialize(any, level)
        local t = type(any)

        level = level or 0
        assert(type(level) == 'number', 'bad argument #2: number or nil expected')

        local function serializeTable(tb, level)
            -- 开头 {\n
            local result = '{'
            if self.pretty then result = result .. '\n' end

            -- 遍历表
            local k = next(tb, nil)
            while k ~= nil do
                -- k: 键 v: 值 nk: 下一个键
                local v, nk = tb[k], next(tb, k)

                -- 序列化表项值
                local serializedValue = serialize(v, level + 1)

                -- 若值可被序列化
                if serializedValue ~= nil then
                    if self.pretty == true then
                        -- 美观输出，<缩进>[<键>] = <值>,\n
                        result = result .. string.rep(self.space, level) ..
                                     string.format('[%q] = %s', k,
                                                   serializedValue)
                        -- 没有下一项时不输出逗号
                        if nk ~= nil then result = result .. ',' end
                        result = result .. '\n'
                    else
                        --- 最小体积输出，[<键>]=<值>,
                        result = result ..
                                     string.format('[%q]=%s', k,
                                                   serializedValue,
                                                   serializedValue)
                        if nk ~= nil then result = result .. ',' end
                    end
                end

                -- step
                k = nk
            end

            -- 可选的缩进，之后闭表
            if self.pretty == true then result = result .. string.rep(self.space, level - 1) end
            result = result .. '}'

            return result
        end

        -- 按类型序列化
        if t == 'boolean' or t == 'string' then
            return string.format('%q', any)
        elseif t == 'number' then
            return string.format('%g', any)
        elseif t == 'table' then
            return serializeTable(any, level + 1)
        end
    end

    return {serialize = function(any) return serialize(any) end}
end

return {create = createSerializer}
