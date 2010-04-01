var sys = require('sys');

function whatsup() {
  sys.p(this);
}

(function(hi) {
  whatsup.call(hi);
})();

