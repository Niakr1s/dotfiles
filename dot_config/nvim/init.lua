vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim'
})

vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = false
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.scrolloff = 30
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.updatetime = 1000
vim.opt.iskeyword:append("-")
vim.o.spelllang = "de,en"
vim.o.spelloptions = "camel"
vim.opt.complete:append("kspell")
vim.o.path = vim.o.path .. ",**"
vim.o.tags = vim.o.tags .. ",/home/dosa/.config/nvim/tags"
vim.o.pumborder = "rounded"
vim.o.foldlevel = 10

-- don't save blank buffers to sessions (like neo-tree, trouble etc.)
vim.opt.sessionoptions:remove('blank')

vim.cmd.colorscheme("catppuccin")
-- vim.cmd("set background=light")
-- vim.cmd.highligh('Normal guibg=none')

require("mini.colors").setup()
require("mini.align").setup()

require("mini.basics").setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = "bold",
  },
  mappings = {
    basic = true,
    windows = true,
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = true,
  },
})

require("mini.bracketed").setup()
require("mini.bufremove").setup()

require("mini.clue").setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    { mode = "n", keys = "\\" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Surround
    { mode = "n", keys = "s" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    { mode = "n", keys = "<Leader>b", desc = " Buffer" },
    { mode = "n", keys = "<Leader>f", desc = " Find" },
    { mode = "n", keys = "<Leader>g", desc = "󰊢 Git" },
    { mode = "n", keys = "<Leader>i", desc = "󰏪 Insert" },
    { mode = "n", keys = "<Leader>l", desc = "󰘦 LSP" },
    { mode = "n", keys = "<Leader>m", desc = " Mini" },
    { mode = "n", keys = "<Leader>q", desc = " NVim" },
    { mode = "n", keys = "<Leader>r", desc = "Replace" },
    { mode = "n", keys = "<Leader>s", desc = "󰆓 Session" },
    { mode = "n", keys = "<Leader>s", desc = " Terminal" },
    { mode = "n", keys = "<Leader>u", desc = "󰔃 UI" },
    { mode = "n", keys = "<Leader>w", desc = " Window" },
    require("mini.clue").gen_clues.g(),
    require("mini.clue").gen_clues.builtin_completion(),
    require("mini.clue").gen_clues.marks(),
    require("mini.clue").gen_clues.registers(),
    require("mini.clue").gen_clues.windows(),
    require("mini.clue").gen_clues.z(),
  },
  window = {
    delay = 300,
  },
})

require('mini.colors').setup()
require("mini.comment").setup()

local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base)
  return MiniCompletion.default_process_items(items, base, process_items_opts)
end

require("mini.completion").setup({
  mappings = {
    go_in = "<RET>",
  },
  window = {
    info = { border = "solid" },
    signature = { border = "solid" },
  },
})

require("mini.cursorword").setup()
-- vim.api.nvim_set_hl(0, "MiniCursorword", { underline = true })
-- vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = NONE })

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "█", change = "▒", delete = "" },
  },
})

require("mini.doc").setup()
require("mini.extra").setup()

require("mini.files").setup({
  mappings = {
    close = '<ESC>',
  },
  windows = {
    preview = true,
    border = "rounded",
    width_preview = 80,
  },
})

require("mini.fuzzy").setup()
require("mini.git").setup()

local hipatterns = require("mini.hipatterns")

local censor_extmark_opts = function(_, match, _)
  local mask = string.rep("*", vim.fn.strchars(match))
  return {
    virt_text = { { mask, "CursorLine" } },
    virt_text_pos = "overlay",
    priority = 200,
    right_gravity = false,
  }
end

-- This is a custom "hide my password" solution
-- Add patterns to match below
-- toggle with <leader>up
local password_table = {
  pattern = {
    "password: ()%S+()",
    "password_usr: ()%S+()",
    "_pw: ()%S+()",
    "password_asgard_read: ()%S+()",
    "password_elara_admin: ()%S+()",
    "gpg_pass: ()%S+()",
    "passwd: ()%S+()",
    "secret: ()%S+()",
  },
  group = "",
  extmark_opts = censor_extmark_opts,
}

hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

    -- Cloaking Passwords
    pw = password_table,

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

vim.keymap.set("n", "<leader>up", function()
  if next(hipatterns.config.highlighters.pw) == nil then
    hipatterns.config.highlighters.pw = password_table
  else
    hipatterns.config.highlighters.pw = {}
  end
  vim.cmd("edit")
end, { desc = "Toggle Password Cloaking" })

require("mini.icons").setup()

require("mini.indentscope").setup({
  draw = {
    animation = function()
      return 1
    end,
  },
  symbol = "│",
})

require("mini.jump").setup()
require("mini.jump2d").setup()

require("mini.keymap").setup()
local map_combo = require('mini.keymap').map_combo

-- Support most common modes. This can also contain 't', but would
-- only mean to press `<Esc>` inside terminal.
local mode = { 'i', 'c', 'x', 's' }
map_combo(mode, 'jk', '<BS><BS><Esc>')

-- To not have to worry about the order of keys, also map "kj"
map_combo(mode, 'kj', '<BS><BS><Esc>')

local map_multistep = require('mini.keymap').map_multistep

map_multistep('i', '<Tab>', { 'pmenu_next' })
map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
map_multistep('i', '<BS>', { 'minipairs_bs' })

require("mini.map").setup()
require("mini.misc").setup()

require("mini.move").setup({
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = '<M-C-h>',
    right = '<M-C-l>',
    down = '<M-C-j>',
    up = '<M-C-k>',

    -- Move current line in Normal mode
    line_left = '<M-C-h>',
    line_right = '<M-C-l>',
    line_down = '<M-C-j>',
    line_up = '<M-C-k>',
  },
}
)


-- We took this from echasnovski's personal configuration
-- https://github.com/echasnovski/nvim/blob/master/init.lua

local filterout_lua_diagnosing = function(notif_arr)
  local not_diagnosing = function(notif)
    return not vim.startswith(notif.msg, "lua_ls: Diagnosing")
  end
  notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
  return MiniNotify.default_sort(notif_arr)
end
require("mini.notify").setup({
  content = { sort = filterout_lua_diagnosing },
  window = { config = { border = "solid" } },
})
vim.notify = MiniNotify.make_notify()

require("mini.operators").setup()

-- require("mini.pairs").setup()

local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.4 * vim.o.columns)
  return {
    anchor = "NW",
    height = height,
    width = width,
    border = "rounded",
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end
require("mini.pick").setup({
  mappings = {
    choose_in_vsplit = "<C-V>",
  },
  options = {
    use_cache = true,
  },
  window = {
    config = win_config,
  },
})
vim.ui.select = MiniPick.ui_select

require("mini.sessions").setup({ autowrite = true, })
require("mini.splitjoin").setup()

local latex_patterns = { 'latex/**/*.json', '**/latex.json' }
local lang_patterns = {
  tex = latex_patterns,
  plaintex = latex_patterns,
  -- Recognize special injected language of markdown tree-sitter parser
  markdown_inline = { 'markdown.json' },
}
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),
    gen_loader.from_lang({ lang_patterns = lang_patterns }),
  },
})
MiniSnippets.start_lsp_server()

Mvim_starter_custom = function()
  return {
    { name = "Recent Files", action = function() require("mini.extra").pickers.oldfiles() end, section = "Search" },
    { name = "Session",      action = function() require("mini.sessions").select() end,        section = "Search" },
  }
end

require("mini.starter").setup({
  autoopen = false,
  items = {
    -- require("mini.starter").sections.builtin_actions(),
    Mvim_starter_custom(),
    require("mini.starter").sections.recent_files(5, false, false),
    require("mini.starter").sections.recent_files(5, true, false),
    require("mini.starter").sections.sessions(5, true),
  },
  header = function()
    local v = vim.version()
    local versionstring = string.format("  Neovim Version: %d.%d.%d", v.major, v.minor, v.patch)
    local image = [[
┌─────────────────────────────────────────┐
│                                         │
│    ███╗   ███╗██╗   ██╗██╗███╗   ███╗   │
│    ████╗ ████║██║   ██║██║████╗ ████║   │
│    ██╔████╔██║██║   ██║██║██╔████╔██║   │
│    ██║╚██╔╝██║╚██╗ ██╔╝██║██║╚██╔╝██║   │
│    ██║ ╚═╝ ██║ ╚████╔╝ ██║██║ ╚═╝ ██║   │
│    ╚═╝     ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   │
└─────────────────────────────────────────┘
]]
    finalimage = image .. versionstring
    return finalimage
  end
})


require("mini.statusline").setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<',         -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',         -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end,
    inactive = nil,
  },
})

require("mini.surround").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require("mini.visits").setup()

require("autocmds")
require("filetypes")
require("highlights")
require("keybinds")
require("lsp")

-- If you want to add additional personal Plugins
-- add lua/personal.lua as a file and configure what ever you need
local path_modules = vim.fn.stdpath("config") .. "/lua/"
if vim.uv.fs_stat(path_modules .. "personal.lua") then require("personal") end
