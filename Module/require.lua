local modname = require             --模块名
local M = {}                        --定义的模块table
_G[modname] = M
package.loaded[modname] = M         --如果模块无返回值，可以直接调用package.loaded[modname]de当前值
local _Env = M 

function add(c1, c2)
    return new(c1.r + c2.r, c1.i + c2.i)
end

--调用外部包的三种方法
--1、将全局变量添加到模块中
setmetatable(M, {__index = _G})
local _Env = M 
--最慢，开销很小，但是可以访问全部的全局变量

--2、声明一个局部变量，以保存对旧环境的访问
local _G = _G
--没有涉及到元方法，比1略快，现在所有外部方法的前面要加上_G

--3、将所有需要用到的函数或模块声明为局部变量
--模块设置
--即本文件的开头4行

--导入段
local sqrt = math.sqrt
local io = io

--环境设置段
--local _Env = M
--注意在设置了环境的语句之后就不要再声明外部访问了，将所有的外部访问全部放在一起
--这种方法要求做更多的工作，但是能清晰说明模块的依赖，并且运行速度最快