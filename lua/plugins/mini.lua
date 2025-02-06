return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    local spec_treesitter = require("mini.ai").gen_spec.treesitter
    require("mini.ai").setup({
      n_lines = 500,
      custom_textobjects = {
        a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
        f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
        F = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
        o = spec_treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
      },
    })
    require("mini.icons").setup()
    require("mini.bracketed").setup()
    require("mini.pairs").setup()
    require("mini.files").setup({
      vim.keymap.set("n", "-", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
        MiniFiles.reveal_cwd()
      end, { desc = "Open parent directory" }),
    })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - []urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require("mini.statusline")
    -- set use_icons to true if you have a Nerd Font
    statusline.setup({ use_icons = vim.g.have_nerd_font })

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return "%2l:%-2v"
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
