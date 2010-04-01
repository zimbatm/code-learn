var sys = require('sys');


var x = {a: 3}

sys.puts("Start");
try {
Object.freeze(x);

} catch(e) {
	sys.debug(e);
}

x.a = 5;

sys.debug(sys.inspect(x));


sys.puts("Done");
