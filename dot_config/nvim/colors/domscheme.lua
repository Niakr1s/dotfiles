-- Clear existing highlights
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

-- Set colorscheme name
vim.g.colors_name = 'domscheme'

-- Define your color palette
local colors = {
  cursor = '#1144ff',
  bg_main = '#fff8f0',
  bg_dim = '#f6ece8',
  bg_alt = '#e7e0da',
  fg_main = '#222222',
  fg_dim = '#63728f',
  fg_alt = '#856f4a',
  bg_active = '#c7c0ba',
  bg_inactive = '#f9f2ef',
  border = '#baafba',

  red = '#cc3333',
  red_warmer = '#dd1100',
  red_cooler = '#c04440',
  red_faint = '#a2403f',
  green = '#217a3c',
  green_warmer = '#4a7d00',
  green_cooler = '#008058',
  green_faint = '#61756c',
  yellow = '#8a5d00',
  yellow_warmer = '#9f4a00',
  yellow_cooler = '#8f5a3a',
  yellow_faint = '#765640',
  blue = '#375cd8',
  blue_warmer = '#4250ef',
  blue_cooler = '#065fff',
  blue_faint = '#6060d0',
  magenta = '#ba35af',
  magenta_warmer = '#cf25aa',
  magenta_cooler = '#6052cf',
  magenta_faint = '#af569f',
  cyan = '#1f6fbf',
  cyan_warmer = '#3f70a0',
  cyan_cooler = '#1f77bb',
  cyan_faint = '#406f90',

  bg_red_intense = '#ff8f88',
  bg_green_intense = '#8adf80',
  bg_yellow_intense = '#fac200',
  bg_blue_intense = '#cbcfff',
  bg_magenta_intense = '#df8fff',
  bg_cyan_intense = '#88c8ff',

  bg_red_subtle = '#ffcfbf',
  bg_green_subtle = '#aff7c5',
  bg_yellow_subtle = '#f9f376',
  bg_blue_subtle = '#cfdff9',
  bg_magenta_subtle = '#f9ddf0',
  bg_cyan_subtle = '#bfeaf0',

  bg_added = '#ccefcf',
  bg_added_faint = '#e0f3e0',
  bg_added_refine = '#bae0c0',
  fg_added = '#005000',

  bg_changed = '#ffe5b9',
  bg_changed_faint = '#ffefc5',
  bg_changed_refine = '#ffd09f',
  fg_changed = '#553d00',

  bg_removed = '#ffd4d8',
  bg_removed_faint = '#ffe3e3',
  bg_removed_refine = '#ffc0ca',
  fg_removed = '#8f1313',

  bg_mode_line_active = '#f8cf8f',
  fg_mode_line_active = '#111133',
  bg_completion = '#fadacf',
  bg_hover = '#b4cfff',
  bg_hover_secondary = '#aaeccf',
  bg_hl_line = '#f9e8c0',
  bg_paren_match = '#afbfef',
  bg_region = '#caeafa',
  bg_err = '#ffdfe6',
  bg_warning = '#ffe5ba',
  bg_info = '#cff5d0',
}

-- Helper function to set highlights
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Basic editor highlights
hl('Normal', { fg = colors.fg_main, bg = colors.bg_main })
hl('Comment', { fg = colors.fg_dim, italic = true })
hl('Keyword', { fg = colors.blue_warmer })
hl('String', { fg = colors.yellow_warmer })
hl('Function', { fg = colors.cyan })
hl('Type', { fg = colors.blue_cooler })
hl('Constant', { fg = colors.blue })
hl('Operator', { fg = colors.fg_main })
hl('Delimiter', { fg = colors.fg_main })
hl('Special', { fg = colors.fg_main })
hl('Identifier', { fg = colors.red_faint })
hl('yamlBlockMappingKey', { link = '@variable' })
hl('MatchParen', { bg = colors.bg_paren_match })
hl('TermCursor', { bg = colors.cursor })
hl('Statement', { link = '@variable' })
hl('@variable', { fg = colors.magenta_cooler })
hl('@property', { fg = colors.cyan })
hl('Error', { bg = colors.red })
hl('Special', { fg = colors.blue_warmer, bold = true })
hl('PreProc', { fg = colors.cyan_warmer })

hl('DiagnosticOk', { fg = colors.green_warmer })
hl('DiagnosticInfo', { fg = colors.green })
hl('DiagnosticWarn', { fg = colors.yellow })
hl('DiagnosticError', { fg = colors.red })
hl('DiagnosticHint', { fg = colors.cyan })

-- Floating Windows
hl('FloatBorder', { bg = colors.bg_dim })
hl('FloatTitle', { fg = colors.fg_main })
hl('DiagnosticFloatingInfo', { fg = colors.cyan })
hl('DiagnosticFloatingHint', { fg = colors.blue_warmer })
hl('NormalFloat', { bg = colors.bg_dim })
hl('Pmenu' , { bg = colors.bg_completion })

-- Bars and Lines
hl('Statusline', {bg = colors.bg_mode_line_active})
hl('StatusLineNC', {bg = colors.bg_mode_line_inactive})
hl('TabLine', {bg = colors.bg_dim})
hl('TabLineSel', {bg = colors.bg_mode_line_active, bold = true})

-- UI elements
hl('LineNr', { bg = colors.bg_dim, fg = colors.fg_dim })
hl('Directory', { fg = colors.fg_main })
hl('MoreMsg', { fg = colors.fg_main })
hl('CursorLine', { bg = colors.bg_hl_line })
hl('CursorLineNr', { bg = colors.bg_hl_line, fg = colors.blue_warmer, bold = true })
hl('Cursor', { bg = colors.cursor })
hl('Visual', { bg = colors.bg_region })
hl('Search', { bg = colors.bg_warning, fg = fg_main })
hl('QuickFixLine', { fg = colors.cyan })
hl('Question', { fg = colors.cyan })
hl('Title', { fg = colors.fg_main })

-- Git And Diffs
hl('DiffAdd', { bg = colors.bg_added })
hl('Added', { bg = colors.bg_added })
hl('DiffText', { bg = colors.bg_changed })
hl('Changed', { bg = colors.bg_changed })
hl('Removed', { bg = colors.bg_removed })

-- Plugins
hl('MiniStatuslineModeNormal', { bg = colors.cursor, fg = colors.bg_main })

-- Languages
hl('shVariable', { link = '@variable'})
hl('shFunctionKey', { link = 'Normal'})
hl('shStatement', { link = 'Normal'})
hl('shSet', { link = 'Normal'})
hl('shConditional', { fg = colors.cyan, bold = true })

hl('@constructor.lua', { fg = colors.cyan })
