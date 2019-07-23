--在每个chunk（代码块）中使用——Env，可以用来改变一个函数的环境

a = 1
function func1()  
    local _Env = {g = _G}    --这里获取到了全局环境，也可以筛选其中的一部分，但是不能为空，因为函数只会使用给其设置的环境了
    print(a)
end
func1()                     --打印nil 1



function func2()
    local newgt = {}
    setmetatable(newgt, {__index = _G})
    _Env = newgt

    print(a)
    a = 10
    print(a)                --这里修改环境中的变量不会影响到全局变量
    print(_G.a)
    _G.a = 20               --可以通过修改全局变量来改回原来的数值，但是修改全局变量不会影响环境中的变量
    print(_G.a)
end
func2()                     --打印1 10 1 20



--每个函数和某些closure都会继承父辈的环境，相互独立存在
function factory()
    return function() return a end end

local function setfenv(fn, env)
    local i = 1
    while true do
        local name = debug.getupvalue(fn, i)
        if name == "_ENV" then
            debug.upvaluejoin(fn, i, (function() return env end), 1)
            break
        elseif not name then
            break
        end
    
        i = i + 1
    end
      
    return fn
end                         --此函数用来设置upvalue中的——Env，模拟5.1版本中的setEnv/getEnv两个函数   

a = 3

f1 = factory() print(f1())  --3
f2 = factory() print(f2())  --3

--[[local c = debug.setupvalue(f1, 1, {a = 10})
    报错：attempt to call a nil value (global 'f1')，将f1更改为local值之后报错消失，但是无法print，说明之后的全局变量都被更改了
]]
setfenv(f1, {a = 10})
print(f1())                 --10
print(f2())                 --3