package main

import "testing"

func TestSimpleSumTest(t *testing.T) {
	tests := []struct {
		name     string
		p1, p2   int
		expected int
	}{
		{"positive numbers", 2, 3, 5},
		{"zero values", 0, 0, 0},
		{"negative numbers", -4, -6, -12},
		{"mixed signs", -5, 10, 5},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := simpleSumTest(tt.p1, tt.p2); got != tt.expected {
				t.Errorf("simpleSumTest(%d, %d) = %d; want %d", tt.p1, tt.p2, got, tt.expected)
			}
		})
	}
}
