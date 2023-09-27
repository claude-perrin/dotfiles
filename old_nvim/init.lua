-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"
-- IMPORTS
require('vars')      -- Variables
require('opts')      -- Options
require('keys')      -- Keymaps
require('plug')      -- Plugins

require('lualine').setup {
--  options = {
  --  theme = 'nightfox'
  --}
}


require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "python", "yaml", "json" },

  -- Automatically install missing parsers when entering buffer
  auto_install = true,


  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    }
}


require('lualine').setup {
    sections = {
        lualine_a = {{
            'filename',
            file_status = true,
            path =2
        }}
    }
}


local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup {
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}



require('nvim-autopairs').setup{} -- Add this line
--require('nvim-tree').setup{}
