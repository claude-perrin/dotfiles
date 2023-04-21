-- [[ plug.lua ]]
return require('packer').startup(function(use)
   
    use {
    'sainnhe/gruvbox-material',
    'nvim-treesitter/nvim-treesitter',
    'preservim/nerdtree', -- filesystem navigation
    'ryanoasis/vim-devicons', -- NERDTree plugin to have icons 
    'wbthomason/packer.nvim' -- this is essential.
    }    
    -- Startify
    use { 'mhinz/vim-startify' }                       -- start screen
    use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump
    use {
        'nvim-lualine/lualine.nvim',                     -- statusline
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
  }

use {
  "nvim-telescope/telescope.nvim",
  requires = {
    {'nvim-lua/plenary.nvim'} ,
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  config = function()
    require("telescope").load_extension("live_grep_args")
  end
}
    use {
    'preservim/tagbar',                          -- see usage of variable and tags
    'Yggdroot/indentLine',                      -- see indentation
    'tpope/vim-fugitive',                       -- git integration
    'junegunn/gv.vim',                          -- commit history
    'windwp/nvim-autopairs',                    -- auto close brackets, etc.
    'mfussenegger/nvim-dap'
  }                     -- Debug mode


  -- [[ Python ]]
  use {
'dense-analysis/ale',         -- error highlight
'Vimjas/vim-python-pep8-indent',  --"better indenting for python
'roxma/nvim-yarp',  -- " dependency of ncm2
'ncm2/ncm2', -- " awesome autocomplete plugin
'Shougo/deoplete.nvim', -- "Async autocompletion
'zchee/deoplete-jedi',-- " Python autocompletion
'Shougo/context_filetype.vim', -- " Completion from other opened files
'davidhalter/jedi-vim', -- " Just to add the python go-to-definition and similar features, autocompletion
'tpope/vim-surround',
'michaeljsmith/vim-indent-object', --" Indent text object
'jeetsukumaran/vim-indentwise',--" Indentation based movements
'mileszs/ack.vim', --" Ack code search (requires ack installed in the system)
'lilydjwg/colorizer',--" Paint css colors with the real color
'tell-k/vim-autopep8', --"autopep8
  }


  config = {
      package_root = vim.fn.stdpath('config') .. '/site/pack'
  }
end)
