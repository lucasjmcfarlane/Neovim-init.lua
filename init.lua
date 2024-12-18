--Tabs--
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4 
vim.opt.shiftwidth = 4 
vim.opt.expandtab = true
vim.opt.smartindent = true --auto indentation based on syntax

--Editor Features--
vim.opt.number = true --show line numbers
vim.opt.relativenumber = true --use relative line numbers
vim.opt.termguicolors = true --enables a wider range of colors in the terminal

--Text--
vim.opt.wrap = false --disable text wrapping
vim.opt.scrolloff = 8 --scrolls text once cursor is 8 lines from top or bottom of document

--Search--
vim.opt.incsearch = true --shows search results as you type
vim.opt.hlsearch = true --highlight all instances of search result
vim.opt.ignorecase = true --searches will not be case sensitive
vim.opt.smartcase = true --searches will be case sensitive if an uppercase is explicitly included in the search

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
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...}, --gruvbox colorscheme
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}, --greatly improved syntax highlighting
    {"Raimondi/delimitMate"}, --auto close brackets, quotes, etc.

    { --add indentation guides
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
    },

    { "rafamadriz/friendly-snippets" }, --add snippets

    { --autocompletion engine
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = 'v0.*',
        opts = {
            keymap = { preset = 'super-tab' },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'normal'
            },
            signature = { enabled = true }
        },
    },

    {"neovim/nvim-lspconfig", dependencies = 'saghen/blink.cmp'}, -- provides default LSP configurations
})

--apply Gruvbox colorscheme
require("gruvbox").setup()
vim.cmd("colorscheme gruvbox")

--Treesitter configuration
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

--indent_blankline configuration
require("ibl").setup()

--set autocompletion capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities()

--add LSP's here
require('lspconfig').zls.setup{capabilities=capabilities} --Zig
require('lspconfig').html.setup{capabilities=capabilities} --HTML
