local map = vim.keymap.set

map("v", "<C-A-c>", '"+y', { desc = "Yank to system clipboard" })
map("n", "<C-A-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-A-v>", '<Esc>"+pa', { desc = "Paste from system clipboard" })

local function open_terminal_below()
  vim.cmd("botright 14split")
  vim.cmd("terminal")
end
map("n", "<leader>t", open_terminal_below, { desc = "Open terminal below" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>b", "<cmd>split<CR>", { desc = "Horizontal split" })

map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

map("n", "<S-Up>", "<cmd>resize +3<CR>", { desc = "Resize +" })
map("n", "<S-Down>", "<cmd>resize -3<CR>", { desc = "Resize -" })
map("n", "<S-Right>", "<cmd>vertical resize +5<CR>", { desc = "Vresize +" })
map("n", "<S-Left>", "<cmd>vertical resize -5<CR>", { desc = "Vresize -" })
