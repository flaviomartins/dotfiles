# Define the Terraform plugin cache directory
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Create the directory if it doesn't exist
if [[ ! -d "$TF_PLUGIN_CACHE_DIR" ]]; then
  mkdir -p "$TF_PLUGIN_CACHE_DIR"
fi

# ── Terraform Cache Utilities ──

# Show size of each cached provider (sorted)
alias tf-cache='du -sh "$TF_PLUGIN_CACHE_DIR"/* 2>/dev/null | sort -h'

# Show total size of the plugin cache
alias tf-cache-total='du -sh "$TF_PLUGIN_CACHE_DIR" 2>/dev/null'

# Dry-run: Show files older than 60 days (change +60 as needed)
alias tf-cache-dry='find "$TF_PLUGIN_CACHE_DIR" -type f -atime +60 -print'

# Clean cache files not accessed in 60+ days (use with care!)
alias tf-cache-clean='find "$TF_PLUGIN_CACHE_DIR" -type f -atime +60 -print -delete'

# Shortcut to open the plugin cache in your file browser (macOS)
alias tf-cache-open='open "$TF_PLUGIN_CACHE_DIR"'
