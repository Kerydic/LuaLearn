function newAccount(initialBalance)
    --保存私有变量等
    local self = {
        balance = initialBalance,
        LIMIT = 10000.00
    }

    --不放在最终返回中的函数全部为私有函数
    local extra = function()
        if sefl.balance > self.LIMIT then
            return self.balance * 0.10
        else return 0 end
    end

    --这些函数放在了最终返回的函数元组中，为共有函数
    local withdrawal = function(v)
        self.balance = self.balance - v
    end

    local deposit = function(v)
        self.balance = self.balance + v
    end

    local getbalance = function()
        return self.balance + extra()
    end

    --保存在其中的全部是共有函数
    return {
        withdrawal = withdrawal,
        deposit = deposit,
        getbalance = getbalance
    }
end