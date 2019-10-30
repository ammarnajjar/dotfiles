" => Header ---------------------- {{{1
" Fie: init.vim
" Author: Ammar Najjar <najjarammar@protonmail.com>
" Description: My neovim configurations file
" Last Modified: October 28 2019
" }}}
" => neovim only ---------------------- {{{1
if (has("nvim"))
    " Live substitution
    set inccommand=nosplit

    " terminal mode mappings
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    noremap <leader>s :split term://bash<CR><C-w><S-j><S-a>
    noremap <leader>t :tabedit term://bash<CR><S-a>
    autocmd TermOpen * setlocal statusline=%{b:term_title}
endif
" }}}
" => General ---------------------- {{{1
let s:editor_root=expand("~/.config/nvim/")

" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" defaults in neovim -> :h vim-diff
set wildmode=list:longest,list:full

let mapleader=","   " Change leader key to ,

set mouse=a         " Enable mouse usage (all modes)
set showmatch       " Show matching brackets.
set matchtime=1     " for 1/10th of a second
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set autowrite       " Automatically save before commands like :next and :make
set hidden          " Hide buffers when they are abandoned
setglobal modeline
set modelines=3
set scrolloff=3
set showmode
set wrap
set linebreak
set title
set number
set relativenumber

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/usr/local/bin/bash
endif

" Ignore compiled files
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,*~,*.class
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

" when joining lines, don't insert two spaces after punctuation
set nojoinspaces

" Don't redraw while executing macros (good performance config)
set lazyredraw
set mat=3

" Time in milliseconds to wait for a mapped sequence to complete
set timeoutlen=500

" Turn backup off
set nobackup
set nowritebackup
set noswapfile

" Default 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent

" create undo file to keep history after closing the file
set undofile
set undolevels=100
execute 'set undodir='.fnameescape(s:editor_root."/undo/")

" Remember info about open buffers on close
set viminfo^=%

" Enable Omni completion
set omnifunc=syntaxcomplete#Complete

" Restrict syntax for all files
set synmaxcol=200

" set vertical Cursor in insert mode
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" }}}
" => Mappings ---------------------- {{{1
if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

" view hidden characters like spaces and tabs
nnoremap <F3> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>
" Allow Toggle between tabs - spaces
nmap <F4> :call TabToggle()<CR>

nnoremap <F12> :setlocal relativenumber!<CR>
nnoremap <F11> :setlocal number!<CR>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Move a line of text using leader+[jk]
nmap <leader>j mz:m+<CR>'z
nmap <leader>k mz:m-2<CR>'z
vmap <leader>j :m'>+<CR>`<my`>mzgv`yo`z
vmap <leader>k :m'<-2<CR>`>my`<mzgv`yo`z

" switch between characters using leader+[hl]
nmap <leader>l xp
nmap <leader>h xhhp

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":Diff")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Disable highlight when <leader><CR> is pressed
map <silent> <leader><CR> :noh<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<CR>:pwd<CR>

" Edit the vimrc file
nmap <leader>ev :tabe $MYVIMRC<CR>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>
"}}}
" => Filetypes specific configs ---------------------- {{{1

" Different settings for different filetypes
if has("autocmd")

    " Restrict textwidth for tex files
    autocmd fileType tex,plaintex,bib setlocal textwidth=79
    if filereadable(s:editor_root."/abbr.vim")
        execute 'source '.fnameescape(s:editor_root."/abbr.vim")
    endif

    autocmd fileType html,xhtml,htm,xml,css,scss,php,ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2

    augroup nvim_python
      autocmd!
      autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 colorcolumn=80
          \ formatoptions+=croq softtabstop=4
          \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    augroup END

    autocmd fileType typescript,javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
endif
" }}}
" => Colorscheme ---------------------- {{{1
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
    set lines=39
    set columns=83
    set guioptions=bgmrL
    " Light Theme
    set background=light
    colorscheme default
    highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
    highlight CursorLineNr term=bold ctermfg=Black ctermbg=Grey gui=bold guifg=White guibg=Grey
    autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=117 gui=bold guifg=White guibg=SkyBlue1
    autocmd InsertEnter * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=NONE
    autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Black ctermbg=Grey gui=bold guifg=White guibg=Grey
    autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
endif
" }}}
" => Plugins ---------------------- {{{1
" => Enable Plugins  ---------------------- {{{2
let s:editor_root=expand("~/.config/nvim/")

if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin(s:editor_root."/plugged/")
" => Plugins ----------------------------- {{{3
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'               " FZF fuzzy file finder
endif
Plug 'machakann/vim-highlightedyank'    " Highlight when yanking
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'tomtom/tcomment_vim'              " Fast comment
Plug 'ammarnajjar/wombat256mod'         " wombat black Colorscheme
Plug 'ammarnajjar/vim-code-dark'        " vscode dark+ Colorscheme fork
"}}}
call plug#end()
"}}}
" => LSP ----------------------------- {{{3
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'javascript support using typescript-language-server',
                \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
                \ 'whitelist': ['javascript', 'javascript.jsx'],
                \ })
endif

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'typescript-language-server',
                \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
                \ 'whitelist': ['typescript', 'typescript.tsx'],
                \ })
endif

if executable('flow')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'flow',
                \ 'cmd': {server_info->['flow', 'lsp']},
                \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
                \ 'whitelist': ['javascript', 'javascript.jsx'],
                \ })
endif

if executable('rls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'rls',
                \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
                \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
                \ 'whitelist': ['rust'],
                \ })
endif

if executable('pyls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['python']},
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'python': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
                \ })
endif

if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'docker-langserver',
                \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
                \ 'whitelist': ['dockerfile'],
                \ })
endif

"" coc Global extension names to install when they aren't installed
let g:coc_global_extensions = [
            \ "coc-marketplace",
            \ "coc-sh",
            \ "coc-docker",
            \ "coc-rls",
            \ "coc-tag",
            \ "coc-sql",
            \ "coc-python",
            \ "coc-angular",
            \ "coc-tsserver",
            \ "coc-eslint",
            \ "coc-json",
            \ "coc-prettier",
            \ "coc-css",
            \ "coc-emmet",
            \ "coc-highlight",
            \ "coc-html",
            \ "coc-yaml",
            \ "coc-yank",
            \ "coc-import-cost",
            \ "coc-pairs",
            \ "coc-tslint",
            \ "coc-tslint-plugin",
            \ "coc-omnisharp"
            \]
"}}}

" => highlightedyank ---------------- {{{3
highlight HighlightedyankRegion cterm=reverse gui=reverse
let g:highlightedyank_highlight_duration = 1000
"}}}
" => Theme ---------------- {{{3
" Colorscheme
" iterm2 specific settings
if $ITERM_PROFILE =~? 'light'
    set background=light
else
    let g:onedark_color_overrides = {
                \ "black": {"gui": "#000000", "cterm": "0", "cterm16": "0" }
                \}
    " Enable CursorLine
    set cursorline
    if ! has("gui_running")
        set background=dark
        colorscheme codedark
        highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
        autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=74 gui=bold guifg=Black guibg=SkyBlue1
        autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
    endif
endif
"}}}
" => fzf ---------------- {{{3
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <Leader>C  :Colors<CR>
nnoremap <silent> <Leader>B  :Buffers<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG :Ag <C-R><C-A><CR>
nnoremap <silent> <Leader>'  :Marks<CR>

" This is the deault extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

autocmd VimEnter * command! Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" use the silver searcher if exists
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore venv/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store  -g ""'
  set grepprg=ag\ --nogroup
endif
" }}}
" }}}
" => Status line ---------------------- {{{1
set statusline=
set statusline=[%n]\                                            " buffer number
set statusline+=%<%.99f                                         " File name, F for full path
set statusline+=%#warningmsg#                                   " display a warning if
set statusline+=%{HasPaste()}                                   " File name, F for full path
set statusline+=%*                                              " tab chars
set statusline+=%m%r%h%w                                        " status flags
set statusline+=%#question#                                     " Display a warning if
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''} " file encoding isnt
set statusline+=%*                                              " utf-8
set statusline+=%#warningmsg#                                   " display a warning if
set statusline+=%{StatuslineTabWarning()}                       " files contains
set statusline+=%*                                              " tab chars
set statusline+=%#question#                                     " Display a warning if
set statusline+=%*                                              " tab chars
set statusline+=%=                                              " right align remainder
set statusline+=%y                                              " buffer file type
set statusline+=%#question#                                     " Display
set statusline+=%{StatusDiagnostic()}                           " coc
set statusline+=%*                                              " infos
set statusline+=%#directory#                                    " display a warning if
set statusline+=%{&ff!='unix'?'['.&ff.']':''}                   " fileformat isnt
set statusline+=%*                                              " unix
set statusline+=%c%V,%l/                                        " column and row Number
set statusline+=%L\ %P                                          " total lines, position in file

" Change StatusLine colors for insert mode
autocmd InsertEnter * highlight StatusLine term=reverse ctermbg=Blue gui=bold guifg=White guibg=Blue
autocmd InsertLeave * highlight StatusLine term=reverse ctermfg=254 ctermbg=238 gui=bold guifg=White guibg=Black
" }}}
" => Helper functions ---------------------- {{{1

" Strip trailing white space on save
function! DeleteTrailingWS()
    " Don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.* :call DeleteTrailingWS()

" Auto add head info
" .py file into add header
function HeaderPython()
    call setline(1, "#!/usr/bin/env python")
    normal G
    normal o
    normal D
endf
autocmd bufnewfile *.py call HeaderPython()

" .sh file
function HeaderBash()
    call setline(1, "#!/usr/bin/env bash")
    normal G
    normal o
    normal D
endf
autocmd bufnewfile *.sh call HeaderBash()
" coc-status-manual
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '') . ' '
endfunction

" Check if paste mode is enabled
function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction

" return '[tabs]' if tab chars in file, or empty string
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        if tabs
            let b:statusline_tab_warning = '[tabs]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction
"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Allow toggling between tabs and spaces
function! TabToggle()
    if &expandtab
        set noexpandtab
        retab!
    else
        set expandtab
        retab
    endif
endfunction

" Toggle ColumnColor 80
function! g:ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=80
  endif
endfunction
nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d %set %sai : ",
        \ &filetype, &tabstop, &shiftwidth, &expandtab ? '' : 'no', &autoindent ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Realign buffers when iterm goes fullscreen
augroup FixProportionsOnResize
  au!
  au VimResized * exe "normal! \<c-w>="
augroup END
" }}}
" => local init.vim ---------------------- {{{1
"" Include user's local vim config if exists
if filereadable(s:editor_root."/local_init.vim")
    execute 'source '.fnameescape(s:editor_root."/local_init.vim")
endif
" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
