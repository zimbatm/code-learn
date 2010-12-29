package main

//import "bool"

func assert(p bool) {
        if !p {
                panic("assert failed")
        }
}

type Boolean interface {
	  IsTrue() bool
}

func (b bool) IsTrue() bool { return b }

func (i interface{}) IsTrue() { return (i != nil) } 

func (i int) IsTrue() { return true }

func main() {
  var x *int;
  assert(!x.IsTrue());

  y := 3;
  assert(y.IsTrue());
}
