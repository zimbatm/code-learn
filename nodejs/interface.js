// TODO: finish me

function interface(constructor) {
	constructor.implement = function(obj) {
		var args = Array.prototype.slice.call(arguments, 1);
		process.mixin(obj, constructor.prototype);
		constructor.apply(obj, arguments);
	}
	return constructor;
}

var EventEmitter = interface(function() {
		
});

