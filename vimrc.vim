" => Header ---------------------- {{{
" File: vimrc.vim
" Author: Ammar Najjar <najjarammar@gmail.com>
" Description: My vim/neovim configurations file
" Last Modified: July 02, 2016
" }}}
" => General ---------------------- {{{

" set by default in neovim
set incsearch       " Incremental search
set ttyfast
set autoread
set wildmenu
set wildmode=longest:list,full
set hlsearch
set history=1000
set nocompatible
set backspace=2
set smarttab
set autoindent

if has('nvim')
    let s:editor_root=expand("~/.config/nvim/")
    " terminal mode mappings
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
else
    let s:editor_root=expand("~/.vim")
endif

if has("unix")
    let s:uname = system("uname")
    let g:python_host_prog='/usr/bin/python'
    if s:uname == "Darwin\n"
        let g:python_host_prog='/usr/bin/python'
    endif
endif

let mapleader=","   " Change leader key to ,

set mouse=          " Disable mouse usage (all modes)
set showcmd         " Show (partial) command in status line.
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
set shell=/bin/bash

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.class
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX

" when joining lines, don't insert two spaces after punctuation
set nojoinspaces

" Don't redraw while executing macros (good performance config)
set lazyredraw

" How many tenths of a second to blink when matching brackets
set mat=3
set t_vb=
set tm=500
set t_Co=256
set t_ut=

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile

" virtual tabstops using spaces
" set expandtab

" Default 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent

" create undo file to keep history after closing the file
set undofile
set undolevels=100
set undodir=~/.vim/undo//

" Remember info about open buffers on close
set viminfo^=%

" Enable CursorLine
set cursorline
" change cursor for KDE konsole
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1;BlinkingCursorEnabled=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0;BlinkingCursorEnabled=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1;BlinkingCursorEnabled=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2;BlinkingCursorEnabled=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0;BlinkingCursorEnabled=0\x7"
endif

" Enable Omni completion
set omnifunc=syntaxcomplete#Complete
" }}}
" => Enable vim-plug Plugins ---------------------- {{{
filetype off

call plug#begin(s:editor_root."/plugged/")

" => General Plugins ---------------------- {{{
Plug 'tpope/vim-sensible'               " General settings
Plug 'ctrlpvim/ctrlp.vim'               " Ctrlp
Plug 'easymotion/vim-easymotion'        " Multiline Search and Move
Plug 'rking/ag.vim'                     " Fast in project search
Plug 'simnalamburt/vim-mundo'           " Undo Tree fork from gundo
Plug 'tomtom/tcomment_vim'              " Fast comment
Plug 'tpope/vim-fugitive'               " Git
Plug 'airblade/vim-gitgutter'           " Git Diff viewer
Plug 'gregsexton/gitv'                  " Git Browser
Plug 'mattn/webapi-vim'                 " needed for gist
Plug 'mattn/gist-vim'                   " gist.github.com
Plug 'scrooloose/nerdtree'              " NERDTree
Plug 'jistr/vim-nerdtree-tabs'          " NERDTree Tabs
" Plug 'jeetsukumaran/vim-buffergator'    " Buffer Explorer
" Plug 'vim-voom/VOoM'                    " Two Pane Outliner
" Plug 'vim-scripts/VisIncr'              " Increase/Decrease visual selection
" Plug 'xolox/vim-misc'                   " Misc tools for session
" Plug 'xolox/vim-session'                " Session control
" Plug 'tpope/vim-surround'               " Surround
" }}}
" => Programming Plugs ---------------------- {{{
Plug 'scrooloose/syntastic'             " Syntax Checking
Plug 'majutsushi/tagbar'                " Class Explorer
Plug 'Valloric/YouCompleteMe'           " YouCompleteMe
Plug 'klen/python-mode'                 " Python IDE
Plug 'vim-scripts/django.vim'           " Django templates Syntax
Plug 'godlygeek/tabular'                " Tanularize
Plug 'SirVer/ultisnips'                 " Ultisnips
Plug 'honza/vim-snippets'               " Snippets
Plug 'rstacruz/sparkup'                 " XML, HTML sparkup
Plug 'tpope/vim-dispatch'               " Compile/make in the background
Plug 'sukima/xmledit'                   " XML edit
Plug 'Townk/vim-autoclose'              " Autoclose pracets
" Plug 'vim-scripts/DoxygenToolkit.vim'   " Doxygen generator
" Plug 'vim-scripts/a.vim'                " Switch between header and source c++
" Plug 'sigidagi/vim-cmake-project'       " CMake
" Plug 'vim-scripts/Conque-GDB'           " gdp
" Plug 'justmao945/vim-clang'             " C++ Bundle
" Plug 'terryma/vim-multiple-cursors'     " Multi-Cursors
" Plug 'rdallman/openrefactory-vim'       " Easier Refactoring
" Plug 'kovisoft/slimv'                   " LISP SLIME for vim
" Plug 'vim-scripts/paredit.vim'          " LISP paredit
" Plug 'Yggdroot/indentLine'              " Draw line for each indentation level (spaces)
" Plug 'jmcomets/vim-pony'                " Django jump commands
" Plug 'MarcWeber/vim-addon-mw-utils'     " Utils
" Plug 'tomtom/tlib_vim'                  " Utils
" Plug 'pangloss/vim-javascript'          " javascript
" Plug 'vim-pandoc/vim-pandoc'            " Markdown pandoc
" Plug 'vim-pandoc/vim-pandoc-syntax'     " Markdown syntax
" Plug 'sheerun/vim-polyglot'             " language pack
" Plug 'plasticboy/vim-markdown'          " Markdown syntax
" Plug 'LucHermitte/lh-vim-lib'           " dep plugin
" Plug 'LucHermitte/lh-tags'              " dep Plug
" Plug 'LucHermitte/lh-dev'               " dep plugin
" Plug 'LucHermitte/lh-brackets'          " dep plugin
" Plug 'LucHermitte/vim-refactor'         " C++ refactoring
" Plug 'gi1242/vim-tex-autoclose'         " Latex autoclose
" Plug 'lervag/vimtex'                    " Latex
" Plug 'vim-scripts/AutomaticLaTexPlug'   " Latex
" Plug 'LaTeX-Box-Team/LaTeX-Box'         " Latex
" }}}
" => Colorschemes Plugs ---------------------- {{{
Plug 'ammarnajjar/wombat256mod'         " My prefered Dark Colorscheme
Plug 'ap/vim-css-color'                 " CSS colors review
" Plug 'tomasr/molokai'                   " Dark Colorscheme
" Plug 'vim-scripts/Spacegray.vim'        " Dark Colorscheme
" Plug 'nanotech/jellybeans.vim'          " Dark Colorscheme
" Plug 'altercation/vim-colors-solarized' " Solarized Colorscheme
" Plug 'bling/vim-airline'                " Statusline (viml)
" }}}

call plug#end()

filetype plugin indent on
syntax on
" }}}
" => Plugins Config ---------------------- {{{

" view hidden characters like spaces and tabs
nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>

" => YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

" Resolve conflict between YouCompleteMe and UltiSnips TAB key
let g:UltiSnipsExpandTrigger="<c-j>"

" => Sessions Management
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" view hidden characters like spaces and tabs
nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>

" => Tagbar Toggle
nmap <F3> :TagbarToggle<CR>

" Allow Toggle between tabs - spaces
nmap <F6> :call TabToggle()<cr>

" => NERDTree toggle
map <F4> <plug>NERDTreeTabsToggle<CR>
let NERDTreeIgnore=['\.pyc$','\.aux$', '\.o$', '\~$']
let g:nerdtree_tabs_open_on_gui_startup = 0 " Default 1
let g:nerdtree_tabs_autofind = 1 " Default 0

" Indent Lines toggle
map <F7> :IndentLinesToggle<CR>

" => Fugitive
" Auto-clean fugitive buffers
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif

" => GitGutter
let g:gitgutter_max_signs = 5000
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" " => powerline
" set showtabline=2 " Always display the tabline, even if there is only one tab
" set noshowmode " Hide the default mode text
" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
" set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
" let g:Powerline_symbols = 'fancy'

" => Ag , Ctrlp
if executable("ag")
  let g:ackprg = "ag --nogroup --column"
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_depth = 40
let g:ctrlp_mruf_max = 250
nnoremap <C-x><C-p> :CtrlPMixed<CR>
nnoremap <C-x><C-l> :CtrlPLine<CR>
nnoremap <C-x><C-b> :CtrlPBuffer<CR>
nnoremap <C-x><C-r> :CtrlPMRU<CR>

" => syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 1

" => Clang
let g:syntastic_cpp_compiler = 'clang++'
let g:clang_c_options = '-std=c++14'
let g:syntastic_cpp_compiler_options = ' -std=c++14 -std=libc++'

" => GDB
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly

" => slimv
let g:lisp_rainbow=1
let g:paredit_electric_return=1

" => airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#empty_message = 'no .git'
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline_right_sep=''
let g:airline_left_sep=''
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#syntastic#enabled = 1
" let g:airline_powerline_fonts = 1

" => Pymode
let g:pymode_lint_options_pylint = {'max-line-length': 200, 'indent-string':"t"}
let g:pymode_lint_options_pep8 = {'max_line_length': 200, 'ignore': "E501,W191"}
let g:pymode_options_colorcolumn = 0
let g:pymode_rope = 0
" }}}
" => Mappings ---------------------- {{{

" visual shifting (does not exit Visual mode)
nnoremap <F12> :setlocal relativenumber!<cr>
nnoremap <F11> :setlocal number!<cr>
vnoremap < <gv
vnoremap > >gv

" Move a line of text using leader+[jk] or Comamnd+[jk] on mac
nmap <leader>j mz:m+<cr>'z
nmap <leader>k mz:m-2<cr>'z
vmap <leader>j :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>k :m'<-2<cr>`>my`<mzgv`yo`z

" switch between characters using leader+[hl]
nmap <leader>l xp
nmap <leader>h xhhp

" Delete trailing white space on save
func! DeleteTrailingWS()
    " Don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.* :call DeleteTrailingWS()

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
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
" Super useful when editing files in the same directory
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
" => Filetypes specific mappings ---------------------- {{{

" Different settings for different filetypes
if has("autocmd")

    " Restrict syntax for all files
    autocmd fileType * setlocal synmaxcol=200

    " Restrict textwidth for tex files
    autocmd fileType tex,plaintex,bib setlocal textwidth=79
    " autocmd fileType tex,plaintex source ~/.vim/abbr.vim

    autocmd fileType html,xhtml,htm,xml,php,ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd fileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

    " Compilation settings
    autocmd fileType python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
    autocmd fileType c nnoremap <F5> :w <bar> exec 'Dispatch gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>

    " compiling cpp code
    autocmd fileType C,cc,cpp nnoremap <F5> :w <bar> exec 'Dispatch g++ -g -Wall -std=c++14 '.shellescape('%').' -o '.shellescape('%:r').'  && ./'.shellescape('%:r')<CR>

    " compiling opencv cpp scripts
    autocmd fileType C,cc,cpp nnoremap <F9> :w <bar> exec 'Dispatch g++ -g -Wall -std=c++14 '.shellescape('%').' -o '.shellescape('%:r').' `pkg-config opencv --cflags --libs` && ./'.shellescape('%:r')<CR>

    " Java compile and run
    " F5 to compile F10/F11 to cycle through errors
    autocmd fileType java nnoremap <F5> :call CompileAndRunJava()<CR>
    " map <F10> :cprevious<Return>
    " map <F10> :cnext<Return>

    autocmd BufRead,BufNewFile *.go set fileType=go
endif
" }}}
" => Status line ---------------------- {{{
""""""""""""""""""""""""""""""
" Format the status line
set statusline =
set statusline =[%n]\                                           " buffer number
set statusline +=%<%.99f                                        " File name, F for full path
set statusline +=%m%r%h%w                                       " status flags
set statusline +=%#question#                                     " Display a warning if
set statusline +=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''} " file encoding isnt
set statusline +=%*                                              " utf-8
set statusline +=%#warningmsg#                                   " display a warning if
set statusline +=%{StatuslineTabWarning()}                       " files contains
set statusline +=%*                                              " tab chars
set statusline +=%{fugitive#statusline()}                       " Fugitive
set statusline +=%=                                             " right align remainder
set statusline +=%{SyntasticStatuslineFlag()}                   " Syntastic
set statusline +=%y                                             " buffer file type
set statusline +=%#directory#                                    " display a warning if
set statusline +=%{&ff!='unix'?'['.&ff.']':''}                   " fileformat isnt
set statusline +=%*                                              " unix
set statusline +=%c%V,%l/                                       " column and row Number
set statusline +=%L\ %P                                         " total lines, position in file
set laststatus =2
" }}}
" => Helper functions ---------------------- {{{
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

" Java compile using javac & Run using java
function! CompileAndRunJava()
    :w!
    setlocal makeprg=javac\ %
    setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
    :make
    " split source filename by . and pass the first part to java
    :!i=%; echo ${i//.*/}|xargs java
    " View Errors in vim -- optional
    " :copen
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
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

" :CopyMatches to copy all matches to the clipboard
" :CopyMatches x where x is any register to hold the result.
" paste from register x with "xp or "xP
function! CopyMatches(reg)
    let hits = []
    %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

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

" Retab
function! Retab()
    :retab
    :%s/\s\+$//
endfunction

" Realign buffers when iterm goes fullscreen
augroup FixProportionsOnResize
  au!
  au VimResized * exe "normal! \<c-w>="
augroup END

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=100
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=100
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

command! -bang WatchForChanges                  :call WatchForChanges(@%,  {'toggle': 1, 'autoread': <bang>0})
command! -bang WatchForChangesWhileInThisBuffer :call WatchForChanges(@%,  {'toggle': 1, 'autoread': <bang>0, 'while_in_this_buffer_only': 1})
command! -bang WatchForChangesAllFile           :call WatchForChanges('*', {'toggle': 1, 'autoread': <bang>0})
function! WatchForChanges(bufname, ...)
  " Figure out which options are in effect
  if a:bufname == '*'
    let id = 'WatchForChanges'.'AnyBuffer'
    " If you try to do checktime *, you'll get E93: More than one match for * is given
    let bufspec = ''
  else
    if bufnr(a:bufname) == -1
      echoerr "Buffer " . a:bufname . " doesn't exist"
      return
    end
    let id = 'WatchForChanges'.bufnr(a:bufname)
    let bufspec = a:bufname
  end
  if len(a:000) == 0
    let options = {}
  else
    if type(a:1) == type({})
      let options = a:1
    else
      echoerr "Argument must be a Dict"
    end
  end
  let autoread    = has_key(options, 'autoread')    ? options['autoread']    : 0
  let toggle      = has_key(options, 'toggle')      ? options['toggle']      : 0
  let disable     = has_key(options, 'disable')     ? options['disable']     : 0
  let more_events = has_key(options, 'more_events') ? options['more_events'] : 1
  let while_in_this_buffer_only = has_key(options, 'while_in_this_buffer_only') ? options['while_in_this_buffer_only'] : 0
  if while_in_this_buffer_only
    let event_bufspec = a:bufname
  else
    let event_bufspec = '*'
  end
  let reg_saved = @"
  "let autoread_saved = &autoread
  let msg = "\n"
  " Check to see if the autocommand already exists
  redir @"
    silent! exec 'au '.id
  redir END
  let l:defined = (@" !~ 'E216: No such group or event:')
  " If not yet defined...
  if !l:defined
    if l:autoread
      let msg = msg . 'Autoread enabled - '
      if a:bufname == '*'
        set autoread
      else
        setlocal autoread
      end
    end
    silent! exec 'augroup '.id
      if a:bufname != '*'
        "exec "au BufDelete    ".a:bufname . " :silent! au! ".id . " | silent! augroup! ".id
        "exec "au BufDelete    ".a:bufname . " :echomsg 'Removing autocommands for ".id."' | au! ".id . " | augroup! ".id
        exec "au BufDelete    ".a:bufname . " execute 'au! ".id."' | execute 'augroup! ".id."'"
      end
        exec "au BufEnter     ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHold   ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHoldI  ".event_bufspec . " :checktime ".bufspec
      " The following events might slow things down so we provide a way to disable them...
      " vim docs warn:
      "   Careful: Don't do anything that the user does
      "   not expect or that is slow.
      if more_events
        exec "au CursorMoved  ".event_bufspec . " :checktime ".bufspec
        exec "au CursorMovedI ".event_bufspec . " :checktime ".bufspec
      end
    augroup END
    let msg = msg . 'Now watching ' . bufspec . ' for external updates...'
  end
  " If they want to disable it, or it is defined and they want to toggle it,
  if l:disable || (l:toggle && l:defined)
    if l:autoread
      let msg = msg . 'Autoread disabled - '
      if a:bufname == '*'
        set noautoread
      else
        setlocal noautoread
      end
    end
    " Using an autogroup allows us to remove it easily with the following
    " command. If we do not use an autogroup, we cannot remove this
    " single :checktime command
    " augroup! checkforupdates
    silent! exec 'au! '.id
    silent! exec 'augroup! '.id
    let msg = msg . 'No longer watching ' . bufspec . ' for external updates.'
  elseif l:defined
    let msg = msg . 'Already watching ' . bufspec . ' for external updates'
  end
  " echo msg
  let @"=reg_saved
endfunction
execute WatchForChanges("*",{'autoread':1})

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

" }}}
" => Colorscheme ---------------------- {{{

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
else
    " " Light Themes
    " set background=light
    " colorscheme default
    " highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
    " highlight CursorLineNr term=bold ctermfg=Black ctermbg=Grey gui=bold guifg=White guibg=Grey
    " autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=117 gui=bold guifg=White guibg=SkyBlue1
    " autocmd InsertEnter * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=NONE
    " autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Black ctermbg=Grey gui=bold guifg=White guibg=Grey
    " autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254

    " Dark Themes
    set background=dark
    colorscheme wombat256mod
    highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
    autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=74 gui=bold guifg=Black guibg=SkyBlue1
    autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
endif
" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
