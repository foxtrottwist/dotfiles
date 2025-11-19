return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	opts = {
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		handler_opts = {
			border = "rounded",
		},
		-- Automatically trigger signature help
		floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
		floating_window_above_cur_line = true, -- try to place the floating above the current line when possible
		floating_window_off_x = 1, -- adjust float windows x position
		floating_window_off_y = 0, -- adjust float windows y position
		fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
		hint_enable = true, -- virtual hint enable
		hint_prefix = "🐼 ", -- Panda for parameter
		hint_scheme = "String",
		hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
		max_height = 12, -- max height of signature floating_window
		max_width = 80, -- max_width of signature floating_window
		transpancy = nil, -- disabled by default, allow floating win transparent value 1~100
		always_trigger = false, -- sometime show signature on new line or in middleware of parameter can be annoying, set it to false for #58
		auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
		extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
		zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
		padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
		timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
		toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
		select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
