var sys = require('sys'),
    x = "error";

switch(x) {
	case false:
		sys.puts("got false");
		break;
	case "error":
		sys.puts("got error");
		break;
	default:
		sys.puts("default");
		break;
}
