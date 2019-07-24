s = "quick brown fox jumps over the lazy dog"

--print(s:len())                    -> 39
--print(s:rep(2))                   -> quick brown fox jumps over the lazy dogquick brown fox jumps over the lazy dog
--print(s:upper())                  -> QUICK BROWN FOX JUMPS OVER THE LAZY DOG
--print(s:lower())                  注意这两个函数只影响小（大）写的字母

--print(s:sub(2, -10))              -> uick brown fox jumps over the    用于截取字符串，其中可以使用负索引，表示为从尾部到头部方向的索引

--[[
    print(s:byte(2))                -> 117      这里是u的编码，如果不输入参数默认为第一个字母，输入了一个参数则为这个参数位置的字母
    print(s:byte(2,3))              -> 117 105  这里是u和i的编码，输入第二个参数则为从参数一到参数二的所有字母的编码
    print(string.char(117, 105))    -> ui       char接受一个或多个编码将其转换为字符串
]]

--[[
    tag, title = "h1", "a title"
    print(string.format("<%s>%s</%s>", tag, title, tag))
]]

------------ 模式匹配 ------------
--[[
    i, j = s:find("fox")            查找字符串中与模式匹配的子串的起始索引和结尾索引，第二个参数为从哪个索引位置开始查找，还可以输入第三的参数，如果第三个参数为true，则用于匹配的模式会被当作纯字符串而非正则来处理
    print(i .. ' ' .. j)            -> 13 15
]]

--[[
    date =  "today is 24/7/2019"    查找并返回字符串中与模式相匹配的字串，存在和find相同的第二参数
    d = date:match("%d+/%d+/%d+")   
    print(d)                        -> 24/7/2019
]]

--[[
    for w in s:gmatch("%a+") do
        print(w)                    每行打印一个单词，gmatch会返回一个迭代器，每次调用时返回字符串的下一个匹配
    end
]]

--[[
    gsub有4个参数：
    s——————————表示待操作字符串
    pattern————表示待匹配的模式
    repl———————表示替换的操作
    {
        string      ->  直接替换
        table       ->  用每个匹配都是用第一个捕获内容作为key来查询该table
        function    ->  对每个匹配都使用捕获到的内容作为参数调用
    }对于表查询和函数调用，如果返回的值是字符串或者数字，则将其用于替换，如果为false或者nil，则不替换）
    n——————————可选，用于给定替换前多少个匹配
    同时，gsub不仅返回替换过的字符串，还返回在整个子串中发生匹配的次数

    print(string.gsub("hello world", "(%w+)", "%1 %1"))
    --> hello hello world world 2

    print(string.gsub("hello world", "%w+", "%0 %0", 1))
    --> hello hello world 1

    print(string.gsub("hello world from Lua", "(%w+)%s*(%w+)", "%2 %1"))
    --> world hello Lua from 2

    local t = {name="lua", version="5.3"}
    print(string.gsub("$name-$version.tar.gz", "%$(%w+)", t))
    --> lua-5.3.tar.gz 2

    print(string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s)
        return load(s)()
        end))
    --> 4+5 = 9 1
]]

--[[待完善
    string.pack(fmt, v1, v2, ...)
    string.packsize(fmt)
    string.reverse(s)
    string.unpack(fmt, s [, pos])
]]