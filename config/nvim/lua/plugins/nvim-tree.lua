return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    { "<leader>r", "<cmd>NvimTreeFocus<CR>", desc = "Focus file tree" },
  },
  config = function()
    require("nvim-tree").setup({
      view = { width = 30 },
      renderer = {
        group_empty = true,
        icons = { show = { folder = true, file = true } },
      },
      filters = { dotfiles = false },
      git = { enable = true },
    })

    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local tree_wins = {}
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.bo[buf].filetype == "NvimTree" then
            table.insert(tree_wins, w)
          end
        end
        if #vim.api.nvim_list_wins() == (#tree_wins + 1) then
          for _, w in ipairs(tree_wins) do
            vim.api.nvim_win_close(w, true)
          end
        end
      end,
    })
  end,
}
