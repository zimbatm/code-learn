package main

import (
	"os"
	"fmt"
)

func main() {
	env := os.Environ()
	fmt.Printf("%v\n", env)
}
