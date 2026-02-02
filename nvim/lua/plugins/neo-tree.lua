-- Neo-tree configuration
require("neo-tree").setup({
	close_if_last_window = true,
	window = {
		width = 30,
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
	},
})

-- vim: ft=lua ts=2 sw=2 et ai
