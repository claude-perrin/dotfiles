local g = vim.g
g.t_co = 256
g.background = "dark"

-- Update the packpath
local packer_path = vim.fn.stdpath('config') .. '/site'
vim.o.packpath = vim.o.packpath .. ',' .. packer_path

--coc_filetype_map = {'yaml.ansible': 'ansible',}

