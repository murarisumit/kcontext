package main

import (
	"testing"
)

func TestGetKubeconfigs(t *testing.T) {
	configs := getKubeconfigs()
	
	// Should not panic and should return a slice (even if empty)
	if configs == nil {
		t.Error("getKubeconfigs() returned nil")
	}
	
	// Test that we get some configs (assuming user has kubeconfig files)
	t.Logf("Found %d kubeconfig files: %v", len(configs), configs)
}

func TestGetKubeconfigsFiltering(t *testing.T) {
	configs := getKubeconfigs()
	
	// All configs should end with .kubeconfig
	for _, config := range configs {
		if len(config) < 11 || config[len(config)-11:] != ".kubeconfig" {
			t.Errorf("Config '%s' does not end with .kubeconfig", config)
		}
	}
}
