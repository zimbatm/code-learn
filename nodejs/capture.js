var sys = require('sys'),
    i = 1;

var obj = "hello";
process.nextTick(function() {
  sys.p(obj);
});

obj = "world";
