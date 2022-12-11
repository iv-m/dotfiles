
-- {{{ General options

-- enable numbers
vim.wo.number = true
vim.wo.relativenumber = false

-- wrapping
vim.o.wrap = false
vim.o.linebreak = true

-- disable mouse
vim.o.mouse = ''

-- enable undo files
vim.bo.undofile = true

-- set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,longest'

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- folding
vim.o.foldmethod = 'marker'
vim.o.foldenable = false

-- }}}

-- {{{ Colorscheme: onedark

vim.opt.termguicolors = true
local onedark = require('onedark')
onedark.setup {
  style = 'cool',
  transparent = true,
  code_style = {
    comments = 'none'
  },
}
onedark.load()

-- }}}

-- {{{ WhichKey
require("which-key").setup {
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
}
-- }}}

-- {{{ LSP

local lspconfig = require('lspconfig')

local on_attach = function (_, bufnr)
  local nmap = function (keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  local tb = require('telescope.builtin')

  -- space mode
  nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
  -- nmap('<leader>a', vim.lsp.buf.code_action, 'Code [A]ction')
  nmap('<leader>d', tb.diagnostics, '[D]iagnostics picker')
  nmap('<leader>s', tb.lsp_document_symbols, 'Document [S]ymbols')
  nmap('<leader>S', tb.lsp_workspace_symbols, 'Workspace [S]ymbols')

  vim.keymap.set({'n', 'v'}, '<leader>a', vim.lsp.buf.code_action,
    { buffer = bufnr, desc = 'LSP Code [A]ctions' })

  -- navigation
  nmap('gd', tb.lsp_definitions, '[G]oto [D]efinition')
  nmap('gi', tb.lsp_implementations, '[G]oto [I]mplementation')
  nmap('gr', tb.lsp_references, '[G]oto [R]eferences')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gy', tb.lsp_type_definitions, '[T]ype [D]efinition')

  -- hovers
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')


  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end
local capabilities = require('cmp_nvim_lsp').default_capabilities(
	vim.lsp.protocol.make_client_capabilities())

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- turn on status information
require('fidget').setup()

-- }}}

-- {{{ Telescope

local telescope = require('telescope')
telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        width = 0.95,
        preview_width = 0.5,
        preview_cutoff = 128
      }
    }
  }
}
telescope.load_extension('fzf')

-- }}}

-- {{{ cmp

local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- }}}
