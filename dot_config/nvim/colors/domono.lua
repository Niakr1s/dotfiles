-- Clear existing highlights
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

-- Set colorscheme name
vim.g.colors_name = 'domono'

-- Define your color palette
local colors = {
  bg_main = '#ffffff',
  bg_acc = '#F0F0F0',
  bg_cur = '#DDDDDD',
  bg_sel = '#BFDBFE',
  fg_main = '#222222',
  fg_dim = '#777777',
  fg_acc = '#000000',
  fg_yel = '#df8e1d',
  bg_yel = '#f9e8d2',
  fg_gre = '#448C27',
  bg_gre = '#dae8d4',
  fg_blu = '#325CC0',
  bg_blu = '#d6def2',
  fg_red = '#d20f39',
  bg_red = '#f6cfd7'
}

-- Helper function to set highlights
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Basic editor highlights
hl('Normal', { fg = colors.fg_main, bg = colors.bg_main })
hl('Comment', { italic=true, fg = colors.fg_yel, bg = colors.bg_yel })
hl('Keyword', { bold=true, fg=colors.fg_acc })
hl('String', { fg = colors.fg_gre })
hl('Function', {  })
hl('Type', {  })
hl('Constant', { link = 'String' })
hl('Operator', {  })
hl('Delimiter', { fg = colors.fg_dim })
hl('Special', {  })
hl('Identifier', {  })
hl('yamlBlockMappingKey', {  })
hl('MatchParen', { bg = colors.bg_blu, fg = colors.fg_blu })
hl('TermCursor', {  })
hl('Statement', {  })
hl('@variable', {  })
hl('@property', {  })
hl('Error', {  })
hl('Special', { fg = colors.fg_blu  })
hl('PreProc', { bold = true })

hl('DiagnosticOk', {  })
hl('DiagnosticInfo', {  })
hl('DiagnosticWarn', {  })
hl('DiagnosticError', {  })
hl('DiagnosticHint', {  })

-- Floating Windows
hl('FloatBorder', { bg = colors.bg_acc })
hl('FloatTitle', { bg = colors.bg_acc })
hl('DiagnosticFloatingInfo', { bg = colors.bg_acc, italic = true })
hl('DiagnosticFloatingHint', { bg = colors.bg_acc, fg = colors.fg_yel })
hl('NormalFloat', { bg = colors.bg_acc })
hl('Pmenu' , { bg = colors.bg_acc })

-- Bars and Lines
hl('Statusline', { bg = colors.bg_acc  })
hl('StatusLineNC', { bg = colors.bg_acc  })
hl('TabLine', { bg = colors.bg_acc })
hl('TabLineSel', { bg=colors.bg_main, bold=true, fg=colors.fg_acc })

-- UI elements
hl('LineNr', { fg=colors.fg_dim })
hl('Directory', { fg = colors.fg_main })
hl('MoreMsg', { fg = colors.fg_acc })
hl('CursorLine', { bg=colors.bg_cur })
hl('CursorLineNr', { bg=colors.bg_cur })
-- hl('Cursor', {  })
hl('Visual', { bg=colors.bg_sel })
hl('Search', { bg = colors.bg_sel })
hl('QuickFixLine', { fg = colors.fg_acc })
hl('Question', { fg = colors.fg_acc })
hl('Title', { bg = colors.bg_blu, fg = colors.fg_blu })
hl('ColorColumn', { bg = colors.bg_acc })

-- Git And Diffs
hl('Added', {  bg = colors.bg_gre, fg = colors.fg_gre  })
hl('DiffText', {  })
hl('Changed', {  bg = colors.bg_yel, fg = colors.fg_yel  })
hl('Removed', { bg = colors.bg_red, fg = colors.fg_red })
hl('DiffAdd', { link = 'Added' })
hl('DiffChange', { link = 'Changed' })
hl('DiffDelete', { link = 'Removed' })

-- Plugins
hl('MiniStatuslineModeNormal', { bg = colors.fg_main, fg = colors.bg_main })

-- Languages
hl('shVariable', {  })
hl('shFunctionKey', {  })
hl('shStatement', {  })
hl('shSet', {  })
hl('shConditional', { link = 'Keyword' })

hl('@constructor.lua', {  })

hl('yamlPlainScalar', { link = 'String' })
hl('dosiniHeader', { bg = colors.bg_blu, fg = colors.fg_blu })
