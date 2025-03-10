return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      vim.keymap.set("n", "<leader>\\", ":NvimTreeClose<CR>", { silent = true }),
      vim.keymap.set("n", "\\", function()
        local current_win = vim.api.nvim_get_current_win()
        vim.cmd("NvimTreeFindFile")
        vim.api.nvim_set_current_win(current_win)
      end, { silent = true }),
    })
  end,
}
