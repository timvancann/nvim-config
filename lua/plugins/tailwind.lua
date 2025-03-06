return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      server = {
        settings = {
          experimental = {
            classRegex = {
              'class\\s*:\\s*"([^"]*)',
            },
          },
        },
      },
      extension = {
        queries = { "rust " },
        patterns = {
          rust = {
            'class: "(.*)"',
          },
        },
      },
    },
  },
}
