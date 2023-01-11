
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

-- timeouts: reduce those for whichkey
vim.o.timeoutlen = 400

-- }}}

-- {{{ Colorscheme: onedark
vim.opt.termguicolors = true
local onedark = require('onedark')
onedark.setup {
  style = 'cool',
  transparent = true,
  code_style = {
    comments = 'none',
  },
  colors = {
    fg = '#b0bbd0',
    grey = '#686f7d',
  },
}
onedark.load()
-- }}}

-- {{{ listchars
vim.opt.listchars = {
  trail = '●',
  nbsp = '␣',
  tab = '←·→',
  lead = '.'
}
vim.opt.list = false  -- breaks mouse selection copying
vim.cmd [[hi Whitespace guifg=#3d4451]]
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
  nmap('<leader>d', function () tb.diagnostics({bufnr=0}) end,
       'Buffer [D]iagnostics picker')
  nmap('<leader>D', tb.diagnostics, 'Workspace [D]iagnostics picker')
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
  nmap('<M-k>', vim.lsp.buf.signature_help, 'Signature Documentation')


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
  capabilities = capabilities,
  settings = { pylsp = { plugins = {
    jedi_symbols = { all_scopes = false },
    flake8 = { enabled = true },
    pyflakes = { enabled = false },
    mccabe = { enabled = false },
    pycodestyle = { enabled = false },
  } } }
}

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- turn on status information
require('fidget').setup()

-- }}}


-- {{{ Gitsigns

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc='Gitsigns: previous hunk'})

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc='Gitsigns: next hunk'})


    -- Actions
    map({'n', 'v'}, '<leader>ga', ':Gitsigns stage_hunk<CR>',
        {desc='[G]itsigns: st[A]ge hunk'})
    map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>',
        {desc='[G]itsigns: [R]eset hunk'})

    local function nlmap(l, r, desc)
      vim.keymap.set('n', '<leader>' .. l, r, {buffer=bufnr, desc=desc})
    end

    nlmap('gp', gs.preview_hunk, '[G]itsigns: [P]review hunk')
    nlmap('gb', function() gs.blame_line{full=true} end,
          '[G]itsigns: full [B]lame this line')
    nlmap('gd', gs.diffthis, '[G]itsigns: [D]iff this buffer')
    nlmap('gD', function() gs.diffthis('HEAD') end,
          '[G]itsigns: [D]iff this buffer against HEAD')
  end
}

-- }}}

-- {{{ Telescope

local telescope = require('telescope')
telescope.setup {
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        width = 0.95,
        preview_cutoff = 128,
        preview_width = 0.5,
        prompt_position = 'top',
      }
    },
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
    ['<C-Space>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.complete_common_string()
      end
      return cmp.complete()
    end),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.get_selected_entry() then
        return cmp.confirm()
      end
      return fallback()
    end),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        -- fallback()
      end
    end, { 'i', 's' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        -- fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp_signature_help' },
  },
}

-- }}}
