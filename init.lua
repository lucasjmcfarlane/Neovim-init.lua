vim.g.mapleader = " " --set leader key to be space bar
vim.api.nvim_set_keymap("n", "<leader>t", ":NvimTreeToggle<CR>", {noremap = true}) --leader t to open file tree

--EDITOR SETTINGS--
vim.opt.number = true --show line numbers
vim.opt.relativenumber = true --use relative line numbers

--use 4 space tabs
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4 
vim.opt.shiftwidth = 4 
vim.opt.expandtab = true

vim.opt.smartindent = true --auto indentation based on syntax

vim.opt.wrap = false --disable text wrapping
vim.opt.hlsearch = true --highlight all instances of search result
vim.opt.incsearch = true --shows search results as you type
vim.opt.termguicolors = true --enables a wider range of colors in the terminal
vim.opt.scrolloff = 8 --scrolls text once cursor is 8 lines from top or bottom of document

--fixes for lsp
vim.opt.updatetime = 50
vim.opt.ttimeoutlen = 5

--bootstrap Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--update plugins with :Lazy
require("lazy").setup({
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...}, --colorscheme
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}, --syntax highlighting
    {"Raimondi/delimitMate"}, --auto close brackets, quotes etc.
    {"nvim-tree/nvim-tree.lua"}, --file tree

    --LSP STUFF
    {"williamboman/mason.nvim"}, --package manager for LSP's
    {"neovim/nvim-lspconfig"}, --provides default lsp configurations
    {"williamboman/mason-lspconfig.nvim"}, --ensure Mason LSP's use lspconfig configs
    {"hrsh7th/nvim-cmp"}, --provides autocomplete features from LSP
    {"hrsh7th/cmp-nvim-lsp"}, --allows handling of more autocomplete capabilities
})

--Gruvbox colorscheme default configuration, DON'T TOUCH!
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
--apply colorscheme
vim.cmd("colorscheme gruvbox")

--Treesitter default configuration, DON'T TOUCH!
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  prefer_git = true,
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

--Nvim-tree default configuration, DON'T TOUCH!
require("nvim-tree").setup({
  sort = {sorter = "case_sensitive",},
  view = {width = 30,},
  renderer = {group_empty = true,},
  filters = {dotfiles = true,},
})

---LSP STUFF---

--set autocomplete keybinds
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({ --AUTOCOMPLETE KEYBINDS
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({{ name = 'nvim_lsp' , max_item_count=8, keyword_length=2}, {name = 'buffer'},})
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--set LSP keybinds
local on_attach = function(_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

--install LSP's witH Mason-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { --ADD NEW LSP's HERE
        "clangd", --C/C++
        "rust_analyzer", --Rust
        "pylsp", --Python
        "zls", --Zig
        "ols", --Odin
    },
    automatic_installation = true
})

--Configure LSP's 
require'lspconfig'.clangd.setup{on_attach=on_attach, capabilities = capabilities}
require'lspconfig'.rust_analyzer.setup{on_attach=on_attach, capabilities = capabilities}
require'lspconfig'.zls.setup{on_attach=on_attach, capabilities=capabilities}
require'lspconfig'.pylsp.setup{on_attach=on_attach, capabilities=capabilities, settings={pylsp={plugins={pycodestyle={ignore={'E501'}}}}}}
require'lspconfig'.ols.setup{on_attach=on_attach, capabilities=capabilities}
