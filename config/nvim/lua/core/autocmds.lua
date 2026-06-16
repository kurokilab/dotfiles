local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local term = augroup("TermBehaviour", { clear = true })

autocmd("TermOpen", {
  group = term,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

autocmd({ "BufEnter", "TermOpen" }, {
  group = term,
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal: to normal mode" })
