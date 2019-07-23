Set = {}

local mt = {}
function Set.new(l)
    local set = {}
    setmetatable(set, mt) --将mt设置为当前table的元表
    for _, v in ipairs(l) do set[v] = true end
    return set
end

function Set.union(a, b) 
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

function Set.toString(set)
    local l = {}
    for e in pairs(set) do
        l[#l + 1] = e
    end
    return "{" .. table.concat(l, ", ") .. "}"
end

function Set.print(set)
    print(Set.toString(set))
end

s1 = Set.new{10, 20, 30, 40}
s2 = Set.new{30, 1}
mt.__add = Set.union
s3 = s1 + s2

s3 = s3 + 8
Set.print(s3)