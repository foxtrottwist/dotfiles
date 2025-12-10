return {
  cmd = {
    "rustup",
    "run",
    "stable",
    "rust-analyzer",
  },
  root_markers = { "Cargo.toml", "Cargo.lock" },
  workspace_required = true,
}
