vim.g.mapleader = " "

vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = "clip.exe",
    ["*"] = "clip.exe",
  },
  paste = {
    ["+"] = function()
      return vim.fn.systemlist("powershell.exe -Command 'Get-Clipboard' | sed 's/\r//g'")
    end,
    ["*"] = function()
      return vim.fn.systemlist("powershell.exe -Command 'Get-Clipboard' | sed 's/\r//g'")
    end,
  },
  cache_enabled = 0,
}

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

vim.opt.formatoptions:append({ "r" })

-- Automatically convert CRLF to LF when pasting
vim.cmd([[
  autocmd TextYankPost * if v:event.operator ==# 'y' | set ff=unix | endif
  autocmd BufReadPost,BufWritePre * setlocal ff=unix
]])
