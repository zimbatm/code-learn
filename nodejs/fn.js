var pSlice = Array.prototype.slice;

function each(array, fn) {
  for (var i=0; i<array.length; i++) {
    fn(array[i], i);
  }
}

function map(array, fn) {
  var copy = [];
  for (var i=0; i<array.length; i++) {
    copy.push( fn(array[i], i) );
  }
  return copy;
}

function reduce(array, init, fn) {
  for (var i=0; i<array.length; i++) {
    init = fn(init, array[i], i);
  }
  return init;
}

function partial(fn) {
  var args = pSlice.call(arguments, 1);
  return function() {
    fn.apply(null, args.concat(pSlice.call(arguments)));
  }
}

function compose(fn1, fn2) {
  return function() {
    return fn1(fn2.apply(null, arguments));
  }
}

var op = {
  "+": function(a, b){return a + b;},
  "-": function(a, b){return a - b;},
  "*": 
  "==": function(a, b){return a == b;},
  "===": function(a, b){return a === b;},
  "!": function(a){return !a;}
  /* and so on */
};