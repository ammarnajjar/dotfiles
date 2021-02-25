-- => auto install packer ---------------- {{{1
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('config')..'/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end
-- load packer
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}
    use { 'neovim/nvim-lspconfig' }
    use { 'nvim-lua/completion-nvim' }
    use { 'dstein64/nvim-scrollview' }
    use { 'junegunn/fzf' }
    use { 'junegunn/fzf.vim' }
    use { 'tpope/vim-fugitive' }
    use { 'tomtom/tcomment_vim' }
    use { 'ammarnajjar/vim-code-dark' }
end)
-- }}}
-- => colorscheme ---------------- {{{1
vim.cmd [[colorscheme codedark]]
-- }}}
-- => completion ---------------- {{{1
vim.cmd [[set completeopt=menuone,noinsert,noselect]]
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
-- }}}
-- => fzf ---------------- {{{1
map('n', '<C-p>', '<cmd>Files<cr>')

-- grep text under cursor
map('n', '<leader>rg', '<cmd>Rg <C-R><C-W><CR>')
map('n', '<leader>ag', '<cmd>Ag <C-R><C-W><CR>')

-- vim.g['fzf_layout'] = { 'down': '~40%', 'window': 'enew' } -- TODO

-- [Buffers] Jump to the existing window if possible
vim.g['fzf_buffers_jump'] = 1

-- [[B]Commits] Customize the options used by 'git log':
vim.g['fzf_commits_log_options'] = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- -- show preview with colors using bat
vim.cmd [[let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --line-range :150 {}'"]]

-- [Tags] Command to generate tags file
vim.g['fzf_tags_command'] = 'ctags --append=no --recurse --exclude=blib --exclude=dist --exclude=node_modules --exclude=coverage --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

-- use ripgrep
vim.cmd [[let $FZF_DEFAULT_COMMAND = 'rg --hidden --files --glob="!.git/*" --glob="!venv/*" --glob="!coverage/*" --glob="!node_modules/*" --glob="!target/*" --glob="!__pycache__/*" --glob="!dist/*" --glob="!build/*" --glob="!*.DS_Store"']]
vim.cmd [[set grepprg=rg]]
-- }}}
