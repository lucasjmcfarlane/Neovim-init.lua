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
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...}, --colorscheme
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}, --syntax highlighting
    {"Raimondi/delimitMate"}, --auto close brackets, quotes etc.

    { --add indentation guides
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    {"neovim/nvim-lspconfig"}, -- provides default LSP configurations
    {"hrsh7th/nvim-cmp"}, --autocompletion engine that's smarter than the built-in one
    {"hrsh7th/cmp-nvim-lsp"}, --provides the new autocompletion engine's capabilities to the LSP's
    { "rafamadriz/friendly-snippets" }, --add snippets
    {"saadparwaiz1/cmp_luasnip"}, -- make the snippets work with cmp
    { --snippet engine
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
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

--load snippets
require("luasnip.loaders.from_vscode").lazy_load()

--autocompletion configuration
local cmp = require("cmp")
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip'},
    }, 
    {
        { name = 'buffer' },
    })
})
local capabilities = require("cmp_nvim_lsp").default_capabilities()

--add LSP's here
require('lspconfig').zls.setup{capabilities=capabilities} --Zig
require('lspconfig').html.setup{capabilities=capabilities} --HTML
