var sys = require('sys');
  SLICE = Array.prototype.slice;

function Continuation(func, args) {
	this.func = func;
	this.args = args;
}

function NOW(func) {
  throw new Continuation(func, SLICE.call(arguments, 1));
}

function cps_call(func) {
  var cc = new Continuation(func, []);
  while (true) {
    try {
      cc.func.apply(null, cc.args);
      break;
    } catch (ex) {
      if (ex instanceof Continuation) {
        cc = ex;
      } else {
        throw ex;
      }
    }
  }
}

function sum(n, cont) {
    if (n == 0) NOW(cont, 0);
    NOW(sum, n - 1, function(result){
        NOW(cont, n + result);
    });
}

var i=100;
while(i--) {
cps_call(function(){
    // and what do you know, this time it works!
    // the result is 4501500
    sum(3000, function(result){
        //sys.puts(result);
    });
});
}

