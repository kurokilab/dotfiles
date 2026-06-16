local opt = vim.opt

vim.cmd("syntax on")
opt.encoding = "utf-8"

opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true

opt.number = true
opt.wildmode = { "longest", "list" }
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ttyfast = true
opt.conceallevel = 2

-- keep swap files in one dedicated dir instead of next to edited files.
-- trailing "//" makes nvim encode the full path into the swap name to
-- avoid collisions; ensure the dir exists so writes never fail silently.
local swapdir = vim.fn.stdpath("state") .. "/swap//"
vim.fn.mkdir(vim.fn.stdpath("state") .. "/swap", "p")
opt.swapfile = true
opt.directory = swapdir

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function transparent_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TransparentBg", { clear = true }),
  callback = transparent_bg,
})
vim.cmd.colorscheme("habamax")
