return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format {
            async = true,
            lsp_format = "fallback",
          }
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function()
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang_format" },
        c = { "clang_format" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
        "pyright",
        "ts_ls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
              buffer = event.buf,
              desc = desc,
            })
          end

          local builtin = require "telescope.builtin"

          map("gd", builtin.lsp_definitions, "Go to definition")
          map("gr", builtin.lsp_references, "Go to references")
          map("gI", builtin.lsp_implementations, "Go to implementation")
          map("<leader>D", builtin.lsp_type_definitions, "Type definition")
          map("<leader>ds", builtin.lsp_document_symbols, "Document symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("K", vim.lsp.buf.hover, "Hover documentation")
        end,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.lsp.enable {
        "lua_ls",
        "clangd",
        "pyright",
        "ts_ls",
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "python",
        "javascript",
        "typescript",
        "json",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  { import = "plugins.custom" },
}
