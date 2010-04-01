var sys = require('sys');

var x = 3;

(function(x) {
 delete x;
 sys.puts(x);
})(6);

(function() {
 var x = 7;
 delete x;
 sys.puts(x);
})();

