var sys = require('sys');
  SLICE = Array.prototype.slice,
  STACK_SIZE = null,
  STACK_EX = null,
  CALL_COUNT = 0;
  CALL_COST = 1;

function getStackSize() {
  var count = 0;
  try {
    testStack();
  } catch(ex) { 
    STACK_EX = ex.constructor;
  }

  return count;

  function testStack() {
    count += 1;
    testStack();
  }
}

function Continuation(func, args) {
	this.func = func;
	this.args = args;
}

function NOW(func) {
  if (CALL_COUNT * CALL_COST >= STACK_SIZE) {
    // Unwind stack
    throw new Continuation(func, SLICE.call(arguments, 1));
  } else {
    CALL_COUNT += 1; // NOW() + func() + ???
    func.apply(null, SLICE.call(arguments, 1));
  }
}

function cps_call(func) {
  CALL_COUNT = 0;
  STACK_SIZE = getStackSize();
  var cc = new Continuation(func, []);
  while (true) {
    try {
      cc.func.apply(null, cc.args);
      break;
    } catch (ex) {
      if (ex instanceof Continuation) {
	CALL_COUNT = 0;
        cc = ex;
      } else if (ex instanceof STACK_EX) {
        // Adjust CALL_COST
	CALL_COST = Math.ceil(STACK_SIZE / CALL_COUNT, 10);
	sys.puts("Call cost adjusted: " + CALL_COST);
	// retry previous continuation
      } else {
	sys.puts(ex);
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
 //       sys.puts(result);
    });
});
}

