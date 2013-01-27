package main

import (
	"fmt"
	"time"
)

func every(sleep time.Duration, cont chan bool) {
	for {
		fmt.Println("every: before sleep")
		time.Sleep(sleep)
		fmt.Println("every: before signal")
		cont <- true
		fmt.Println("every: after signal")
	}
	fmt.Println("WTF???")
}

func DoSomething(cont chan bool) {
	for <- cont {
		fmt.Println("Doing something")
	}
	fmt.Println("DoSomething: done")
	close(cont)
	fmt.Println("DoSomething: closed")
}

func main() {
	cont := make(chan bool)

	go every(time.Duration(1) * time.Second, cont)
	go DoSomething(cont)

	close(cont)

	fmt.Println("Stuff started")

	time.Sleep(time.Duration(10) * time.Second)

	cont <- false

}
