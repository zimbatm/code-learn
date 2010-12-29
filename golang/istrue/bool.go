package bool

type Boolean interface {
  IsTrue() bool
}

func (b bool) IsTrue() bool { return b; }

func (i []interface{}) IsTrue() { return (i != nil); } 

