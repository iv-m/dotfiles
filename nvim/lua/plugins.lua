
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- first, use packer
  use 'wbthomason/packer.nvim'

  -- color scheme
  use 'navarasu/onedark.nvim'

  -- reminders for mapped keys
  use 'folke/which-key.nvim'

  -- "gc" to comment visual regions/lines
  use 'numToStr/Comment.nvim'

  -- detect tabstop and shiftwidth automatically
  use 'tpope/vim-sleuth'

  -- autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
  }

  -- lsp stuff
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'j-hui/fidget.nvim',
    },
  }

  -- rust extras
  use 'mrcjkb/rustaceanvim'

  -- git stuff
  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release'
  }

  -- Telescope stuff
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {'nvim-telescope/telescope-ui-select.nvim' }

  -- Other languages
  use {'vala-lang/vala.vim'}

  if packer_bootstrap then
    require('packer').sync()
  end
end)
