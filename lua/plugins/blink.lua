local trigger_text = ";"

return {

  "saghen/blink.cmp",
  version = "*",

  -- optional: provides snippets for the snippet source
  dependencies = {
    "moyiz/blink-emoji.nvim",
    "L3MON4D3/LuaSnip",
    "giuxtaposition/blink-cmp-copilot",
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
    snippets = {
      preset = "luasnip",
      -- This comes from the luasnip extra, if you don't add it, won't be able to
      -- jump forward or backward in luasnip snippets
      -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "emoji", "copilot" },
      providers = {
        snippets = {
          name = "snippets",
          enabled = true,
          max_items = 8,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 85, -- the higher the number, the higher the priority
          -- Only show snippets if I type the trigger_text characters, so
          -- to expand the "bash" snippet, if the trigger_text is ";" I have to
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            -- NOTE: remember that `trigger_text` is modified at the top of the file
            return before_cursor:match(trigger_text .. "%w*$") ~= nil
          end,
          -- After accepting the completion, delete the trigger_text characters
          -- from the final inserted text
          transform_items = function(_, items)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            if trigger_pos then
              for _, item in ipairs(items) do
                item.textEdit = {
                  newText = item.insertText or item.label,
                  range = {
                    start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
                    ["end"] = { line = vim.fn.line(".") - 1, character = col },
                  },
                }
              end
            end
            -- NOTE: After the transformation, I have to reload the luasnip source
            -- Otherwise really crazy shit happens and I spent way too much time
            -- figurig this out
            vim.schedule(function()
              require("blink.cmp").reload("snippets")
            end)
            return items
          end,
        },
        -- https://github.com/moyiz/blink-emoji.nvim
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          score_offset = 15, -- the higher the number, the higher the priority
          opts = { insert = true }, -- Insert emoji (default) or complete its name
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
      },
    },
  },
  opts_extend = { "sources.default" },
}
