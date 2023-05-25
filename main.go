package main

// #cgo CXXFLAGS: -std=c++11
// #include <stdlib.h>
// void printString(const char* str);
import "C"
import (
	"fmt"
	"unsafe"
)

func main() {
	str := "Hello from Go!"

	// Convert Go string to C string
	cstr := C.CString(str)
	defer C.free(unsafe.Pointer(cstr))

	// Call the C++ function
	C.printString(cstr)

	fmt.Println("Go program completed.")
}
