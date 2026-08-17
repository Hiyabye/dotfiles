local map = vim.keymap.set

-- File operations
map({ "n", "i", "v" }, "<C-s>", "<Esc><Cmd>write<CR>", { desc = "Save file" })
map({ "n", "i", "v" }, "<C-q>", "<Esc><Cmd>quit<CR>", { desc = "Quit" })

-- System clipboard
map("v", "<C-c>", '"+y', { desc = "Copy selection" })
map("v", "<C-x>", '"+x', { desc = "Cut selection" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste clipboard" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste clipboard" })
map({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Undo and redo
map({ "n", "i", "v" }, "<C-z>", "<Cmd>undo<CR>", { desc = "Undo" })
map({ "n", "i", "v" }, "<C-y>", "<Cmd>redo<CR>", { desc = "Redo" })

-- Tabs (keep Ctrl-W available for native window commands)
map("n", "<C-t>", "<Cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<C-F4>", "<Cmd>tabclose<CR>", { desc = "Close tab" })
