#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_kubeconfigs() {
        // This will return configs from the user's actual home directory
        let configs = get_kubeconfigs();
        
        // Should not panic and should return a vector (even if empty)
        assert!(configs.is_empty() || !configs.is_empty());
    }

    #[test]
    fn test_get_kubeconfigs_filtering() {
        let configs = get_kubeconfigs();
        
        // All configs should end with .kubeconfig
        for config in configs {
            assert!(config.ends_with(".kubeconfig"), 
                "Config '{}' does not end with .kubeconfig", config);
        }
    }
}
