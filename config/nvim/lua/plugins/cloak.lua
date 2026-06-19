return {
  "laytan/cloak.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    enabled = true,
    cloak_character = "*",
    patterns = {
      {
        file_pattern = ".env*",
        cloak_pattern = "=.+",
      },
    },
  },
}
