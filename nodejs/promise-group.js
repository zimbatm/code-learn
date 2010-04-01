
function pMap(ary, fn) {
	var count = ary.length, ret = new Array(count), p = new Promise(), i;
	for (i=0; i<ary.length; i++) {
		// function used to capture key and value 
		(function (i, obj) {
		 	fn(i, obj).addCallback(function(value) {
				ret[i] = value;
				count--;
				if (count <= 0) {
					p.emitSuccess(ret);
				}
			}).addErrback(function(error) { p.emitError(error) }
		})(i, ary[i]);
	}

	return p;
}

var myArr = new Object();
var p = pMap(myArr, function(i, obj) {
	// should return a promise
	return client.get(i);
}

p.addCallback(function(newColl) {
	// executed when all objects are retrieved
}.addErrback...

