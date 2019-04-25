" => Header ---------------------- {{{1
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
"      ":       ;                                                                 "
"     ":,,      ;;                                                                "
"    "::::      ;;;                                                               "
"   "::::::     ;;;;                                                              "
"   ":;::::,    ;;;;                                                              "
"   "::;::::    ;;;;                                                              "
"   "::::::::   ;;;;   888b    888                            d8b                 "
"   ":::.::::,  ;;;;   8888b   888                            Y8P                 "
"   "::: ;::::  ;;;;   88888b  888                                                "
"   ":::  ::::; ''''   888Y88b 888  .d88b.   .d88b.  888  888 888 88888b.d88b.    "
"   ":::  ,::::.''''   888 Y88b888 d8P  Y8b d88''88b 888  888 888 888 '888 '88b   "
"   ":::   ;::::''''   888  Y88888 88888888 888  888 Y88  88P 888 888  888  888   "
"   ":::    ::::;'''   888   Y8888 Y8b.     Y88..88P  Y8bd8P  888 888  888  888   "
"   ":::    ::::;'''   888    Y888  'Y8888   'Y88P'    Y88P   888 888  888  888   "
"   ":::     ;::''''                                                              "
"    "::      ;:'''                                                               "
"     ";      :;''                                                                "
"      "       ;'                                                                 "
"          ___    ____                                            __   _          "
"        /   |  / / /  __  ______  __  __   ____  ___  ___  ____/ /  (_)____      "
"       / /| | / / /  / / / / __ \/ / / /  / __ \/ _ \/ _ \/ __  /  / / ___/      "
"      / ___ |/ / /  / /_/ / /_/ / /_/ /  / / / /  __/  __/ /_/ /  / (__  )       "
"     /_/  |_/_/_/   \__, /\____/\__,_/  /_/ /_/\___/\___/\__,_/  /_/____/        "
"                       /_/                                                       "
"                                                                                 "
"                 ........................................                        "
"                 "    /\ \ \___  _____   _(_)_ __ ___   "                        "
"                 "   /  \/ / _ \/ _ \ \ / / | '_ ` _ \  "                        "
"                 "  / /\  /  __/ (_) \ V /| | | | | | | "                        "
"                 "  \_\ \/ \___|\___/ \_/ |_|_| |_| |_| "                        "
"                 ........................................                        "
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
" Fie: init.vim
" Author: Ammar Najjar <najjarammar@gmail.com>
" Description: My neovim configurations file
" Last Modified: June 19, 2018
" }}}
" => General ---------------------- {{{1
let s:editor_root=expand("~/.config/nvim/")

" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" Pytho within vim
vnoremap <silent> <leader>p !python3<CR>

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

" Live substitution (neovim only)
set inccommand=nosplit

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

" terminal mode mappings
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
noremap <leader>s :split term://bash<CR><C-w><S-j><S-a>
noremap <leader>t :tabedit term://bash<CR><S-a>
autocmd TermOpen * setlocal statusline=%{b:term_title}

" view hidden characters like spaces and tabs
nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>
" Allow Toggle between tabs - spaces
nmap <F6> :call TabToggle()<cr>

nnoremap <F12> :setlocal relativenumber!<cr>
nnoremap <F11> :setlocal number!<cr>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Move a line of text using leader+[jk]
nmap <leader>j mz:m+<cr>'z
nmap <leader>k mz:m-2<cr>'z
vmap <leader>j :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>k :m'<-2<cr>`>my`<mzgv`yo`z

" switch between characters using leader+[hl]
nmap <leader>l xp
nmap <leader>h xhhp

" Strip trailing white space on save
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

" Auto add head info
" .py file into add header
function HeaderPython()
    call setline(1, "#!/usr/bin/env python")
    call append(1, "# -*- coding: utf-8 -*-")
    normal G
    normal o
endf
autocmd bufnewfile *.py call HeaderPython()

" .sh file
function HeaderBash()
    call setline(1, "#!/usr/bin/env bash")
    normal G
    normal o
endf
autocmd bufnewfile *.sh call HeaderBash()

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
      autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 colorcolumn=120
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
if filereadable(s:editor_root."/plugs.vim")
    execute 'source '.fnameescape(s:editor_root."/plugs.vim")
endif
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
set statusline+=%{fugitive#statusline()}                        " Fugitive
set statusline+=%*                                              " tab chars
set statusline+=%=                                              " right align remainder
" set statusline+=%{SyntasticStatuslineFlag()}                    " Syntastic
set statusline+=%y                                              " buffer file type
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

" Toggle ColumnColor 119
function! g:ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=119
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
" }}}
" => local init.vim ---------------------- {{{1
"" Include user's local vim config if exists
if filereadable(s:editor_root."/local_init.vim")
    execute 'source '.fnameescape(s:editor_root."/local_init.vim")
endif
" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
