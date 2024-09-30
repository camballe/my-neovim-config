return {
  -- Mason for managing LSP servers, linters, and formatters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "typescript-language-server",
        "tailwindcss-language-server",
        "css-lsp",
        "json-lsp",
        "html-lsp",
        "bash-language-server",
        "yaml-language-server",
      },
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Global settings for all LSP servers
      inlay_hints = { enabled = false }, -- Disabled globally to avoid errors

      ---@type lspconfig.options
      servers = {
        -- Lua LS with some useful settings
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Both" },
              hint = {
                enable = true,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
              },
              diagnostics = {
                globals = { "vim" }, -- Avoid warning for vim global
              },
            },
          },
        },
        -- TypeScript and JavaScript setup
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = true,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
          },
        },
        -- CSS and Tailwind LSP
        cssls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        -- HTML LSP
        html = {},
        -- JSON LSP
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        -- Bash and shell script LSP
        bashls = {},
        -- YAML LSP
        yamlls = {
          settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas(),
              validate = true,
            },
          },
        },
      },

      -- Customize how the LSP server attaches to buffers

      -- Customize how the LSP server attaches to buffers
      on_attach = function(client, bufnr)
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end
        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Key mappings for LSP functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)

        -- Enable inlay hints conditionally (only for TypeScript and Lua)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint(bufnr, true)
        end

        -- Autoformatting for Prisma files on save
        if client.name == "prismals" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,

      -- Automatically configure additional LSP servers
      setup = {
        lua_ls = function(_, opts)
          require("lspconfig").lua_ls.setup(opts)
        end,
        tsserver = function(_, opts)
          require("lspconfig").tsserver.setup(opts)
        end,
        -- Add more setup for other language servers as needed
      },
    },
  },

  -- Autocompletion using nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip", -- Snippet engine
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "saadparwaiz1/cmp_luasnip", -- Snippet completions
      "hrsh7th/cmp-path", -- Path completions
      "hrsh7th/cmp-buffer", -- Buffer completions
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }
      opts.sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }
      return opts
    end,
  },

  -- LSP progress notifications (optional)
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },

  -- Prisma plugin for syntax highlighting
  {
    "prisma/vim-prisma",
    ft = "prisma", -- Load only for .prisma files
  },

  -- Add the Prisma language server to Mason and LSP
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prisma-language-server", -- Ensure the Prisma LSP is installed
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Add prisma language server
        prismals = {
          settings = {
            prisma = {
              prismaFmtOnSave = true, -- Auto-format on save
            },
          },
        },
      },
    },
  },
}
