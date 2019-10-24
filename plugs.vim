" => Enable Plugins  ---------------------- {{{1
let s:editor_root=expand("~/.config/nvim/")

if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin(s:editor_root."/plugged/")

" => Plugins ----------------------------- {{{2
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'                 " FZF fuzzy file finder
endif
Plug 'machakann/vim-highlightedyank'    " Highlight when yanking
Plug 'tomtom/tcomment_vim'              " Fast comment
Plug 'ammarnajjar/wombat256mod'           " wombat black Colorscheme
Plug 'ammarnajjar/vim-code-dark'          " vscode dark+ Colorscheme fork
"}}}

call plug#end()
"}}}

" => Plugins Config ---------------------- {{{1

" => LSP ----------------------------- {{{2
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

" => highlightedyank ---------------- {{{2
highlight HighlightedyankRegion cterm=reverse gui=reverse
let g:highlightedyank_highlight_duration = 1000
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
        colorscheme codedark
        highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
        autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=74 gui=bold guifg=Black guibg=SkyBlue1
        autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
    endif
endif
"}}}

" => fzf ---------------- {{{2
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
"
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" }}}
" }}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
