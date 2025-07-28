vim.o.number = true
vim.o.title = true
vim.o.smartindent = true
vim.o.smarttab = true
-- treat tab as two spaces
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.history = 200
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.clipboard = "unnamedplus"
vim.o.scrolloff = 10
vim.o.smartindent = true
vim.o.inccommand = "nosplit"
vim.o.ignorecase = true
vim.o.list = true
vim.o.listchars = "eol:↲,tab:→ ,trail:·,nbsp::,space:·,extends:›,precedes:‹"
vim.o.path = vim.o.path .. ",**"
vim.o.wildignore = vim.o.wildignore .. ",*/node_modules/*"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.foldenable = true
vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
vim.o.foldcolumn = "1"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.winborder = "single"
vim.wo.relativenumber = true

vim.o.mouse = "a"

-- Key mappings
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " "

local function map(mode, l, r, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true
  vim.keymap.set(mode, l, r, opts)
end

map("n", "x", '"_x')
-- Select all
map("n", "<C-a>", "gg<S-v>G")
-- Select last pasted text
map("n", "gp", "`[v`]")

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
      vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "gbprod/nord.nvim",
      cond = not vim.g.vscode,
      opts = {},
      init = function()
        vim.g.nord_italic = false
        vim.g.nord_bold = false
        vim.cmd.colorscheme("nord")
      end,
    },
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      opts = {},
    },
    {
      "stevearc/oil.nvim",
      cond = not vim.g.vscode,
      opts = {
        view_options = { show_hidden = true },
        float = {
          max_width = 80,
          max_height = 80,
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
      },
      init = function()
        map("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
      end,
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "lewis6991/gitsigns.nvim",
      cond = not vim.g.vscode,
      opts = {
        current_line_blame_opts = { delay = 100 },
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk)
          map("n", "<leader>hr", gitsigns.reset_hunk)
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>hS", gitsigns.stage_buffer)
          map("n", "<leader>hR", gitsigns.reset_buffer)
          map("n", "<leader>hp", gitsigns.preview_hunk)
          map("n", "<leader>hi", gitsigns.preview_hunk_inline)
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end)
          map("n", "<leader>hd", gitsigns.diffthis)
          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end)

          --
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      cond = not vim.g.vscode,
      main = "nvim-treesitter.configs",
      opts = {
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      },
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
      cond = not vim.g.vscode,
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = { "nvim-lua/plenary.nvim" },
      cond = not vim.g.vscode,
      config = function()
        local builtin = require("telescope.builtin")
        local function run_in_git_root(fn)
          return function()
            local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
            if vim.v.shell_error == 0 then
              fn({ cwd = root })
            else
              fn()
            end
          end
        end
        map("n", "<leader>ff", run_in_git_root(builtin.find_files))
        map("n", "<leader>fg", run_in_git_root(builtin.live_grep))
        map("n", "<leader>fb", run_in_git_root(builtin.buffers))
        map("n", "<leader>fh", run_in_git_root(builtin.help_tags))
        map("n", "<leader>fx", run_in_git_root(builtin.resume))
      end,
    },
    {
      "folke/lazydev.nvim",
      cond = not vim.g.vscode,
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "saghen/blink.cmp",
      cond = not vim.g.vscode,
      -- optional: provides snippets for the snippet source
      dependencies = { "rafamadriz/friendly-snippets" },

      -- use a release tag to download pre-built binaries
      version = "1.*",
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = "super-tab" },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono",
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = true } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },

        signature = { enabled = true },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        {
          "mason-org/mason-lspconfig.nvim",
          opts = {
            ensure_installed = {
              "lua_ls",
              "clangd",
              "vtsls",
              "pyright",
              "cssls",
              "typos_lsp",
            },
          },
        },
      },
    },
    {

      "nvimdev/lspsaga.nvim",
      cond = not vim.g.vscode,
      event = "LspAttach",
      opts = {
        code_action = {
          extend_gitsigns = true,
        },
      },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run the first available formatter
          javascript = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "eslint_d" },
          typescript = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          astro = { "eslint_d" },
          ["_"] = { "trim_whitespace" },
        },
        format_on_save = {
          -- I recommend these options. See :help conform.format for details.
          lsp_format = "fallback",
          timeout_ms = 500,
        },
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        options = { theme = "nord" },
      },
      cond = not vim.g.vscode,
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "S",
          mode = { "n", "o" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "r",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
        {
          "<c-s>",
          mode = { "c" },
          function()
            require("flash").toggle()
          end,
          desc = "Toggle Flash Search",
        },
      },
    },
    {
      "karb94/neoscroll.nvim",
      cond = not vim.g.vscode,
      opts = {},
    },
    {
      "sphamba/smear-cursor.nvim",
      cond = not vim.g.vscode,
      opts = {},
    },
  },
  checker = { enabled = true, notify = false },
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

local augroup = vim.api.nvim_create_augroup("my.config", {})

local function on_attach(client, bufnr)
  if vim.g.vscode then
    return
  end
  -- map("n", "gh", "<cmd>Lspsaga hover_doc<CR>")
  map("n", "gr", "<cmd>Lspsaga rename<CR>")
  map("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
  map("n", "ga", "<cmd>Lspsaga code_action<CR>")
  map("n", "grr", "<cmd>Lspsaga finder<CR>")
  map("n", "<C-j>", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  map("n", "<C-k>", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  map("n", "gi", require("telescope.builtin").lsp_implementations)
  map("n", "gO", require("telescope.builtin").lsp_document_symbols)
  map("n", "gW", require("telescope.builtin").lsp_dynamic_workspace_symbols)
  map("n", "grt", require("telescope.builtin").lsp_type_definitions)
  map("n", "gK", function()
    vim.diagnostic.open_float()
  end, { buffer = 0, desc = "Toggle diagnostics window." })
  map("n", "<bs>", function()
    vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { buffer = 0, desc = "Toggle verbose diagnostics and inlay_hints." })

  vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      },
    },
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = on_attach,
})

local function config_lsp()
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        format = {
          enable = true,
        },
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })

  vim.lsp.config("clangd", {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--log=verbose",
      "--offset-encoding=utf-16",
    },
    init_options = {
      fallbackFlags = { "-std=c++17" },
    },
  })

  -- local base_on_attach = vim.lsp.config.eslint.on_attach
  -- vim.lsp.config('eslint', {
  --   on_attach = function(client, bufnr)
  --     base_on_attach(client, bufnr)
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       buffer = bufnr,
  --       command = "LspEslintFixAll",
  --     })
  --   end,
  -- })

  vim.lsp.config("typos_lsp", {
    init_options = {
      diagnosticSeverity = "Hint",
    },
  })
end

if not vim.g.vscode then
  config_lsp()
end

---------------------------FOR VSCODE-------------------------------------------

if vim.g.vscode then
  local vscode = require("vscode")
  -- map("n", "gd", function()
  --   vscode.action("editor.action.revealDefinition")
  -- end)
  map("n", "gh", vim.lsp.buf.hover)
  -- map("n", "gd", vim.lsp.buf.definition)
  map("n", "gt", vim.lsp.buf.type_definition)
  map("n", "ga", vim.lsp.buf.code_action)
  map("n", "<C-j>", function()
    vscode.action("editor.action.marker.next")
  end)
  map("n", "<C-k>", function()
    vscode.action("editor.action.marker.prev")
  end)
  map("n", "gr", vim.lsp.buf.rename)
end
