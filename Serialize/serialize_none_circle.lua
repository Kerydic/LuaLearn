function writeTab(n)
    for i = 1, n do
        io.write("    ")
    end
end

function serialize(o, n)
    if type(o) == "number" then
        io.write(o)
    elseif type(o) == "string" then
        io.write(string.format("%q:", o))
    elseif type(o) == "table" then
        writeTab(n)
        io.write("{\n")
        for k,v in pairs(o) do
            writeTab(n + 1)
            io.write(k, " = ")
            serialize(v, n + 1)
            io.write(",\n")
        end
        writeTab(n)
        io.write("}")
    else
        error("cannot serialize a " .. type(o))
    end
end

serialize({a=12,b="lua",key="another \"one\"",extra = {a = 1, b = 2}}, 0)