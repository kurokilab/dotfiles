return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end
    vim.lsp.config("*", { capabilities = capabilities })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
      callback = function(ev)
        local function bmap(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
        end
        bmap("K", vim.lsp.buf.hover, "Hover")
        bmap("gd", vim.lsp.buf.definition, "Definition")
        bmap("gr", vim.lsp.buf.references, "References")
        bmap("gi", vim.lsp.buf.implementation, "Implementation")
        bmap("<leader>rn", vim.lsp.buf.rename, "Rename")
        bmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
        bmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        bmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
      end,
    })

    local servers = {
      gopls = "gopls",
      clangd = "clangd",
      pyright = "pyright-langserver",
    }
    for server, bin in pairs(servers) do
      if vim.fn.executable(bin) == 1 then
        vim.lsp.enable(server)
      end
    end
  end,
}
