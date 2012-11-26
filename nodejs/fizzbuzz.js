var fizz, buzz
for (var i=0; i<100; i++) {
  fizz = buzz = "";
  if (i%3 == 0) {
    fizz = "fizz";
  }
  if (i%5 == 0) {
    buzz = "buzz";
  }
  console.log( (fizz + buzz) || i );
}
