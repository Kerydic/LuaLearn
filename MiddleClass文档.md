# 关于在项目中class的学习和使用
此项目中的class来源于**github**项目：[middleclass](https://github.com/kikito/middleclass)

### 简介
MiddleClass是lua语言的一个面向对象的库，其源代码具有相当的可读性，所以用户可能需要花一些时间去看一遍，以便深入了解Lua惊人的灵活性。

### 一个简单的例子
下列代码展示了这个库的一些基本的功能

```lua
--想要使用这个库，需要将其添加到自己的项目中然后require
local class = require 'middleclass'	
--赋予类名字，这与class('Person', Object)或Object:subclass('Person')相同	
Person = class('Person')
--初始化这个类
function Person:initialize(name)
  self.name = name
end
--为这个类定义函数，注意无论是初始化还是声明函数，都需要使用类名+冒号这样的形式
function Person:speak()
  print('Hi, I am ' .. self.name ..'.')
end
--声明一个类的子类，或者使用Person:subclass('AgedPerson')
AgedPerson = class('AgedPerson', Person)
--通过这样的方式来声明一个类的变量
AgedPerson.static.ADULT_AGE = 18
--调用父类的构造函数
function AgedPerson:initialize(name, age)
  Person.initialize(self, name) 
  self.age = age
end
--在函数中访问类变量
function AgedPerson:speak()
  Person.speak(self) --打印"Hi, I am xx."
  if(self.age < AgedPerson.ADULT_AGE) then
    print('I am underaged.')
  else
    print('I am an adult.')
  end
end
--相当于AgedPerson('Billy the Kid', 13)，其中:new被隐藏了
local p1 = AgedPerson:new('Billy the Kid', 13)
local p2 = AgedPerson:new('Luke Skywalker', 21)
p1:speak()
p2:speak()
```
继承的基本方法是`class('a', b)`，除此之外，也可以使用`b:subclass('a')`这样的形式。
注意，当你使用`A:new()`这样的方法来新建一个类的对象时，只有子类的构造函数会被调用，用户必须自己调用父类的构造函数：

```lua
function A:initialize()
  B.initialize(self, ...)
end
```
这个规则同样适用于非构造函数方法，没有super关键字，必须用户显示自调用。
### Mixins（待翻译）
Mixins可以用来在非同父类的两个类之间共享函数。

```lua
local class = require 'middleclass'
HasWings = { -- HasWings是一个Module而非类，其可以被"included"进一个类，相当于Interface（接口）
  fly = function(self)
    print('flap flap flap I am a ' .. self.class.name)
  end
}
Animal = class('Animal')
Insect = class('Insect', Animal) -- or Animal:subclass('Insect')
Bee = class('Bee', Insect)
Bee:include(HasWings) --Bees have wings. This adds fly() to Bee
Mammal = class('Mammal', Animal)
Bat = class('Bat', Mammal)
Bat:include(HasWings) --Bats have wings, too.
local bee = Bee() -- or Bee:new()
local bat = Bat() -- or Bat:new()
bee:fly()
bat:fly() -- 包含了同一个Module的两个类都可以访问类中的函数
```
middleclass为使用者提供了一种叫做include的方法，这种方法可以将定义好了的table以类似接口的形式被多个类所继承。除了上面所使用的直接在table中定义函数的方法外，还可以使用在Mixins名后加冒号的形式来定义接口内的函数。
注意一点，include函数是可以自定义的，并且每次有类包含一个Mixin时，include函数都会被调用一次，故有如下操作：
```lua
local class = require 'middleclass'
DrinksCoffee = {}

-- This is another valid way of declaring functions on a mixin.
-- Note that we are using the : operator, so there's an implicit self parameter
function DrinksCoffee:drink(drinkTime)
  if(drinkTime~=self.class.coffeeTime) then
    print(self.name .. ': It is not the time to drink coffee!')
  else
    print(self.name .. ': Mmm I love coffee at ' .. drinkTime)
  end
end

-- the included method is invoked every time DrinksCoffee is included on a class
-- notice that paramters can be passed around
function DrinksCoffee:included(klass)
  print(klass.name .. ' drinks coffee at ' .. klass.coffeeTime)
end

EnglishMan = class('EnglishMan')
EnglishMan.static.coffeeTime = 5
EnglishMan:include(DrinksCoffee)
function EnglishMan:initialize(name) self.name = name end

Spaniard = class('Spaniard')
Spaniard.static.coffeeTime = 6
Spaniard:include(DrinksCoffee)
function Spaniard:initialize(name) self.name = name end

tom = EnglishMan:new('tom')
juan = Spaniard:new('juan')

tom:drink(5)
juan:drink(5)
juan:drink(6)
```
### 元方法
使用元方法可以进行一系列骚操作，比如让实例可以进行加法等，这里看一个__tostring的例子：

```lua
Point = class('Point')
function Point:initialize(x,y)
  self.x = x
  self.y = y
end
function Point:__tostring()
  return 'Point: [' .. tostring(self.x) .. ', ' .. tostring(self.y) .. ']'
end

p1 = Point(100, 200)
p2 = Point(35, -10)
print(p1)		--> Point: [100, 200]
print(p2)		--> Point: [35, -10]
```
### 私有性的声明
middleclass提供了几种声明私有变量的方法：
##### 1、下划线
在Lua5.1的手册中明确写了这种方法，在属性之前加上下划线，可以让属性成为“私有的”，但是注意，这种方法只是让程序员知道，这个属性是私有的，但是实际上依然可以被访问到。
##### 2、私有类属性
创建私有函数或变量的根本方法是使用Lua的作用域，在每个单独的文件上创建每个类，然后将这些类的属性设置类本地即可。由于Lua的本地声明的作用域只在本文件内，其他文件的对象即使想访问该对象也是不可行的，即使他们require了该文件。
##### 3、私有实例方法
声明私有的方法也是可行的，根本方法就是不要在类体中声明这些方法，转而将它声明为不含“ClassName:”标识的本地函数，这样其他文件中的对象就再也无法访问到这个函数了

```lua
-- File 'MyClass3.lua'
local class = require('middleclass')
MyClass3 = class('MyClass3')
local _secretMethod = function(self) -- notice the 'local' at the beginning, the = function and explicit self parameter
  return( 'My name is ' .. self.name .. ' and I have a secret.' )
end
function MyClass3:initialize(name)
  self.name = name
end
function MyClass3:shout()
  print( _secretMethod(self) .. ' You will never know it!' )
end

-- File 'Main.lua'
require('MyClass3')
peter = MyClass3:new('peter')
peter:shout() -- My name is peter and I have a secret. You will never know it!
print(_secretMethod(peter)) -- throws an error - _secretMethod is nil here.
```
这种方法同样可以用来创建私有类方法，在MiddleClass中，类方法和实例方法是没有本质区别的，不同在于程序员传递给他们的self参数，如果传递给一个私有方法的self参数不是实例而是类名，那么这个函数是一个类方法。在函数体中使用该类的属性时，将self改为类名甚至可以不再写参数里的self。
```lua
MyClass3 = class('MyClass3')
local _secretClassMethod = function() --不用再写self参数
  return( 'My name is ' .. MyClass3.name .. ' and I have a secret.' ) -- use MyClass3 directly.
end

--注意只有私有方法才推荐使用这种方法，公有类方法仍然需要显式地在函数名前添加类名。
MyClass3 = class('MyClass3')

function MyClass3.classMethod(theClass)
  return( 'Being a public class named ' .. theClass.name .. ' is not a bad thing.' )
end
```
##### 4、私有实例属性
使用一个weak table来存储私有属性

```lua
-- File 'MyClass4.lua'
local class = require('middleclass')

MyClass4 = class('MyClass4')

local _private = setmetatable({}, {__mode = "k"})   -- weak table storing all private attributes

function MyClass4:initialize(name, age, gender)
  self.name = name
  _private[self] = {
    age = age,
    gender = gender
  }
end

function MyClass4:getName() -- shorter equivalent: MyClass4:getter('name')
  return self.name
end

function MyClass4:getAge()
  return _private[self].age
end

function MyClass4:getGender()
  return _private[self].gender
end

-- File 'main.lua'

require('MyClass4')

stewie = MyClass4:new('stewie', 2, 'male')

print(stewie:getName()) -- stewie
stewie.name = 'ann'
print(stewie.name) -- ann

print(stewie:getAge()) -- 2
stewie.age = 14        -- this isn't really modifying the age... it is creating a new public attribute called 'age'
-- the internal age is still unaltered
print(stewie:getAge()) -- 2
-- the newly created external age is also available.
print(stewie.age) -- 14

-- same goes with gender:

print(stewie:getGender()) -- 'male'
stewie.gender = 'female'
print(stewie:getGender()) -- 'male'
print(stewie.gender) -- 'female'
```
##### 5、同一个文件上的私有成员
如果有需求，也可以在同一个文件上创建其他成员无法访问的私有成员，方法是声明一个do...end的域，在这个域中声明的函数对所有这个域外的函数来说都是不可见的。注意，这个区域内的函数在执行完毕之后就会被垃圾回收，除非有所引用，所以在这个域内创建一些类的成员函数，被这些成员函数访问的函数就不会被回收，成为一个私有成员。

```lua
-- File 'MyClass3.lua'
local class = require('middleclass')

MyClass3 = class('MyClass3')

function MyClass3:initialize(name)
  self.name = name
end

do
  local secretMethod = function(self) -- notice the explicit self parameter here.
    return( 'My name is ' .. self.name .. ' and I have a secret.' )
  end

  function MyClass3:shout()
    print( secretMethod(self) .. ' You will never know it!' )
  end
end

-- functions outside the do-end will not 'see' secretMethod, but they will see MyClass3.shout (because they see MyClass3)
```
### 一些默认创建的方法
MiddleClass为用户提供了一些默认的方法，如下所示：

* 获取类名：MyClass.name
* 获取父类：MySubClass.super
* 声明静态方法：Muclass.static:func(...)
* 创建子类：MyClass:subclass("MySubClass")
* 检测子类创建事件：MyClass.static:subclassed(other)
* 判断是否为子类：MySubClass:isSubClassOf(MyClass)
* 创建实例：MyClass:new()
* 定义构造函数：MyClass:initialize(...)
* 判断是否为类的实例：myClass.isInstanceOf(MyClass)
* 每个类的默认元方法：print(myClassInstance:__tostring)
* 调用接口：MyClass:include(someMixin)