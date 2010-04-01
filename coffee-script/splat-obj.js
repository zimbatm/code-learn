(function(){
  var Obj, ary, o, sys;
  sys = require('sys');
  Obj = function Obj() {  };
  Obj.prototype.fun = function fun() {
    var args;
    args = Array.prototype.slice.call(arguments, 0);
    sys.p(this);
    return sys.p(args);
  };
  ary = [1, 2, 3, 4];
  o = new Obj();
  o.fun.apply(o, ary);
})();