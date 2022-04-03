local Serializer = loadfile('luaserializer.lua')()

local s1, s2 = Serializer.create(true, 2), Serializer.create(false)

local str = s1:serialize(
    {
        Integer = 1,
        Number = 2.2,
        Boolean = false,
        String = 'Hello World',
        Function = function() end,
        Nil = nil,
        Table = {
            Content = "Content"
        }
    }
)


print(str)

print('\n\n\n')

print(s2:serialize(load('return '..str)()))
