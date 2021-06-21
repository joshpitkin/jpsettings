-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
-- paq {'shougo/deoplete-lsp'}
-- paq {'shougo/deoplete.nvim', hook = fn['remote#host#UpdateRemotePlugins']}
-- paq {'nvim-treesitter/nvim-treesitter'}
-- require 'nvim-treesitter.install'.compilers = { "gcc", "clang"  }
-- paq {'morhetz/gruvbox'}
paq {'tomasr/molokai'}
paq {'kyazdani42/nvim-web-devicons'}
paq {'kyazdani42/nvim-tree.lua'}
-- paq {'neovim/nvim-lspconfig'}
-- paq {'junegunn/fzf', hook = fn['fzf#install']}
-- paq {'junegunn/fzf.vim'}
-- paq {'ojroques/nvim-lspfuzzy'}
paq {'hoob3rt/lualine.nvim'}
-- paq {'akinsho/nvim-bufferline.lua'}
-- paq {'tpope/vim-fugitive'}
-- paq {'tommcdo/vim-fubitive'}
g['python3_host_prog'] = '~/AppData/Local/Programs/Python/Python37-32/python'
-- g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup

g['fubitive_domain_pattern'] = 'bitbucket.micron.com' -- for :GBrowse
g['loaded_netrwPlugin'] = 1

g['nvim_tree_quit_on_open'] = 1  
g['nvim_tree_auto_close'] = 1  
g['nvim_tree_follow'] = 1  
g['nvim_tree_ignore'] = { '.git', 'node_modules' }
g['mapleader'] = ' '

require('lualine').setup{
  options = {
    theme = 'molokai'
  }
}
-- require('bufferline').setup{}

-------------------- OPTIONS -------------------------------
local indent = 2
cmd 'colorscheme molokai'                              -- Put your favorite colorscheme here
opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'softtabstop', indent)                           -- Number of spaces tabs count for
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'termguicolors', true)                       -- True color support
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('o', 'backspace', 'indent,eol,start')
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'number', true)                              -- Print line number
opt('w', 'relativenumber', true)                      -- Relative line numbers
opt('w', 'wrap', false)                               -- Disable line wrap


-------------------- MAPPINGS -------------------------------
map('n', '<space>b', ':NvimTreeToggle<CR>')
map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

map('n', '<C-p>', ':GFiles<CR>')

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

map('n', '<leader>q', ':bd<CR>') 
map('n', '<C-q>', ':bp<bar>|bd #<CR>') 
map('n', '<C-tab>', ':bn<CR>')
map('n', '<leader>p', ':bp<CR>')
map('n', '<leader>n', ':bn<CR>')
map('n', '<leader>qq', ':wq<CR>')
map('n', '<leader>cd', ':cd %:p:h<CR>')
-------------------- LSP -----------------------------------
-- local lsp = require 'lspconfig'
-- local lspfuzzy = require 'lspfuzzy'

-- For ccls we use the default settings
-- lsp.ccls.setup {}
-- root_dir is where the LSP server will start: here at the project root otherwise in current folder
-- lsp.pyls.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
-- lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-- for some reason these don't work with the opt() method
vim.api.nvim_command [[ set noswapfile nobackup ]]
