----------- 这里是父类的定义 -----------
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

----------- 这里是子类的定义 -----------
SpecialAccount = Account:new()
function SpecialAccount:getLimit()
    return self.limit or 0
end

function SpecialAccount:withdrawal(v)
    if v - self.balance >= self:getLimit() then
        error "insufficient funds"
    end
    self.balance = self.balance - v
end

s = SpecialAccount:new{limit = 1000.00}
s:deposit(100.00)
print(s.balance)
s:withdrawal(200.00)
print(s.balance)