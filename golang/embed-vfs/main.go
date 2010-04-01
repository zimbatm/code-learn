package main

import "fmt"

func main() {
	//SetPath("./files")
	data, _ := ReadFile("yo.txt");
	//if (!ok) {
	//	fmt.Printf("no data\n");
	//}
	fmt.Printf("%s", data);
}
