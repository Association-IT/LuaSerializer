# Lua 序列化库

把 Lua 对象序列化为 Lua 代码。

## 测试

Clone后直接运行 `test.lua`。

## 使用方法

### 1. 导入serializer

使用 `require()` 或 `loadfile()`。

```lua
local Serializer = require('luaserializer')
```

### 2. 创建对象

```lua
local s = Serialzer.create(true, string.rep(' ', 4))
```

### 3. 序列化

```lua
local str = Serializer.serialize(value)
```

### 4. 反序列化

```lua
local object = load('return ' .. str)()
```

## 函数与方法

---

```lua
luaserializer.create(pretty, margin)
```
返回一个Serializer对象。

|参数名|类型|简介|
|:-:|:-:|:-:|
|`pretty`|boolean|是否格式化输出，与`margin`一起使用，默认为`false`|
|`margin`|string|格式化输出时，用于缩进的单位|

---

```lua
Serializer.serialize(any, level)
```
返回序列化成字符串的对象，**对于`nil`, `string`, `userdata`, `function` 和 `thread`, 返回`nil`**。
|参数名|类型|简介|
|:-:|:-:|:-:|
|`any`|任意类型|要序列化的对象|
|`level`|number|(用于格式化)嵌套的table层数|

---

```lua
Serializer.serializeTable(tb, level)
```
返回序列化成字符串的表。
|参数名|类型|简介|
|:-:|:-:|:-:|
|`tb`|table|要序列化的表|
|`level`|number|(用于格式化)嵌套的table层数|
---
