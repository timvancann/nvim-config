return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd.colorscheme 'tokyonight-night'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
    -- vim.cmd [[
    --   highlight Normal guibg=none
    --   highlight NonText guibg=none
    --   highlight Normal ctermbg=none
    --   highlight NonText ctermbg=none
    -- ]]
  end,
}
