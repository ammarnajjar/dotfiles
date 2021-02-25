-- Change leader key to ,
vim.g.mapleader = ','
local editor_root=vim.fn.expand("~/.config/nvim/")

require('globals')
require('plugins')
require('lsp-config')

opt('o', 'mouse', 'a')            -- Enable mouse usage (all modes)
opt('o', 'matchtime', 1)          -- for 1/10th of a second
opt('o', 'showmatch', true)       -- Show matching brackets.
opt('o', 'ignorecase', true)      -- Do case insensitive matching
opt('o', 'smartcase', true)       -- Do smart case matching
opt('o', 'hidden', true)          -- Hide buffers when they are abandoned
opt('o', 'modelines', 3)
opt('b', 'modeline', true)
opt('w', 'number', true)

--  Ignore compile/build files
vim.cmd [[set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,*~,*.class]]
vim.cmd [[set wildignore+=*/.git/*,*/.hg/*,*/.svn/*]]
vim.cmd [[set wildignore+=*/node_modules/*,*/.dist/*,*/.coverage/*]]

--  when joining lines, don't insert two spaces after '.', '?' or '!'
opt('o', 'joinspaces', false)

--  Don't redraw while executing macros
opt('o', 'lazyredraw', true)

opt('o', 'termguicolors', true)

--  Turn backup off
opt('o', 'writebackup', false)
opt('o', 'swapfile', false)

--  Default 1 tab == 4 spaces
local indent = 4
opt('b', 'expandtab', true)
opt('b', 'shiftwidth', indent)
opt('b', 'smartindent', true)
opt('b', 'tabstop', indent)

-- Live substitution
opt('o', 'inccommand', 'nosplit')

--  create undo file to keep history after closing the file
vim.cmd [[set undofile]]
vim.cmd [[set undolevels=1000]]
vim.fn.execute([[set undodir=]]..editor_root..'/undo/')

-- Remember info about open buffers on close
vim.cmd [[set shada^=%]]

--  visual shifting (does not exit Visual mode)
map('v', '<', '<gv')
map('v', '>', '>gv')

--  Edit the vimrc file
map('n', '<leader>ev', '<cmd>tabe $MYVIMRC<CR>')
-- Opens a new tab with the current buffer's path
-- map('n', ',te', '<cmd>tabedit <c-r>=expand("%:p:h")<CR>/') -- TODO
map('n', '<leader>te', '<cmd>tabedit<CR>')

-- nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>

-- Switch CWD to the directory of the open buffer
map('', '<leader>cd', '<cmd>cd %:p:h<CR>:pwd<CR>')

-- Toggle spell checking
map('n', '<leader>ss', '<cmd>setlocal spell!<CR>')

-- Terminal mode mappings
map('t', '<ESC>', '<C-\\><C-n>')
map('n', '<leader>s', '<cmd>split term://zsh<CR><C-w><S-j><S-a>')
map('n', '<leader>v', '<cmd>vsplit term://zsh<CR><C-w><S-j><S-a>')
map('n', '<leader>t', '<cmd>tabedit term://zsh<CR><S-a>')

-- * extend using local vimrc
-- if vim.fn.filereadable(editor_root..'/local_vimrc.vim') then
--     vim.fn.execute([['source '.fnameescape(]]..editor_root..[["/local_vimrc.vim")]])
-- end

-- TODO:
-- * filetype specific settings (indent and so)
-- * helper functions (tabs, trailing whitespaces, ..)
-- * look into session management in nvim
-- * statusline: e.g: https://github.com/haorenW1025/dotfiles/blob/master/nvim/lua/status-line.lua
-- * auto light/dark theme switcher
