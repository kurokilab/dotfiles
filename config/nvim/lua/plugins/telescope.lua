return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf")
  end,
}
