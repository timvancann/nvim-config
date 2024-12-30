return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
  opts = {
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      mappings = vim.g.have_nerd_font,
    },

    -- Document existing key chains
    spec = {
      { '<leader>b', group = '[B]uffer' },
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>l', group = '[L]sp' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]ab' },
      { '<leader>w', group = '[W]indow' },
    },
  },
}
