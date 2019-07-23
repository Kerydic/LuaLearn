Account = {balance = 0}

--[[
function Account.withDraw(v)
    Account.balance = Account.balance - v
end
这是一种不好的编程方式，由于函数体内限定了变量的主题，在该对象改名或者删除之后，这个函数就再也不能使用了
]]
function Account.withdrawal(self, v)
    self.balance = self.balance - v
end

function Account:deposit(v)
    self.balance = self.balance + v
end

--在函数的参数列表内增加一个使用者的参数，则可以将变量的主题限制到使用者身上，这样当原对象被舍弃后，仍能正常使用，并且对多个对象来说可以复用
a = Account; Account = nil
a.withdrawal(a, 100.0)
print(a.balance)
--以上语句还可以使用冒号形式，即
a:deposit(50.0)
print(a.balance)