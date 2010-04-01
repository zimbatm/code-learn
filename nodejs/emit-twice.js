var sys = require('sys');
    xy = new process.EventEmitter(),
    count = 0;

xy.addListener('msg', function() {
  count += 1;
  sys.puts(count);
  xy.emit("msg");
  //xy.emit("msg");
});

xy.emit("msg");
