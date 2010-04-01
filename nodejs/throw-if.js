var sys = require('sys');

function shouldCatch(err) {
  if (err instanceof Error) {
    return true;
  }
  return false;
}

try {
	throw new Error("moo");
} catch(err if err instanceof Error) {
	sys.puts("Catched");
}
