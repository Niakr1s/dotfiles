-- Automatically close terminal Buffers when their Process is done
-- vim.api.nvim_create_autocmd("TermClose", {
--     callback = function()
--         vim.cmd("bdelete")
--     end
-- })

-- Disable Linenumbers in Terminals
vim.api.nvim_create_autocmd("TermEnter", {
  callback = function()
    vim.o.number = false
    vim.o.relativenumber = false
  end
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- Automatically Split help Buffers to the right
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L"
})

-- Ask for Session Restore on opening without any Files
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      if vim.fn.argc() == 0 and vim.fn.expand("%") == "" then
        require('mini.sessions').select()
      end
    end)
  end
})

-- Navigate the Quickfix List
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set('n', '<C-j>', '<cmd>cn<CR>zz<cmd>wincmd p<CR>', opts)
    vim.keymap.set('n', '<C-k>', '<cmd>cN<CR>zz<cmd>wincmd p<CR>', opts)
  end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "active_cursorline",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Fold on Markdown Headings
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('markdown.fold', {}),
    pattern = 'markdown',
    callback = function()
        -- sets local folding options for markdown
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
})
