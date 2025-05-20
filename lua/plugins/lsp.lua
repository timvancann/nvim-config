return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      { "saghen/blink.cmp" },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("<leader>ld", require("telescope.builtin").lsp_definitions, "[D]efinition")
          map("<leader>lr", require("telescope.builtin").lsp_references, "[R]eferences")
          map("<leader>lh", vim.diagnostic.open_float, "Diagnostic [H]over")
          map("<leader>lI", require("telescope.builtin").lsp_implementations, "[I]mplementation")
          map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[S]ymbols")
          map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")
          map("<leader>lR", vim.lsp.buf.rename, "[R]ename")
          map("<leader>lc", vim.lsp.buf.code_action, "[C]ode Action", { "n", "x" })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>lt", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay Hints")
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config({ signs = { text = diagnostic_signs } })
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      local servers = {
        ts_ls = {},
        zls = {},
        svelte = {},

        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "workspace",
              },
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        ruff = {},
        prettier = {},
        --tailwindcss = {
        --  {
        --    filetypes = {
        --      "aspnetcorerazor",
        --      "astro",
        --      "astro-markdown",
        --      "blade",
        --      "clojure",
        --      "django-html",
        --      "htmldjango",
        --      "edge",
        --      "eelixir",
        --      "elixir",
        --      "ejs",
        --      "erb",
        --      "eruby",
        --      "gohtml",
        --      "gohtmltmpl",
        --      "haml",
        --      "handlebars",
        --      "hbs",
        --      "html",
        --      "htmlangular",
        --      "html-eex",
        --      "heex",
        --      "jade",
        --      "leaf",
        --      "liquid",
        --      "markdown",
        --      "mdx",
        --      "mustache",
        --      "njk",
        --      "nunjucks",
        --      "php",
        --      "razor",
        --      "slim",
        --      "twig",
        --      "css",
        --      "less",
        --      "postcss",
        --      "sass",
        --      "scss",
        --      "stylus",
        --      "sugarss",
        --      "javascript",
        --      "javascriptreact",
        --      "reason",
        --      "rescript",
        --      "typescript",
        --      "typescriptreact",
        --      "vue",
        --      "svelte",
        --      "templ",
        --      "rust",
        --    },

        --    tailwindCSS = {
        --      classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
        --      includeLanguages = {
        --        eelixir = "html-eex",
        --        eruby = "erb",
        --        htmlangular = "html",
        --        templ = "html",
        --        rust = "html",
        --      },
        --      experimental = {
        --        classRegex = { 'class: "(.*)"' },
        --      },
        --      lint = {
        --        cssConflict = "warning",
        --        invalidApply = "error",
        --        invalidConfigPath = "error",
        --        invalidScreen = "error",
        --        invalidTailwindDirective = "error",
        --        invalidVariant = "error",
        --        recommendedVariantOrder = "warning",
        --      },
        --      validate = true,
        --    },
        --  },
        --},
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
    end,
  },
}
