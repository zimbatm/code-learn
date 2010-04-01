var sys = require('sys');

function myFunc() {
	throw "Constructor called";
}

myFunc.prototype.moo = "x";


var x = Object.create(myFunc);

sys.p(x);
