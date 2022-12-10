
local tb = require('telescope.builtin')

-- unmap space -- it's our new Leader
-- for 'n' mode it's not needed not needed with WichKey
vim.keymap.set('v', '<Space>', '<Nop>', { silent = true })

-- deal with word wrap nicely
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- space mode

local spmap = function(key, action, desc)
  vim.keymap.set('n', '<leader>'..key, action, { desc = desc })
end

spmap('<space>', tb.builtin, 	'[ ] Select Telescope builtin')
spmap('f',       tb.find_files, '[F]ind files')
spmap('b',       tb.buffers,    '[B]uffer picker')
spmap('j',       tb.jumplist,   '[J]umplist picker')
spmap('t',       tb.tagstack,   '[T]agstack picker')
spmap('\'',      tb.resume,     '[\'] Previous picker')
spmap('/',       tb.current_buffer_fuzzy_find,
      '[/] Live fuzzy search in the current buffer')

-- git pickers
spmap('gs', tb.git_status,  '[G]it [S]tatus')
spmap('gc', tb.git_commits, '[G]it [C]ommits')
spmap('gb', tb.git_bcommits, '[G]it commits for current [B]uffer')
