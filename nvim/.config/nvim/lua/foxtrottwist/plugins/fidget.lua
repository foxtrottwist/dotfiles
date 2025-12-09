return {
	"j-hui/fidget.nvim",
	opts = {
		-- Options related to notification subsystem
		notification = {
			window = {
				winblend = 0,
				border = "rounded",
			},
		},
		-- Options related to LSP progress subsystem
		progress = {
			poll_rate = 0.5,
			suppress_on_insert = false,
			ignore_done_already = false,
			ignore_empty_message = false,
			display = {
				render_limit = 16,
				done_ttl = 3,
				progress_ttl = math.huge,
			},
		},
	},
}
