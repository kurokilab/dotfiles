return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
        icons_enabled = true,
      },
      tabline = {
        lualine_a = { { "buffers", mode = 2 } },
        lualine_z = { "tabs" },
      },
    })
  end,
}
