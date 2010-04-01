var sys = require('sys');

function test() {
	this.moo = 'moo';
	sys.p(this);
}

test.call(true);

sys.p(true);
