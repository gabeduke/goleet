package main

import (
	"fmt"
	"os"
	codes "github.com/gabeduke/goleet/pkg/codes"
)

func main() {
	s := "world"

	if len(os.Args) > 1 {
		s = os.Args[1]
	}

	fmt.Printf("Hello, %v!", s)
	fmt.Println("")

	if s == "pass" {
		os.Exit(codes.SUCCESS)
	}

	if s == "fail" {
		os.Exit(codes.FAIL)
	}
}
