package tests

import "testing"

func TestAddPass(t *testing.T) {
	result := 2 + 3
	expected := 5
	if result != expected {
		t.Errorf("Add(2, 3) = %d; want %d", result, expected)
	}
}
