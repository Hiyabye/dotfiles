return {
  {
    'mason-org/mason.nvim',
    opts = {},
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      ensure_installed = {
        'lua_ls',
        'clangd',
        'pyright',
        'ts_ls',
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, {
              buffer = event.buf,
              desc = desc,
            })
          end

          local builtin = require 'telescope.builtin'

          map('gd', builtin.lsp_definitions, 'Go to definition')
          map('gr', builtin.lsp_references, 'Go to references')
          map('gI', builtin.lsp_implementations, 'Go to implementation')
          map('<leader>D', builtin.lsp_type_definitions, 'Type definition')
          map('<leader>ds', builtin.lsp_document_symbols, 'Document symbols')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map('K', vim.lsp.buf.hover, 'Hover documentation')
        end,
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      vim.lsp.enable {
        'lua_ls',
        'clangd',
        'pyright',
        'ts_ls',
      }
    end,
  },
}