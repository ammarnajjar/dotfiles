" => Enable Plugins  ---------------------- {{{1
let s:editor_root=expand("~/.config/nvim/")

if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin(s:editor_root."/plugged/")

" => Basic Plugins (master) ---------------- {{{2
Plug 'tpope/vim-sensible'               " General settings
Plug 'tpope/vim-fugitive'               " Git
Plug 'airblade/vim-gitgutter'           " Git Diff viewer
Plug 'gregsexton/gitv'                  " Git Browser
Plug 'mattn/webapi-vim'                 " needed for gist
Plug 'mattn/gist-vim'                   " gist.github.com
Plug 'easymotion/vim-easymotion'        " Multiline Search and Move
Plug 'rking/ag.vim'                     " Fast in project search
Plug 'tomtom/tcomment_vim'              " Fast comment
Plug 'majutsushi/tagbar'                " Class Explorer
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'                 " FZF fuzzy file finder
endif
Plug 'godlygeek/tabular'                " Tanularize
Plug 'scrooloose/nerdtree'              " NERDTree
Plug 'jistr/vim-nerdtree-tabs'          " NERDTree Tabs
Plug 'ap/vim-css-color'                 " CSS colors review
" Plug 'rstacruz/sparkup'                 " XML, HTML sparkup
Plug 'vim-voom/VOoM'                    " Two Pane Outliner
Plug 'machakann/vim-highlightedyank'    " Highlight when yanking
"}}}

" " => General Plugins ---------------------- {{{2
" Plug 'SirVer/ultisnips'                 " Ultisnips
" Plug 'honza/vim-snippets'               " Snippets
Plug 'Raimondi/delimitMate'             " Autoclose pracets
Plug 'tpope/vim-surround'               " Surround
" Plug 'simnalamburt/vim-mundo'           " Undo Tree fork from gundo
" Plug 'scrooloose/syntastic'             " Syntax Checking
" Plug '907th/vim-auto-save'              " Autosave
" Plug 'sheerun/vim-polyglot'             " language pack
" Plug 'ctrlpvim/ctrlp.vim'               " Ctrlp
" Plug 'jeetsukumaran/vim-buffergator'    " Buffer Explorer
" Plug 'vim-scripts/VisIncr'              " Increase/Decrease visual selection
" Plug 'xolox/vim-misc'                   " Misc tools for session
" Plug 'xolox/vim-session'                " Session control
" Plug 'vim-scripts/AutoComplPop'         " Auto popup complete
" Plug 'terryma/vim-multiple-cursors'     " Multi-Cursors
" " }}}

" " => Programming Plugs ---------------------- {{{2

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'prabirshrestha/async.vim'         " async language server protocol
Plug 'prabirshrestha/vim-lsp'
Plug 'hail2u/vim-css3-syntax'           " HTML Bundle
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'jelera/vim-javascript-syntax'     " Javascript Bundle
Plug 'sheerun/vim-polyglot'             " syntax & indentation
Plug 'rust-lang/rust.vim'               " Rust support
Plug 'racer-rust/vim-racer'
Plug 'sebastianmarkow/deoplete-rust'    " autocomplete rust
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'pearofducks/ansible-vim'          " Ansible
Plug 'jpalardy/vim-slime'               " send expression to tmux
" Plug 'metakirby5/codi.vim'              " Evaluate interpreted languages live
" Plug 'pangloss/vim-javascript'          " javascript
" Plug 'leafgarland/typescript-vim'       " typescript
" Plug 'HerringtonDarkholme/yats.vim'     " typescript
" Plug 'mattn/emmet-vim'
" Plug 'sukima/xmledit'                   " XML edit
" Plug 'tpope/vim-dispatch'               " Compile/make in the background
" Plug 'vim-scripts/DoxygenToolkit.vim'   " Doxygen generator
" Plug 'vim-scripts/a.vim'                " Switch between header and source c++
" Plug 'sigidagi/vim-cmake-project'       " CMake
" Plug 'vim-scripts/Conque-GDB'           " gdp
" Plug 'justmao945/vim-clang'             " C++ Bundle
" Plug 'rdallman/openrefactory-vim'       " Easier Refactoring
" Plug 'kovisoft/slimv'                   " LISP SLIME for vim
" Plug 'vim-scripts/paredit.vim'          " LISP paredit
" Plug 'MarcWeber/vim-addon-mw-utils'     " Utils
" Plug 'tomtom/tlib_vim'                  " Utils
" Plug 'vim-pandoc/vim-pandoc'            " Markdown pandoc
" Plug 'vim-pandoc/vim-pandoc-syntax'     " Markdown syntax
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

" " => Python Plugs ---------------------- {{{2
" Plug 'w0rp/ale'                         " Auto linter
" Plug 'nvie/vim-flake8'                   " python-flake8
" Plug 'Glench/Vim-Jinja2-Syntax'         " jinja syntax
" Plug 'zchee/deoplete-jedi'              " Auto-complete
" Plug 'janko-m/vim-test'                 " Run tests within vim
" Plug 'heavenshell/vim-pydocstring'      " Generate docstrings
" Plug 'hynek/vim-python-pep8-indent'     " PEP8 indentation aware
" Plug 'integralist/vim-mypy'             " Static Type checker
" Plug 'mitsuhiko/vim-jinja'              " jinja syntax
" Plug 'jmcantrell/vim-virtualenv'        " Venv aware for auto completion
" Plug 'vim-scripts/django.vim'           " Django templates Syntax
" Plug 'klen/python-mode'                 " Python IDE
" Plug 'Yggdroot/indentLine'              " Draw line for each indentation level (spaces)
" Plug 'jmcomets/vim-pony'                " Django jump commands
" " }}}

" " => Colorschemes Plugs ---------------------- {{{2
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'ammarnajjar/wombat256mod'           " wombat black Colorscheme
" Plug 'ammarnajjar/onedark.vim'            " Atom one dark theme
" Plug 'ammarnajjar/vim-code-dark'          " vscode dark+ Colorscheme fork
" Plug 'tomasr/molokai'                   " Dark Colorscheme
" Plug 'vim-scripts/Spacegray.vim'        " Dark Colorscheme
" Plug 'nanotech/jellybeans.vim'          " Dark Colorscheme
" Plug 'altercation/vim-colors-solarized' " Solarized Colorscheme
" Plug 'bling/vim-airline'                " Statusline (viml)
" " }}}

call plug#end()
"}}}

" => Plugins Config ---------------------- {{{1

"" lsp

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
            \ "coc-tslint-plugin"
            \]

" javascript
let g:javascript_enable_domhtmlcss = 1

" Syntax highlight
" Default highlight is better than polyglot
let g:polyglot_disabled = ['python']
let python_highlight_all = 1


" typescript
let g:yats_host_keyword = 1

" => vim-slime ---------------- {{{2
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/tmp/.slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
"}}}

" => highlightedyank ---------------- {{{2
highlight HighlightedyankRegion cterm=reverse gui=reverse
let g:highlightedyank_highlight_duration = 1000
"}}}

" => ale ---------------- {{{2
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
            \'python': ['flake8']
            \}
"}}}

" => Deoplete ---------------- {{{2
let g:deoplete#enable_at_startup = 1
" close the preview window automatically
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

execute 'let g:racer_cmd=fnameescape(s:editor_root."/.cargo/bin/racer")'
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1
"}}}

" => snippets ---------------- {{{2
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"
"}}}

" => vim-test ---------------- {{{2
let test#python#runner = 'pytest'
let test#strategy = "neovim"
"}}}

" => Theme ---------------- {{{2
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
        colorscheme wombat256mod
        highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
        autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=74 gui=bold guifg=Black guibg=SkyBlue1
        autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
    endif
endif
"}}}

" => Autosave ---------------- {{{2
let g:auto_save = 0  " enable AutoSave on Vim startup
let g:auto_save_events = ["InsertLeave", "TextChanged"] " save on every change in normal mode.
"}}}

"}}}

" => Sessions Management ---------------- {{{2
let g:session_autosave = 'no'
let g:session_autoload = 'no'
"}}}

" => Tagbar Toggle ---------------- {{{2
nmap <F3> :TagbarToggle<CR>
"}}}

" => NERDTree toggle ---------------- {{{2
map <F4> <plug>NERDTreeTabsToggle<CR>
let NERDTreeIgnore=['\.pyc$','\.aux$', '\.o$', '\~$']
let g:nerdtree_tabs_open_on_gui_startup = 0 " Default 1
let g:nerdtree_tabs_autofind = 1 " Default 0

" Indent Lines toggle
map <F7> :IndentLinesToggle<CR>
"}}}

" => Fugitive ---------------- {{{2
" Auto-clean fugitive buffers
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif
"}}}

" => GitGutter ---------------- {{{2
let g:gitgutter_max_signs = 5000
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
"}}}

" => Ag ---------------- {{{2
if executable("ag")
  let g:ackprg = "ag --nogroup --column"
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
"}}}

" => Ctrlp ---------------- {{{2
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
execute 'let g:ctrlp_cache_dir=fnameescape(s:editor_root."/cache/ctrlp")'
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_depth = 40
let g:ctrlp_mruf_max = 250
nmap <C-x><C-p> :CtrlPMixed<CR>
nmap <C-x><C-l> :CtrlPLine<CR>
nmap <C-x><C-b> :CtrlPBuffer<CR>
nmap <C-x><C-r> :CtrlPMRU<CR>
"}}}

" => fzf ---------------- {{{2
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
"
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

nnoremap <silent> <expr> <C-p> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"
nnoremap <silent> <Leader>C  :Colors<CR>
nnoremap <silent> <Leader>B  :Buffers<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG :Ag <C-R><C-A><CR>
nnoremap <silent> <Leader>`  :Marks<CR>
"}}}

" => Clang ---------------- {{{2
let g:syntastic_cpp_compiler = 'clang++'
let g:clang_c_options = '-std=c++14'
let g:syntastic_cpp_compiler_options = ' -std=c++14 -std=libc++'
"}}}

" => GDB ---------------- {{{2
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly
"}}}

" => slimv ---------------- {{{2
let g:lisp_rainbow=1
let g:paredit_electric_return=1
"}}}

" => airline ---------------- {{{2
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
"}}}

" => Pymode ---------------- {{{2
let g:pymode_lint_ignore = "E501,W191,E302"
let g:pymode_lint_on_write = 0
" }}}

" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
