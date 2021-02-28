--- Change leader key to ,
vim.g.mapleader = ','
local editor_root=vim.fn.expand("~/.config/nvim/")

vim.o.mouse = 'a'-------- Enable mouse usage (all modes)
vim.o.matchtime = 1------ for 1/10th of a second
vim.o.showmatch = true--- Show matching brackets.
vim.o.ignorecase = true-- Do case insensitive matching
vim.o.smartcase = true--- Do smart case matching
vim.o.hidden = true------ Hide buffers when they are abandoned
vim.o.modelines = 3
vim.bo.modeline = true
vim.wo.number = true

-- Ignore compile/build files
vim.cmd [[set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,*~,*.class]]
vim.cmd [[set wildignore+=*/.git/*,*/.hg/*,*/.svn/*]]
vim.cmd [[set wildignore+=*/node_modules/*,*/.dist/*,*/.coverage/*]]

-- when joining lines, don't insert two spaces after '.', '?' or '!'
vim.o.joinspaces = false

-- Don't redraw while executing macros
vim.o.lazyredraw = true

vim.o.termguicolors = true

-- Turn backup off
vim.o.writebackup = false
vim.o.swapfile = false

-- Default 1 tab == 4 spaces
local indent = 4
vim.bo.expandtab = true
vim.bo.smartindent = true
vim.bo.shiftwidth = indent
vim.bo.tabstop = indent

-- Live substitution
vim.o.inccommand = 'nosplit'

-- create undo file to keep history after closing the file
vim.cmd [[set undofile]]
vim.cmd [[set undolevels=1000]]
vim.fn.execute([[set undodir=]]..editor_root..'/undo/')

-- Remember info about open buffers on close
vim.cmd [[set shada^=%]]

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- visual shifting (does not exit Visual mode)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Edit the vimrc file
map('n', '<leader>ev', '<cmd>tabe $MYVIMRC<CR>')
-- Opens a new tab with the current buffer's path
map('n', '<leader>te', '<cmd>tabedit<CR>')

-- nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>

-- Switch CWD to the directory of the open buffer
map('', '<leader>cd', '<cmd>cd %:p:h<CR>:pwd<CR>')

-- Toggle spell checking
map('n', '<leader>ss', '<cmd>setlocal spell!<CR>')

-- Terminal mode mappings
map('t', '<ESC>', '<C-\\><C-n>')
map('n', '<leader>s', '<cmd>split term://zsh<CR><C-w><S-j><S-a>')
map('n', '<leader>v', '<cmd>vsplit term://zsh<CR><C-w><S-l><S-a>')
map('n', '<leader>t', '<cmd>tabedit term://zsh<CR><S-a>')
vim.cmd('autocmd TermOpen * setlocal statusline=%{b:term_title}')

-- => auto install packer ---------------- {{{1
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('config')..'/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand:
vim.cmd [[ autocmd BufWritePost plugins.lua PackerCompile ]]

-- load packer
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use { 'wbthomason/packer.nvim', opt = true }
    use { 'nvim-treesitter/nvim-treesitter'}
    use { 'neovim/nvim-lspconfig' }
    use { 'nvim-lua/completion-nvim' }
    use { 'dstein64/nvim-scrollview' }
    use { 'junegunn/fzf' }
    use { 'junegunn/fzf.vim' }
    use { 'tpope/vim-fugitive' }
    use { 'tomtom/tcomment_vim' }
    use { 'ammarnajjar/vim-code-dark' }
end)
-- }}}
-- => colorscheme ---------------- {{{1
vim.cmd [[colorscheme codedark]]
-- }}}
-- => completion ---------------- {{{1
vim.cmd [[set completeopt=menuone,noinsert,noselect]]
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
-- }}}
-- => fzf ---------------- {{{1
vim.g.fzf_layout = { down='~40%', window='enew' }

map('n', '<C-p>', '<cmd>Files<cr>')

-- grep text under cursor
map('n', '<leader>rg', '<cmd>Rg <C-R><C-W><CR>')
map('n', '<leader>ag', '<cmd>Ag <C-R><C-W><CR>')

-- [Buffers] Jump to the existing window if possible
vim.g.fzf_buffers_jump = 1

-- [B]Commits] Customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- show preview with colors using bat
if vim.fn.executable('bat') then
    vim.cmd [[let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --line-range :150 {}'"]]
end

-- [Tags] Command to generate tags file
vim.g.fzf_tags_command = 'ctags --append=no --recurse --exclude=blib --exclude=dist --exclude=node_modules --exclude=coverage --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

-- use ripgrep if exists
if vim.fn.executable('rg') then
    vim.cmd [[let $FZF_DEFAULT_COMMAND = 'rg --hidden --files --glob="!.git/*" --glob="!venv/*" --glob="!coverage/*" --glob="!node_modules/*" --glob="!target/*" --glob="!__pycache__/*" --glob="!dist/*" --glob="!build/*" --glob="!*.DS_Store"']]
    vim.cmd [[set grepprg=rg]]
    -- else use the silver searcher if exists
elseif vim.fn.executable('ag') then
    vim.cmd [[let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore venv/ --ignore coverage/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store	-g ""']]
    vim.cmd [[set grepprg=ag\ --nogroup]]
else
    vim.cmd [[let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path  'coverage/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o	-type f -print -o -type l -print 2> /dev/null"]]
end
-- }}}
-- => treesitter  ---------------- {{{1
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}
-- }}}

local nvim_lsp = require('lspconfig')

local on_attach = function(client)
    require'completion'.on_attach(client)

    local bufnr = 0
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ee', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    buf_set_keymap('n', '<leader>ai', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    buf_set_keymap('n', '<leader>ao', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", '<leader>=', "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {
    "angularls",
    "tsserver",
    "cssls",
    "pyls",
    "bashls",
    "gopls",
    "rls",
    "dockerls",
    "yamlls",
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end

-- setup lsp for lua
local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
else
    print("Unsupported system for lua lsp")
end

-- set the path to the sumneko installation
-- lua_lsp_root_path => $HOME/.config/nvim/lsp/lua-language-server
local lua_lsp_root_path = vim.fn.stdpath('config')..'/lsp/lua-language-server'
local lua_lsp_binary = lua_lsp_root_path.."/bin/"..system_name.."/lua-language-server"
nvim_lsp["sumneko_lua"].setup {
    cmd = { lua_lsp_binary, "-E", lua_lsp_root_path .. "/main.lua" },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim', 'use' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
    on_attach = on_attach
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    -- delay update diagnostics
    update_in_insert = false,
}
)

local function file_exists(name)
    local fi=io.open(name,"r")
    if fi~=nil then io.close(fi) return true else return false end
end

-- extend using local moddule
local localFile = editor_root..'local.lua'
if (file_exists(localFile)) then
    loadfile(localFile)()
end

-- highlight yanked text
vim.api.nvim_command([[autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout=500} )]])

-- highlight trailing whitespaces
vim.api.nvim_command([[
autocmd BufEnter *.* :highlight TrailingWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd InsertEnter *.* :match TrailingWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave *.* :match TrailingWhitespace /\s\+$/
]])

-- delete trailing white spaces except for markdown
vim.api.nvim_command([[autocmd BufWrite *.* lua DeleteTrailingWS()]])
function DeleteTrailingWS()
    if (vim.bo.filetype == 'markdown') then
        return
    end
    vim.fn.nvim_command([[normal mz]])
    vim.cmd([[%s/\s\+$//ge]])
    vim.fn.nvim_command([[normal 'z]])
end

-- view hidden characters like spaces and tabs
map('n', '<F3>', [[<cmd>setlocal listchars=tab:>\-,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:» list! list? <CR>]])

-- Allow toggling between tabs and spaces
-- This seems to trigger a bug https://github.com/neovim/neovim/issues/12861
map('n', '<F4>', '<cmd>lua TabToggle()<cr>')
function TabToggle()
    if vim.bo.expandtab then
        vim.bo.expandtab = false
        vim.cmd('retab!')
    else
        vim.bo.expandtab = true
        vim.cmd('retab')
    end
end

function TabsFound()
    local curline = vim.api.nvim_buf_get_lines(0, 0, 1000, false)
    for _, value in ipairs(curline) do
        if string.find(value, '\t+') then
            return '[tabs]'
        end
    end
    return ''
end

-- => Statusline ---------------------- {{{
local git_stl = vim.fn.exists('g:loaded_fugitive') and "%{FugitiveStatusline()}" or ''
local status_line = {
    "[%n]",-----------------------------------------------buffer number
    "%<%.99f",--------------------------------------------file name, F for full-path
    "%m%r%h%w",-------------------------------------------status flags
    "%#question#",----------------------------------------warning for encoding not utf8
    "%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}",
    "%#warningmsg#",---------------|
    "%{luaeval('TabsFound()')}",---|--------------------- warning if tabs exist
    "%*",--------------------------|
    git_stl,----------------------------------------------fugitive statusline
    "%=",-------------------------------------------------right align
    "%y",-------------------------------------------------buffer file type
    "%#directory#",
    "%{&ff!='unix'?'['.&ff.']':''}",----------------------fileformat not unix
    "%*",
    " %c%V,%l/",-----------------------------------------column and row Number
    "%L %P",---------------------------------------------total lines, position in file
}
vim.wo.statusline = table.concat(status_line)
-- }}}

-- TODO
-- * helper functions
-- * LOOK INTO SESSION MANAGEMENT IN NVIM
