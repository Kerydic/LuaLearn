function basic_serialize(o)
    if type(o) == "number" then
        return tostring(o)
    else
        return string.format("%q", o)
    end
end

function circle_table_serialize(name, value, saved)
    saved = saved or {}
    io.write(name, "=")
    if type(value) == "number" or type(value) == "string" then
        io.write(basic_serialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then
            io.write(saved[value], "\n")
        else 
            saved[value] = name
            io.write("{}\n")
            for k,v in pairs(value) do
                k = basic_serialize(k)
                local fname = string.format("%s[%s]", name, k)
                circle_table_serialize(fname, v, saved)
            end
        end
    else error("cannot save a " .. type(value))
    end 
end

a = {x = 1, y = 2, {3,4,5}}
a[2] = a
a.z = a[1]

circle_table_serialize("a", a)