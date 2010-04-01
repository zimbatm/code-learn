sys: require 'sys'

Obj: -> 
Obj::fun: (args...) ->
  sys.p this
  sys.p args

ary: [1,2,3,4]

o: new Obj()
o.fun(ary...)

