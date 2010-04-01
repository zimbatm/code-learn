var sys = require('sys');

const PI = 3.14;

try {
	PI = 5;
	sys.debug(PI);
} catch(e) {
	sys.p(e);
}

