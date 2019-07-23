--for n in pairs(_G) do print(n) end

--[[
x = 30          这里声明了一个 全局变量
print(x)
_G["x"] = 19    这里通过环境和变量名对全局变量进行赋值操作，注意到_G是一个table，所以通过索引来进行获取
print(x)        一般来说这个功能使用于动态变量名的值的获取
]]

--通过设置_G变量的元函数，来实现禁止对全局table中不存在的key的访问
--[[
setmetatable(_G, {
    __newindex = function (_, n) 
        error("attempt to write to undeclared variable " .. n, 2) 
    end,
    __index = function (_, n) 
        error("attempt to read undeclared variable " .. n, 2) 
    end,
})
]]

--包括像a = 10这样的赋值都是被禁止的，此时想要声明新的变量，需要使用到rawset来绕过元表的检测，但是如下失败了，这里没有办法是用rawset创建函数？？？？
--[[ rawset(_G, declare, function (name, initval) 
--     rawset(_G, name, initval or false)
-- end or false)
]]

--最终解决方案，判断是否是主程序块中声明了新变量，调用debug.getinfo(2,"S")，返回一个table，其中的字段what表示了调用元方法的函数是在主程序块还是C函数还是普通的Lua函数
local declaredNames = {}
setmetatable(_G, {
    __newindex = function (t, n, v)
        if not declaredNames[n] then
            local w = debug.getinfo(2, "S").what
            if w ~= "main" and w ~= "C" then
                error("attempt to write to undeclared variable " .. n, 2)
            end
            declaredNames[n] = true
        end
        rawset(t, n, v)
    end,
    __index = function (t, n, v)
        if not declaredNames[n] then
            error("attempt to read from undeclared variable " .. n, 2)
        end
    end
})

--这里声明a是不会出错的，因为a声明于主程序块中
a = 10
print(a)
--b的声明必然会失败，因为在非主程序块中声明了全局变量，但是要注意的是如果这个函数没有被运行，是不会报错的
function A () b = 10 end