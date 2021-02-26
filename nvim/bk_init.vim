" => Header ---------------------- {{{1
" Fie: init.vim
" Author: Ammar Najjar <najjarammar@protonmail.com>
" Description: My neovim/vim configurations file
" Last Modified: Mon Feb 15 22:42:50 CET 2021
" }}}
" => General ---------------------- {{{1
let mapleader=","   " Change leader key to ,
let s:editor_root=expand("~/.config/nvim/")

" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV") + exists("$ASDF_DIR") > 1
    let g:python3_host_prog=substitute(system("which -a python3 | head -n3 | tail -n1"), "\n", '', 'g')
elseif exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | tail -n2 | head -n1"), "\n", '', 'g')
elseif exists("$ASDF_DIR")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

set mouse=a         " Enable mouse usage (all modes)
set showmatch       " Show matching brackets.
set matchtime=1     " for 1/10th of a second
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set hidden          " Hide buffers when they are abandoned
setglobal modeline
set modelines=3
set number

" Ignore compile/build files
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,*~,*.class
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/node_modules/*,*/.dist/*,*/.coverage/*

" when joining lines, don't insert two spaces after '.', '?' or '!'
set nojoinspaces

" Don't redraw while executing macros
set lazyredraw

" Turn backup off
set nowritebackup
set noswapfile

" Default 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent
set expandtab

" create undo file to keep history after closing the file
set undofile
set undolevels=1000
execute 'set undodir='.fnameescape(s:editor_root."/undo/")

" Remember info about open buffers on close
set shada^=%
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
        augroup vim_python
          autocmd!
          autocmd fileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=80
              \ formatoptions+=croq cinwords=if,elif,else,for,while,try,except,finally,def,class,with
          autocmd fileType python hi ColorColumn ctermbg=darkgrey guibg=lightgrey
        augroup END
        autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
        autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
        autocmd fileType html,xhtml,htm,xml,css,scss,php,ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
        autocmd fileType typescript,typescript.tsx,javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    endif
    " }}}
    " => Colors ---------------------------- {{{2
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    if (has("termguicolors"))
        set termguicolors
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

    " Live substitution
    set inccommand=nosplit

    " Terminal mode mappings
    tnoremap <Esc> <C-\><C-n>
    noremap <leader>s :split term://zsh<CR><C-w><S-j><S-a>
    noremap <leader>v :vsplit term://zsh<CR><C-w><S-j><S-a>
    noremap <leader>t :tabedit term://zsh<CR><S-a>
    autocmd TermOpen * setlocal statusline=%{b:term_title}
    " }}}
    " => Plugins  ---------------------- {{{2
    " if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
    "     silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    "                 \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "     autocmd VimEnter * PlugInstall | source $MYVIMRC
    " endif
    " call plug#begin(s:editor_root."/plugged/")
    "     " => Install Plugins ----------------------------- {{{3
    "     Plug 'neovim/nvim-lspconfig'
    "     Plug 'nvim-lua/completion-nvim'
    "     Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
    "     Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
    "     Plug 'junegunn/fzf.vim'
    "     Plug 'tpope/vim-fugitive'
    "     Plug 'tomtom/tcomment_vim'
    "     Plug 'ammarnajjar/vim-code-dark'
    "     "}}}
    "     call plug#end()
        " => Theme ---------------- {{{3
        set cursorline
        function! LightTheme()
            set background=light
            highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
            highlight cursorlinenr term=bold ctermfg=black ctermbg=grey gui=bold guifg=white guibg=grey
            autocmd insertenter * highlight cursorlinenr term=bold ctermfg=black ctermbg=117 gui=bold guifg=white guibg=skyblue1
            autocmd insertenter * highlight cursorline cterm=none ctermfg=none ctermbg=none
            autocmd insertleave * highlight cursorlinenr term=bold ctermfg=black ctermbg=grey gui=bold guifg=white guibg=grey
            autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
        endfunc
        function! DarkTheme()
            set background=dark
            colorscheme codedark
            highlight CursorLineNr term=bold ctermfg=yellow ctermbg=black gui=bold guifg=yellow guibg=black
            autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=black ctermbg=74 gui=bold guifg=black guibg=skyblue1
            autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=yellow ctermbg=black gui=bold guifg=yellow guibg=black
        endfunc
        try
            if $KONSOLE_PROFILE_NAME =~? 'light' || $ITERM_PROFILE =~? 'light'
                call LightTheme()
            else
                call DarkTheme()
            endif
        catch /^Vim\%((\a\+)\)\=:E185/
        endtry
        "}}}
        " => Builtin LSP (nvim > 5.0) ----------------------------- {{{3
lua << EOF
require('lsp-config')
require('plugins')
EOF
        "}}}
        " => completion-nvim -------------------- {{{3
        set completeopt=menuone,noinsert,noselect
        let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
        "}}}
        " => fzf ---------------- {{{3
        nnoremap <silent> <C-p> :Files<CR>

        " grep text under cursor
        nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>
        nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

        let g:fzf_layout = { 'down': '~40%', 'window': 'enew' }

        " [Buffers] Jump to the existing window if possible
        let g:fzf_buffers_jump = 1

        " [[B]Commits] Customize the options used by 'git log':
        let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

        " show preview with colors using bat
        if executable('bat')
            let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --line-range :150 {}'"
        else
        endif

        " [Tags] Command to generate tags file
        let g:fzf_tags_command = 'ctags --append=no --recurse --exclude=blib --exclude=dist --exclude=node_modules --exclude=coverage --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

        " use ripgrep if exists
        if executable('rg')
          let $FZF_DEFAULT_COMMAND = 'rg --hidden --files --glob="!.git/*" --glob="!venv/*" --glob="!coverage/*" --glob="!node_modules/*" --glob="!target/*" --glob="!__pycache__/*" --glob="!dist/*" --glob="!build/*" --glob="!*.DS_Store"'
         set grepprg=rg
        " else use the silver searcher if exists
        elseif executable('ag')
          let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore venv/ --ignore coverage/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store  -g ""'
          set grepprg=ag\ --nogroup
        else
            let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path  'coverage/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
        endif
        " }}}
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
    set statusline+=%#directory#
    set statusline+=%{&ff!='unix'?'['.&ff.']':''}                   " fileformat not unix
    set statusline+=%*
    set statusline+=\ %c%V,%l/                                      " column and row Number
    set statusline+=%L\ %P                                          " total lines, position in file
    " }}}
    " => autocmds ---------------------- {{{2
    " delete trailing white spaces except for markdown
    autocmd BufWrite *.* :call DeleteTrailingWS()

    "recalculate the tab warning flag when idle and after writing
    autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

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

    " highlight trailing whitespaces
    highlight TrailingWhitespace ctermbg=darkgreen guibg=darkgreen
    autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match TrailingWhitespace /\s\+$/
    " }}}
    " => Helper functions ---------------------- {{{2
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
    function! AppendModeline()
      let l:modeline = printf(" vim: ft=%s ts=%d sw=%d %set %sai",
            \ &filetype, &tabstop, &shiftwidth, &expandtab ? '' : 'no', &autoindent ? '' : 'no')
      let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
      call append(line("$"), l:modeline)
    endfunction
    nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
    " }}}
endif
" }}}
" => local vimrc  ---------------------- {{{1
if filereadable(s:editor_root."/local_vimrc.vim")
    execute 'source '.fnameescape(s:editor_root."/local_vimrc.vim")
endif
" }}}
" vim: ft=vim ts=4 sw=4 et ai