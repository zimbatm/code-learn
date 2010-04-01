
var sys = require('sys');

setTimeout(function() {
	throw "CATCHME IF YOU CAN";		
}, 500);

process.addListener("error", function(e) { 
	sys.p(e);
});
