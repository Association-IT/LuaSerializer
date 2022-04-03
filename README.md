# Lua 序列化库

把 Lua 对象（表）序列化为 Lua 代码。

## 测试

Clone后直接运行 `test.lua`。

## 使用方法

### 1. 导入serializer

使用 `require()` 或 `loadfile()`。

```lua
local Serializer = loadfile('luaserializer.lua')()
```

### 2. 创建对象

```lua
local s = Serialzer.create{pretty = true, space = 4}
```

### 3. 序列化

```lua
local str = s.serialize(object)
```

### 4. 反序列化

```lua
local object = load('return ' .. str)()
```

## 函数与方法

---

```lua
luaserializer.create(config)
```
创建并返回一个Serializer对象。

|参数名|类型|简介|
|:-:|:-:|:-:|
|`config`|`table`或`nil`|配置，参考下表|

|键|类型|简介|
|:-:|:-:|:-:|
|`pretty`|boolean|是否格式化输出，与`space`一起使用，默认为`false`|
|`space`|string或number|格式化输出时，用于缩进的单位，默认为4个空格; 类型是 number 时，单位为 number 个空格|

---

```lua
Serializer.serialize(any)
```
返回序列化成字符串的对象，**对于`nil`, `string`, `userdata`, `function` 和 `thread`, 返回`nil`**。
|参数名|类型|简介|
|:-:|:-:|:-:|
|`any`|任意类型|要序列化的对象|

---
