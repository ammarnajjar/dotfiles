" => Header ---------------------- {{{1
" Fie: init.vim
" Author: Ammar Najjar <najjarammar@protonmail.com>
" Description: My neovim configurations file
" Last Modified: Sun 12 Apr 2020 01:49:40 PM CEST
" }}}
" => leader mapping ---------------------- {{{1
let mapleader=","   " Change leader key to ,
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

set mouse=a         " Enable mouse usage (all modes)
set showmatch       " Show matching brackets.
set matchtime=1     " for 1/10th of a second
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
setglobal modeline
set modelines=3

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

" Restrict syntax for all files
set synmaxcol=200

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" }}}
" => Mappings ---------------------- {{{1

" view hidden characters like spaces and tabs
nnoremap <F3> :<C-U>setlocal listchars=tab:>\-,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:» list! list? <CR>
" Allow Toggle between tabs - spaces
nmap <F4> :call TabToggle()<CR>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Edit the vimrc file
nmap <leader>ev :tabe $MYVIMRC<CR>
"}}}
" => not in vscode --------------------- {{{1
if !exists('g:vscode')
    " => Filetypes specific configs ---------------------- {{{2
    if has("autocmd")

        autocmd fileType html,xhtml,htm,xml,css,scss,php,ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2

        augroup nvim_python
          autocmd!
          autocmd fileType python setlocal expandtab shiftwidth=4 tabstop=4 colorcolumn=80
              \ formatoptions+=croq softtabstop=4
              \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
          autocmd fileType python hi ColorColumn ctermbg=darkgrey guibg=lightgrey
        augroup END

        autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
        autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
        autocmd fileType typescript,typescript.tsx,javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    endif
    " }}}
    " => Colors ---------------------------- {{{2
    if (empty($TMUX))
      if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
      endif
      if (has("termguicolors"))
        set termguicolors
      endif
    endif
    " }}}
    " => highlightedyank ------------------- {{{2
    highlight HighlightedyankRegion cterm=reverse gui=reverse
    let g:highlightedyank_highlight_duration = 1000
    " }}}
    " => mappings ---------------------- {{{2
    nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>

    " Opens a new tab with the current buffer's path
    map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

    " Switch CWD to the directory of the open buffer
    map <leader>cd :cd %:p:h<CR>:pwd<CR>

    " Toggle spell checking
    map <leader>ss :setlocal spell!<cr>
    " }}}
    " => neovim only ---------------------- {{{2
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
    " => Plugins ---------- {{{2
    if filereadable(s:editor_root."/addons.vim")
        execute 'source '.fnameescape(s:editor_root."/addons.vim")
    endif
    " }}}
    " => Status line ---------------------- {{{2
    set statusline=
    set statusline=[%n]\                                            " buffer number
    set statusline+=%<%.99f                                         " file name, F for full path
    set statusline+=%#warningmsg#                                   " warning for paste mode
    set statusline+=%{HasPaste()}
    set statusline+=%*
    set statusline+=%m%r%h%w                                        " status flags
    set statusline+=%#question#                                     " warning for encoding not utf8
    set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
    set statusline+=%*
    set statusline+=%#warningmsg#                                   " warning if tabs exist
    set statusline+=%{StatuslineTabWarning()}
    set statusline+=%*
    set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''} " fugitive
    set statusline+=%=                                              " right align
    set statusline+=%y                                              " buffer file type
    set statusline+=(%{strftime(\"%d.%m.%Y\ %H:%M\",getftime(expand(\"%:p\")))})  " last modified
    set statusline+=%#question#                                     " coc diagnostic
    set statusline+=%{StatusDiagnostic()}
    set statusline+=%*
    set statusline+=%#directory#
    set statusline+=%{&ff!='unix'?'['.&ff.']':''}                   " fileformat not unix
    set statusline+=%*
    set statusline+=\ %c%V,%l/                                      " column and row Number
    set statusline+=%L\ %P                                          " total lines, position in file

    " }}}
    " => autocmds ---------------------- {{{2
    " Change StatusLine colors for insert mode
    autocmd InsertEnter * highlight StatusLine term=reverse ctermbg=Blue gui=bold guifg=White guibg=Blue
    autocmd InsertLeave * highlight StatusLine term=reverse ctermfg=254 ctermbg=238 gui=bold guifg=White guibg=Black

    " delete trailing white spaces except for markdown
    autocmd BufWrite *.* :call DeleteTrailingWS()

    "recalculate the tab warning flag when idle and after writing
    autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

    " Return to last edit position when opening files (You want this!)
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
    " }}}
endif
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

" => local init.vim ---------------------- {{{1
"" Include user's local vim config if exists
if filereadable(s:editor_root."/local_init.vim")
    execute 'source '.fnameescape(s:editor_root."/local_init.vim")
endif
" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
