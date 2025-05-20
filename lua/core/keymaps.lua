vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
vim.keymap.set("n", "<leader>w", "<cmd> w <CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", "<cmd> q <CR>", { desc = "Quit" })

vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Buffers
vim.keymap.set("n", "<leader>b<Tab>", ":bnext<CR>", { desc = "[N]ext" })
vim.keymap.set("n", "<leader>b<S-Tab>", ":bprevious<CR>", { desc = "[P]revious" })
vim.keymap.set("n", "<leader>bc", ":bdelete!<CR>", { desc = "[C]lose" }) -- close buffer
vim.keymap.set("n", "<leader>bb", "<cmd> enew <CR>", { desc = "New [B]uffer" }) -- new buffer

-- Tabs
--vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { desc = "New [T]ab" }) -- open new tab
--vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "[C]lose" }) -- close current tab
--vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "[N]ext" }) --  go to next tab
--vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "[P]revious" }) --  go to previous tab

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
local opts = { buffer = 0 }
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tn", "<cmd>ToggleTerm direction=horizontal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ti", "<cmd>ToggleTerm direction=vertical<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-Left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-Right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-Down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-Up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("v", "<", "<gv", { desc = "Re-select" })
vim.keymap.set("v", ">", ">gv", { desc = "Re-select" })

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
