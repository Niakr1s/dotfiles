vim.filetype.add({
  filename = {
    ['inventory'] = 'dosini',
  },
})

local keymap = vim.keymap.set

vim.pack.add({
  'https://github.com/folke/snacks.nvim',
  'https://github.com/domsch1988/mattern.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/Mofiqul/dracula.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
})

vim.cmd.colorscheme("catppuccin")


require 'nvim-treesitter.config'.setup {
  ensure_installed = { "lua", "vim", "vimdoc", "yaml" },
}

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    bash = {"beautysh"},
    sh = {"beautysh"},
    yaml = { "ansible-lint" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    -- rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

require('render-markdown').setup()
require('flash').setup()

keymap({ "n", "x", "o" }, "<Return>", function() require("flash").jump() end, { desc = "Flash" })
keymap({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
keymap("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
keymap({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

require('snacks').setup({
  input = { enabled = true },
  statuscolumn = { enabled = true },
  lazygit = { enabled = true },
  quickfile = { enabled = true },
  toggle = { enabled = true },
})

-- Snacks pickers
keymap("n", "<leader>E", function() require('snacks').picker.explorer() end, { desc = "Explorer" })
-- keymap("n", "<leader>ff", function() require('snacks').picker.files() end, { desc = "Files" })
-- keymap("n", "<leader>fc", function() require('snacks').picker.colorschemes() end, { desc = "Colorschemes" })
-- keymap("n", "<leader>fg", function() require('snacks').picker.grep() end, { desc = "Grep" })
-- keymap("n", "<leader>fh", function() require('snacks').picker.help() end, { desc = "Help" })
-- keymap("n", "<leader>fH", function() require('snacks').picker.highlights() end, { desc = "Highlight Groups" })
keymap("n", "<leader>fp", function() require('snacks').picker.projects() end, { desc = "Projects" })
keymap("n", "<leader>fr", function() require('snacks').picker.recent() end, { desc = "Recent Files" })
keymap("n", "<leader>F", function() require('snacks').picker.resume() end, { desc = "Resume last Search" })
-- keymap("n", "<C-P>", function() require('snacks').picker.command_history() end, { desc = "Lines" })
-- keymap("n", ",", function() require('snacks').picker.lines() end, { desc = "Lines" })

keymap("n", "<leader>gb", function() require('snacks').picker.git_branches() end, { desc = "Git Branches" })
-- keymap("n", "<leader>gl", function() require('snacks').picker.git_log() end, { desc = "Git Log" })
keymap("n", "<leader>gf", function() require('snacks').picker.git_log_file() end, { desc = "Git Log File" })
keymap("n", "<leader>gs", function() require('snacks').picker.git_log_line() end, { desc = "Git Log Line" })
keymap("n", "<leader>gL", function() require('snacks').git.blame_line() end, { desc = "Git Blame Line" })

-- keymap("n", "<leader><space>", function() require('snacks').picker.buffers() end, { desc = "Smart Picker" })
keymap("n", "<leader>bd", function() require('snacks').bufdelete() end, { desc = 'Close Buffer' })
keymap("n", "<leader>bq", function() require('snacks').bufdelete.other() end, { desc = 'Close Other Buffers' })
keymap("n", "<leader>gg", function() require('snacks').lazygit() end, { desc = "Lazygit" })

-- Snacks.toggle.line_number():map("<leader>ul")
-- Snacks.toggle.dim():map("<leader>ud")
-- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")


-- Disable completion in Snacks Picker
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function()
    vim.b.minicompletion_disable = true
  end,
})

require('mattern').setup({
  markers = {
    { { "base_pw" }, "base_pw is deprecated, use root_pw instead!", "MiniHipatternsNote", "yaml" },
    {
      {
        "version_string",
        "evd_stereo",
        "start_acs",
        "copy_script_config",
        "asgard_logging_path",
        "evd_logging_path",
      },
      "This Variable is potentially unused",
      "MiniHipatternsFixme",
      "yaml"
    },
    {
      {
        "asgard_backup_path",
        "evd_backup_path"
      },
      "Rollout New Backup (Debian >= 11!)",
      "MiniHipatternsNote",
      "yaml"
    }
  }
})
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    require("mattern").mattern_print()
  end
})
vim.api.nvim_create_autocmd("BufWrite", {
  callback = function()
    require("mattern").update()
  end
})
