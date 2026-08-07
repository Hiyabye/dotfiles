return {
  -- Language servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = { vim.env.VIMRUNTIME } },
          },
        },
      })

      vim.lsp.enable({
        "lua_ls",
        "clangd",
        "pyright",
        "rust_analyzer",
        "ts_ls",
      })
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSModuleInfo" },
    config = function()
      require("nvim-treesitter").setup()
      -- This version has no `ensure_installed`; install parsers explicitly.
      require("nvim-treesitter").install({
        "c", "cpp", "python", "bash", "lua", "typescript", "rust",
        "json", "yaml", "markdown",
      })
    end,
  },

  -- Autocompletion (Tab also accepts Copilot's inline suggestion)
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_menu_open() then
              return cmp.accept()
            end
            local suggestion = require("copilot.suggestion")
            if suggestion.is_visible() then
              suggestion.accept()
              return true
            end
            return false
          end,
          "fallback",
        },
        ["<S-Tab>"] = { "fallback" },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      signature = { enabled = true },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>p", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
    },
  },

  -- Format on save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        typescript = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
      },
    },
  },

  { import = "plugins.custom" },
}
