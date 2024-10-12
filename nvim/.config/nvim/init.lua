vim.opt.number = true
vim.opt.title = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.history = 200 -- treat tab as two spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 10
vim.opt.smartindent = true
vim.opt.cmdheight = 1
vim.opt.inccommand = "nosplit"
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { eol = '↲', tab = '→ ', trail = '·', nbsp = ':', space = '·', extends = '›', precedes = '‹' }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.mouse = ""

-- Key mappings
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

local keymap = vim.keymap
local options = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")
-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G") -- New tab
-- Split window
keymap.set("n", "ss", ":split<Return>", options)
keymap.set("n", "sv", ":vsplit<Return>", options)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end
})

-- Disable relative numbers when leaving Insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end
})

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "gbprod/nord.nvim",
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "easymotion/vim-easymotion",
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "lewis6991/gitsigns.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        auto_install = true, -- depend on tree-sitter-cli
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, cond = not vim.g.vscode },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      "saadparwaiz1/cmp_luasnip",
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = { theme = "nord" }
    },
    cond = not vim.g.vscode
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
})

-- Plugin config
if not vim.g.vscode then
  vim.g.nord_italic = false
  vim.g.nord_bold = false
  vim.cmd.colorscheme("nord")
end


require("oil").setup({
  view_options = { show_hidden = true, },
  float = {
    max_width = 40,
    max_height = 40,
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
});
keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })


local builtin = require('telescope.builtin')
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
keymap.set('n', '<leader>ff', run_in_git_root(builtin.find_files), options)
keymap.set('n', '<leader>fg', run_in_git_root(builtin.live_grep), options)
keymap.set('n', '<leader>fb', run_in_git_root(builtin.buffers), options)
keymap.set('n', '<leader>fh', run_in_git_root(builtin.help_tags), options)
keymap.set('n', '<leader>fr', run_in_git_root(builtin.resume), options)


if not vim.g.vscode then
  local lspconfig = require("lspconfig")
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd", "vtsls", "pyright", "eslint", "cssls", "typos_lsp" },
    handlers = {
      function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({})
      end,
      ["lua_ls"] = function ()
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }
              }
            }
          }
        })
      end,
      ["clangd"] = function ()
        lspconfig.clangd.setup({
          cmd = { "clangd", "--offset-encoding=utf-16" }
        })
      end,
      ["eslint"] = function ()
        lspconfig.eslint.setup({
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        })
      end,
      ["typos_lsp"] = function ()
        lspconfig.typos_lsp.setup({
          init_options = {
            diagnosticSeverity = "Hint"
          }
        })
      end
    }
  })
end

keymap.set("n", "gh", vim.lsp.buf.hover, options)
keymap.set("n", "gd", vim.lsp.buf.definition, options)
--keymap.set("n", "gt", vim.lsp.buf.type_definition, options)
keymap.set("n", "ga", vim.lsp.buf.code_action, options)
keymap.set("n", "<C-j>", vim.diagnostic.goto_next, options)
keymap.set("n", "gr", vim.lsp.buf.rename, options)

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "luasnip" }
  }),
  mapping = cmp.mapping.preset.insert(),
})
require("luasnip.loaders.from_vscode").lazy_load()

require('gitsigns').setup({
  current_line_blame_opts = { delay= 100 },
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>hd', gitsigns.diffthis)
    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
    map('n', '<leader>td', gitsigns.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

if vim.g.vscode then
  local vscode = require('vscode')
  keymap.set("n", "gd", function() vscode.action('editor.action.revealDefinition') end, options)
end

