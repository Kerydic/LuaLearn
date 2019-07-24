----------- 这里是父类一的定义 -----------
Account = {}
function Account:new(o)
    o = o or {balance = 0}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Account:withdrawal(v)
    self.balance = self.balance - v
end

function Account:deposit(v)
    self.balance = self.balance + v
end
----------- 这里是父类二的定义 -----------
Named = {}
function Named:getname()
    return self.name
end

function Named:setname(n)
    self.name = name
end

----------- 这里是子类一的定义 -----------
--在table plist中查找对象k，本质上相当于遍历所有的父类
local function search(k, plist)
    for i = 1 , #plist do
        local v = plist[i][k]
        if v then return v end
    end
end

function createClass (...)
    local c = {}                --新类的table
    local parents = {...}       --父类的集合
    --定义类在其父辈中搜索对象的方法
    setmetatable(c, {__index = function(t, k) return search(k, parents) end})
    --将c作为其实例的元表
    c.__index = c 
    function c:new(o)
        o = o  or {}
        setmetatable(o, self)
        return o
    end
    return c
end

NamedAccount = createClass(Account, Named)
n_account = NamedAccount:new{name = "kerydic"}
print(n_account:getname())

----------- 这里是子类二的定义 -----------
--由于之前的方法在搜索父类中的函数时搜索时间复杂度较高，故选择将所有的父类函数保存到子类的index中
--[[
    setmetatable(c, {
        __index = function(t, k)
            local v = search(k, parents)
            t[k] = v
            return v
        end
    })
]]