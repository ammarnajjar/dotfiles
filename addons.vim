" => Plugins  ---------------------- {{{1
if (has("nvim"))
    let s:editor_root=expand("~/.config/nvim/")
    if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
else
    let s:editor_root=expand("~/.vim/")
    if empty(glob(fnameescape(s:editor_root."/autoload/plug.vim")))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
endif

call plug#begin(s:editor_root."/plugged/")
" => Install Plugins ----------------------------- {{{2
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.config/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tomtom/tcomment_vim'
Plug 'ammarnajjar/vim-code-dark'
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
" => fzf ---------------- {{{2
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG :Ag <C-R><C-A><CR>
nnoremap <silent> <Leader>'  :Marks<CR>

let g:fzf_layout = { 'down': '~40%', 'window': 'enew' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" show preview with colors using bat
if executable('bat')
    let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --color=always --style=header,grid --line-range :150 {}'"
else
endif

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

" use the silver searcher if exists
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore venv/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store  -g ""'
  set grepprg=ag\ --nogroup
else
    let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
endif
" }}}
"}}}
" vim: ft=vim:ts=4:sw=4:et:fdm=marker
