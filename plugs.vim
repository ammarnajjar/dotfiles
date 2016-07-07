" => editor_root  ---------------------- {{{
if has('nvim')
    let s:editor_root=expand("~/.config/nvim/")
else
    let s:editor_root=expand("~/.vim")
endif
"}}}

" => Enable Plugins  ---------------------- {{{
if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin(s:editor_root."/plugged/")

" => Basic Plugins (master) ---------------- {{{
Plug 'tpope/vim-sensible'               " General settings
Plug 'tpope/vim-fugitive'               " Git
Plug 'airblade/vim-gitgutter'           " Git Diff viewer
Plug 'gregsexton/gitv'                  " Git Browser
Plug 'mattn/webapi-vim'                 " needed for gist
Plug 'mattn/gist-vim'                   " gist.github.com
Plug 'ctrlpvim/ctrlp.vim'               " Ctrlp
Plug 'easymotion/vim-easymotion'        " Multiline Search and Move
Plug 'rking/ag.vim'                     " Fast in project search
Plug 'tomtom/tcomment_vim'              " Fast comment
Plug 'tpope/vim-surround'               " Surround
Plug 'scrooloose/nerdtree'              " NERDTree
Plug 'jistr/vim-nerdtree-tabs'          " NERDTree Tabs
Plug 'simnalamburt/vim-mundo'           " Undo Tree fork from gundo
Plug 'scrooloose/syntastic'             " Syntax Checking
Plug 'majutsushi/tagbar'                " Class Explorer
Plug 'Valloric/YouCompleteMe'           " YouCompleteMe
Plug 'godlygeek/tabular'                " Tanularize
Plug 'vim-voom/VOoM'                    " Two Pane Outliner
Plug 'SirVer/ultisnips'                 " Ultisnips
Plug 'honza/vim-snippets'               " Snippets
Plug 'Townk/vim-autoclose'              " Autoclose pracets
Plug 'ammarnajjar/wombat256mod'         " My Dark Colorscheme
Plug 'ap/vim-css-color'                 " CSS colors review
"}}}

" " => General Plugins ---------------------- {{{
" Plug 'jeetsukumaran/vim-buffergator'    " Buffer Explorer
" Plug 'vim-scripts/VisIncr'              " Increase/Decrease visual selection
" Plug 'xolox/vim-misc'                   " Misc tools for session
" Plug 'xolox/vim-session'                " Session control
" " }}}

" " => Programming Plugs ---------------------- {{{
" Plug 'klen/python-mode'                 " Python IDE
" Plug 'rstacruz/sparkup'                 " XML, HTML sparkup
" Plug 'sukima/xmledit'                   " XML edit
" Plug 'vim-scripts/django.vim'           " Django templates Syntax
" Plug 'tpope/vim-dispatch'               " Compile/make in the background
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
" Plug 'LaTeX-Box-Team/LaTeX-Box'         " Latex
" " }}}

" " => Colorschemes Plugs ---------------------- {{{
" Plug 'tomasr/molokai'                   " Dark Colorscheme
" Plug 'vim-scripts/Spacegray.vim'        " Dark Colorscheme
" Plug 'nanotech/jellybeans.vim'          " Dark Colorscheme
" Plug 'altercation/vim-colors-solarized' " Solarized Colorscheme
" Plug 'bling/vim-airline'                " Statusline (viml)
" " }}}

call plug#end()
"}}}

" => Plugins Config ---------------------- {{{

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

" => Tagbar Toggle
nmap <F3> :TagbarToggle<CR>

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

" => Ag , Ctrlp
if executable("ag")
  let g:ackprg = "ag --nogroup --column"
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
execute 'let g:ctrlp_cache_dir=fnameescape(s:editor_root."/cache/ctrlp")'
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
let g:pymode_lint_ignore = "E501,W191,E302"


" => Theme

" Enable CursorLine
set cursorline

"Colorscheme
colorscheme wombat256mod
highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=74 gui=bold guifg=Black guibg=SkyBlue1
autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker