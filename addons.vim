" => Plugins  ---------------------- {{{1
let s:editor_root=expand("~/.config/nvim/")

if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin(s:editor_root."/plugged/")
" => Install Plugins ----------------------------- {{{2
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'               " FZF fuzzy file finder
endif
Plug 'tomtom/tcomment_vim'              " Fast comment
Plug 'ammarnajjar/vim-code-dark'        " vscode similar Colorscheme
"}}}
call plug#end()
" => LSP ----------------------------- {{{2
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

"" coc Global extension names to install when they aren't installed
let g:coc_global_extensions = [
            \ "coc-angular",
            \ "coc-css",
            \ "coc-docker",
            \ "coc-emmet",
            \ "coc-emoji",
            \ "coc-eslint",
            \ "coc-highlight",
            \ "coc-html",
            \ "coc-json",
            \ "coc-lists",
            \ "coc-marketplace",
            \ "coc-omnisharp",
            \ "coc-prettier",
            \ "coc-python",
            \ "coc-rls",
            \ "coc-sh",
            \ "coc-snippets",
            \ "coc-sql",
            \ "coc-syntax",
            \ "coc-tag",
            \ "coc-tslint-plugin",
            \ "coc-tsserver",
            \ "coc-yaml",
            \ "coc-yank",
            \]
"}}}
" => Theme ---------------- {{{2
" Colorscheme
" iterm2 specific settings
set cursorline
function! LightTheme()
    set background=light
    highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
    highlight CursorLineNr term=bold ctermfg=Black ctermbg=Grey gui=bold guifg=White guibg=Grey
    autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=117 gui=bold guifg=White guibg=SkyBlue1
    autocmd InsertEnter * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=NONE
    autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Black ctermbg=Grey gui=bold guifg=White guibg=Grey
    autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
endfunc
function! DarkTheme()
    set background=dark
    try
        colorscheme codedark
    highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
    autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=Black ctermbg=74 gui=bold guifg=Black guibg=SkyBlue1
    autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow ctermbg=Black gui=bold guifg=Yellow guibg=Black
    catch /^Vim\%((\a\+)\)\=:E185/
        echo 'fallback to Default colorscheme'
    endtry
endfunc

if $KONSOLE_PROFILE_NAME =~? 'light' || $ITERM_PROFILE =~? 'light'
    call LightTheme()
else
    call DarkTheme()
endif

if has("gui_running")
    call LightTheme()
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
    set lines=39
    set columns=83
    set guioptions=bgmrL
endif
"}}}
" => fzf ---------------- {{{2
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <Leader>c  :Commits<CR>
nnoremap <silent> <Leader>b  :Buffers<CR>
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
"}}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
