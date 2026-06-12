return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },
    config = function()
      local telescope = require "telescope"
      local builtin = require "telescope.builtin"

      telescope.setup {}

      pcall(telescope.load_extension, "fzf")

      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search grep" })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {},
  },
}
