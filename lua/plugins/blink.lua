return {
  "saghen/blink.cmp",
  version = "*",

  -- optional: provides snippets for the snippet source
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    signature = {
      window = {
        border = "single",
      },
      enabled = true,
    },

    completion = {
      ghost_text = { enabled = true },
      menu = {
        max_height = 15,
        min_width = 25,
        border = "single",

        draw = {
          treesitter = { "lsp" },
          padding = 1,
          gap = 1,
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", gap = 1, "kind" },
          },
        },
      },
      documentation = {
        window = {
          border = "single",
        },
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
