-- [[ plug.lua ]]
return require('packer').startup(function(use)
   
    use {
    'sainnhe/gruvbox-material',   -- Colorscheme
    'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' }, -- Better highlight
    -- 'preservim/nerdtree', -- filesystem navigation
    'preservim/nerdcommenter', -- commenting out line
    'ryanoasis/vim-devicons', -- NERDTree plugin to have icons 
    'wbthomason/packer.nvim' -- this is essential.
    }    


    use { 'mhinz/vim-startify' }                       -- start screen
    -- use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump, highlightning the line
--    use { 'liuchengxu/vista.vim' }                     -- Search of LSP symobls, fucntion jumps
    use {
        'nvim-lualine/lualine.nvim',                     -- statusline
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }
    
    -- Telescope
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
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,

}
    use {
        'preservim/tagbar',                          -- see usage of variable and tags
        'windwp/nvim-autopairs',                    -- auto close brackets, etc.
    }    
    -- Git integration
    -- use {
    --     'tpope/vim-fugitive',                       -- git integration
    --     'junegunn/gv.vim',                          -- commit history
    -- }

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        }
    }

      -- [[ Python ]]
--       use {
-- --        'dense-analysis/ale',         -- error highlight
--         'Vimjas/vim-python-pep8-indent',  --"better indenting for python
--         'roxma/nvim-yarp',  -- " dependency of ncm2
--         'ncm2/ncm2', -- " awesome autocomplete plugin
--         'Shougo/deoplete.nvim', -- "Async autocompletion
-- --        'zchee/deoplete-jedi',-- " Python autocompletion
--         'Shougo/context_filetype.vim', -- " Completion from other opened files
--         'jeetsukumaran/vim-indentwise',--" Indentation based movements
--         'lilydjwg/colorizer',--" Paint css colors with the real color
--  --       'tell-k/vim-autopep8', --"autopep8
--       }


    -- local config = {
    --       package_root = vim.fn.stdpath('config') .. '/site/pack'
    --   }
    end)
