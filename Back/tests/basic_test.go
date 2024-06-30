package tests

import "testing"

func TestBasicAssertion(t *testing.T) {
	if 1 != 1 {
		t.Fatalf("expected 1 to equal 1")
	}
}
