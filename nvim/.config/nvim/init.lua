vim.opt.number = true
vim.opt.title = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.history = 200
vim.opt.tabstop = 2 -- treat tab as two spaces
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 10
vim.opt.smartindent = true
vim.opt.cmdheight = 1
vim.opt.inccommand = "nosplit"
vim.opt.ignorecase = true
vim.opt.nrformats = "" -- treat all numerals as decimal
vim.opt.wrap = false
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = ""

-- key mappings
local keymap = vim.keymap
local options = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")
-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G") -- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", options)
keymap.set("n", "<s-tab>", ":tabprev<Return>", options)
-- Split window
keymap.set("n", "ss", ":split<Return>", options)
keymap.set("n", "sv", ":vsplit<Return>", options)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")


-- plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
require("lazy").setup({
  "shaunsingh/nord.nvim",
  "tpope/vim-commentary"
})

vim.g.nord_italic = false
vim.g.nord_bold = false
vim.cmd[[colorscheme nord]]
