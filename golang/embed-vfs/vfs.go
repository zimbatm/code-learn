package main

import (
	"fmt"
//	pathutil "path"
//	ioutil "io/ioutil"
)

/*
A read-only VFS
*/


type Vfs struct {
	path string
	data map[string]string
}

func (v *Vfs) ReadFile(path string) (string, bool) {
	b, ok := v.data[path]
	if (ok) {
		return b, true;
	} else {
		fmt.Printf("vfs has %d items\n", len(v.data));
	}
	// FS lookup activated
	/*if v.path != "" {
		fullPath := pathutil.Join(v.path, path);
		b, err := ioutil.ReadFile(fullPath);
		if (err != nil) {
			return "", false;
		}
		v.data[path] = b.String();
		return b, true;
	}*/
	return "", false;
}

var vfs *Vfs;

func initVfs() {
	if (vfs == nil) {
		fmt.Printf("Initializing vfs\n");
		vfs = NewVfs();
	}
}

func NewVfs() (vfs *Vfs) {
	vfs = new(Vfs)
	vfs.path = ""
	vfs.data = make(map[string]string);
	return vfs
}

func ReadFile(path string) (string, bool) {
	initVfs();
	return vfs.ReadFile(path)
}

func SetPath(path string) {
	initVfs();
	vfs.path = path;
}

