package main

import "fmt"

func main() {
	var myMap = make(map[string]string);
	myMap["message"] = "world";
	fmt.Printf("hello, %s\n", myMap["wrongkey"])
}



