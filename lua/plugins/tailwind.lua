return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
    },
    opts = {
      settings = {
        includeLanguages = {
          rust = "html",
        },
      },
      extension = {
        queries = {
          "rust",
        }, -- a list of filetypes having custom `class` queries
        patterns = { -- a map of filetypes to Lua pattern lists
          -- example:
          rust = {
            "class: [\"'](.*)[\"']",
            "className: [\"'](.*)[\"']",
            'class: "\\s*(.*)',
            'className: "\\s*(.*)',
          },
          -- javascript = { "clsx%(([^)]+)%)" },
        },
      },
    }, -- your configuration
  },
}
