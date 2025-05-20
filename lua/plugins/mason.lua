return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim" },
      { "saghen/blink.cmp" },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      require("mason-lspconfig").setup({
        automatic_installation = true,

        ensure_installed = {
          "eslint",
          "lua_ls",
          "ruff",
          "tailwindcss",
          "ts_ls",
          "svelte",
          "basedpyright",
        },
      })
    end,
  },
}
