--对于两个对象A和B，想要A成为B的原型（或者说类），将A加入到B的__index元方法中即可
--需要先建立一个对象，不然会报错：attempt to index a nil value (global 'Account')
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


a = Account:new{balance = 10000.00}
a:withdrawal(5000.00)

b = Account:new()
b:deposit(100.00)

print(a.balance, '  ', b.balance)