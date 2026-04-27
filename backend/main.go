package main

import (
	"fmt"
	"log"
	"net/http"
)

type P struct {
	foo int32
	bar int32
}

func simpleSumTest(p1, p2 int) int {
	fmt.Printf("Adding %d and %d\n", p1, p2)
	return p1 + p2
}

func main() {
	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintln(w, "pong")
	})

	fmt.Println("Hello, World!")
	log.Println("Doing some work before starting the server...")

	log.Println("starting server on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}

	log.Println("Playing with go")
}
