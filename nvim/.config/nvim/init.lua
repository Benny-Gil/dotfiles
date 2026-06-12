-- ~/.config/nvim/init.lua — minimal, dependency-free Neovim config.
-- Sane defaults that work the same on macOS and Linux. No plugin manager
-- required; add one later if you want.

local opt = vim.opt
local g = vim.g

-- Leader keys (set before any mappings)
g.mapleader = " "
g.maplocalleader = " "

-- General
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"   -- use system clipboard
opt.undofile = true             -- persistent undo
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 6
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Indentation (2-space default, smart)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true

-- Completion / wildmenu
opt.completeopt = { "menuone", "noselect" }
opt.wildmode = "longest:full,full"

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer (netrw)" })
-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
-- Move selected lines
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  -- vim.hl replaced vim.highlight in nvim 0.11; keep compat with older versions
  callback = function() (vim.hl or vim.highlight).on_yank({ timeout = 150 }) end,
})

-- netrw as a lightweight file tree
g.netrw_banner = 0
g.netrw_liststyle = 3
