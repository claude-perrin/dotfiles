--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

-- remap the key used to leave insert mode
--map('i', 'jk', '', {})
map('n', '`', [[:NERDTreeToggle<CR>]], {})
map('n', 'ff', [[:Telescope find_files]], {})
map('n', '<S-q>', [[:TagbarToggle<CR>]], {})
map("n", "<leader>fg", [[:lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]], {})

