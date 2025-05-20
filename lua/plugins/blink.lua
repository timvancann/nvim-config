local trigger_text = ";"

return {
  {

    "saghen/blink.cmp",
    version = "*",

    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
      "giuxtaposition/blink-cmp-copilot",
      "fang2hou/blink-copilot",
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
          auto_show = false,
          auto_show_delay_ms = 500,
        },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = {
          Copilot = "",
          Text = "󰉿",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓",

          Field = "󰜢",
          Variable = "󰆦",
          Property = "󰖷",

          Class = "󱡠",
          Interface = "󱡠",
          Struct = "󱡠",
          Module = "󰅩",

          Unit = "󰪚",
          Value = "󰦨",
          Enum = "󰦨",
          EnumMember = "󰦨",

          Keyword = "󰻾",
          Constant = "󰏿",

          Snippet = "󱄽",
          Color = "󰏘",
          File = "󰈔",
          Reference = "󰬲",
          Folder = "󰉋",
          Event = "󱐋",
          Operator = "󰪚",
          TypeParameter = "󰬛",
        },
      },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "copilot",
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
        providers = {
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 8,
            min_keyword_length = 2,
            module = "blink.cmp.sources.snippets",
            score_offset = 85, -- the higher the number, the higher the priority
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90, -- show at a higher priority than lsp
            opts = {},
          },
          avante_files = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 100, -- show at a higher priority than lsp
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000, -- show at a higher priority than lsp
            opts = {},
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "saghen/blink.compat",
    lazy = true,
    opts = {},
    config = function()
      -- monkeypatch cmp.ConfirmBehavior for Avante
      require("cmp").ConfirmBehavior = {
        Insert = "insert",
        Replace = "replace",
      }
    end,
  },
}
