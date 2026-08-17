return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({})
    pcall(telescope.load_extension, "fzf")

    vim.keymap.set("n", "<C-e>", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Find text" })
  end,
}
