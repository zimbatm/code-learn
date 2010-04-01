var sys = require('sys');

function MyObj() {
}

MyObj.prototype.__noSuchMethod__ = function(id, args) {
	sys.puts(id + " got called");
}

var o = new MyObj();

o.hello();
o.world();
