-- Change leader key to ,
vim.g.mapleader = ','
local editor_root=vim.fn.expand("~/.config/nvim/")

require('globals')
require('plugins')
require('lsp-config')

opt('o', 'mouse', 'a')			  -- Enable mouse usage (all modes)
opt('o', 'matchtime', 1)		  -- for 1/10th of a second
opt('o', 'showmatch', true)		  -- Show matching brackets.
opt('o', 'ignorecase', true)	  -- Do case insensitive matching
opt('o', 'smartcase', true)		  -- Do smart case matching
opt('o', 'hidden', true)		  -- Hide buffers when they are abandoned
opt('o', 'modelines', 3)
opt('b', 'modeline', true)
opt('w', 'number', true)

--	Ignore compile/build files
vim.cmd [[set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,*~,*.class]]
vim.cmd [[set wildignore+=*/.git/*,*/.hg/*,*/.svn/*]]
vim.cmd [[set wildignore+=*/node_modules/*,*/.dist/*,*/.coverage/*]]

--	when joining lines, don't insert two spaces after '.', '?' or '!'
opt('o', 'joinspaces', false)

--	Don't redraw while executing macros
opt('o', 'lazyredraw', true)

opt('o', 'termguicolors', true)

--	Turn backup off
opt('o', 'writebackup', false)
opt('o', 'swapfile', false)

--	Default 1 tab == 4 spaces
local indent = 4
opt('b', 'expandtab', true)
opt('b', 'shiftwidth', indent)
opt('b', 'smartindent', true)
opt('b', 'tabstop', indent)

-- Live substitution
opt('o', 'inccommand', 'nosplit')

--	create undo file to keep history after closing the file
vim.cmd [[set undofile]]
vim.cmd [[set undolevels=1000]]
vim.fn.execute([[set undodir=]]..editor_root..'/undo/')

-- Remember info about open buffers on close
vim.cmd [[set shada^=%]]

--	visual shifting (does not exit Visual mode)
map('v', '<', '<gv')
map('v', '>', '>gv')

--	Edit the vimrc file
map('n', '<leader>ev', '<cmd>tabe $MYVIMRC<CR>')
-- Opens a new tab with the current buffer's path
map('n', '<leader>te', '<cmd>tabedit<CR>')

-- nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>

-- Switch CWD to the directory of the open buffer
map('', '<leader>cd', '<cmd>cd %:p:h<CR>:pwd<CR>')

-- Toggle spell checking
map('n', '<leader>ss', '<cmd>setlocal spell!<CR>')

-- Terminal mode mappings
map('t', '<ESC>', '<C-\\><C-n>')
map('n', '<leader>s', '<cmd>split term://zsh<CR><C-w><S-j><S-a>')
map('n', '<leader>v', '<cmd>vsplit term://zsh<CR><C-w><S-l><S-a>')
map('n', '<leader>t', '<cmd>tabedit term://zsh<CR><S-a>')
vim.cmd('autocmd TermOpen * setlocal statusline=%{b:term_title}')

-- * extend using local moddule
local localFile = editor_root..'local.lua'
if (file_exists(localFile)) then
	loadfile(localFile)()
end

-- highlight yanked text
vim.api.nvim_command([[autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout=500} )]])

-- highlight trailing whitespaces
vim.api.nvim_command([[
autocmd BufEnter *.* :highlight TrailingWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd InsertEnter *.* :match TrailingWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave *.* :match TrailingWhitespace /\s\+$/
]])

-- delete trailing white spaces except for markdown
vim.api.nvim_command([[autocmd BufWrite *.* lua DeleteTrailingWS()]])
function DeleteTrailingWS()
	if (vim.bo.filetype == 'markdown') then
		return
	end
	vim.fn.nvim_command([[normal mz]])
	vim.cmd([[%s/\s\+$//ge]])
	vim.fn.nvim_command([[normal 'z]])
end

-- view hidden characters like spaces and tabs
map('n', '<F3>', [[<cmd>setlocal listchars=tab:>\-,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:» list! list? <CR>]])

-- Allow toggling between tabs and spaces
-- This seems to trigger a bug https://github.com/neovim/neovim/issues/12861
map('n', '<F4>', '<cmd>lua TabToggle()<cr>')
function TabToggle()
	if vim.bo.expandtab then
		opt('b', 'expandtab', false)
		vim.cmd('retab!')
	else
		opt('b', 'expandtab', true)
		vim.cmd('retab')
	end
end

-- TODO does not update
function TabsFound()
	local curline = vim.api.nvim_buf_get_lines(0, 0, 1000, false)
	for _, value in ipairs(curline) do
		if string.find(value, '\t+') then
			return '[tabs]'
		end
	end
	return ''
end


-- => Status line ---------------------- {{{
local git_stl = vim.fn.exists('g:loaded_fugitive') and "%{FugitiveStatusline()}" or ''
local status_line = {
	"[%n]",-----------------------------------------------buffer number
	"%<%.99f",--------------------------------------------file name, F for full-path
	"%m%r%h%w",-------------------------------------------status flags
	"%#question#",----------------------------------------warning for encoding not utf8
	"%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}",
	"%#warningmsg#",									-- warning if tabs exist
	TabsFound(),
	"%*",
	git_stl,-------------------------------------------fugitive statusline
	"%=",-------------------------------------------------right align
	"%y",-------------------------------------------------buffer file type
	"%#directory#",
	"%{&ff!='unix'?'['.&ff.']':''}",----------------------fileformat not unix
	"%*",
	"-%c%V,%l/",-----------------------------------------column and row Number
	"%L-%P",---------------------------------------------total lines, position in file
}
vim.o.statusline = table.concat(status_line)
-- }}}

-- -- recalculate the tab warning flag when idle and after writing
-- vim.api.nvim_command('autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning')
--
-- -- return '[tabs]' if tab chars in file, or empty string
-- function StatuslineTabWarning()
--	   if (! vim.fn.exists("b:statusline_tab_warning")) then
--		   let tabs = search('^\t', 'nw') != 0
--		   if tabs
--			   let b:statusline_tab_warning = '[tabs]'
--		   else
--			   let b:statusline_tab_warning = ''
--		   endif
--	   endif
--	   return b:statusline_tab_warning
-- end

-- TODO
-- * helper functions
-- * look into session management in nvim
-- HxEREX
