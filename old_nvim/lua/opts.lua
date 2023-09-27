--[[ opts.lua ]]
local opt = vim.opt

-- [[ Theme ]]
--cmd('colorscheme dracula')       -- cmd:  Set the colorscheme

vim.cmd('colorscheme gruvbox-material')
-- [[  Clipboard]]
opt.clipboard:append { 'unnamed', 'unnamedplus' }

--[[ Mouse ]]
opt.mouse="a" -- allow mouse to be used

--[[ Cursor ]]
opt.cursorline = true

-- [[ Context ]]
opt.number = true                -- bool: Show line numbers
--opt.relativenumber = true       -- bool: Show relative line numbers
opt.scrolloff = 4                -- int:  Min num lines of context
opt.signcolumn = "yes"           -- str:  Show the sign column

-- [[ Filetypes ]]
opt.encoding = 'utf8'            -- str:  String encoding to use
opt.fileencoding = 'utf8'        -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- [[ Search ]]
opt.ignorecase = true            -- bool: Ignore case in search patterns
opt.smartcase = true             -- bool: Override ignorecase if search contains capitals
opt.incsearch = true             -- bool: Use incremental search
opt.hlsearch = false             -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true             -- bool: Use spaces instead of tabs
opt.shiftwidth = 4               -- num:  Size of an indent
opt.softtabstop = 4              -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4                  -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true            -- bool: Place new window to right of current one
opt.splitbelow = true            -- bool: Place new window below the current one

--if vim.fn.has("wsl") then
--    vim.g.clipboard = {
--        name = "clip.exe (Copy Only)",
 --       copy = {
  --          ["+"] = "clip.exe",
--            ["*"] = "clip.exe"
--        },
--        paste = {
--            ["+"] = "clip.exe",
--            ["*"] = "clip.exe"
 --       },
 --       cache_enabled = true
 --   }
--end
