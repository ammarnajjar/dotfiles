--  => Header ---------------------- {{{
--  Fie: init.lua
--  Author: Ammar Najjar <najjarammar@protonmail.com>
--  Description: My neovim lua configurations file
--  }}}
-- => General ---------------------- {{{
--- Change leader key to ,
vim.g.mapleader = ','
local editor_root=vim.fn.expand("~/.config/nvim/")

local function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function file_exists(name)
  local fi=io.open(name,"r")
  if fi~=nil then io.close(fi) return true else return false end
end

local function call_shell(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return trim(result)
end

-- find the python3 binary for neovim
local which_python
if vim.env.VIRTUAL_ENV and vim.env.ASDF_DIR then
    which_python = "which -a python3 | head -n3 | tail -n1"
elseif vim.env.VIRTUAL_ENV then
   which_python = "which -a python3 | tail -n2 | head -n1"
elseif vim.env.ASDF_DIR then
    which_python = "which -a python3 | head -n2 | tail -n1"
else
    which_python = "which python3"
end
vim.g.python3_host_prog = call_shell(which_python)

vim.o.mouse = 'a' -------- Enable mouse usage (all modes)
vim.o.matchtime = 1 ------ for 1/10th of a second
vim.o.showmatch = true --- Show matching brackets.
vim.o.ignorecase = true -- Do case insensitive matching
vim.o.smartcase = true --- Do smart case matching
vim.o.hidden = true ------ Hide buffers when they are abandoned
vim.wo.number = true
vim.o.modelines = 2
vim.bo.modeline = true
vim.o.filetype = 'on'

-- Ignore compile/build files
vim.o.wildignore = vim.o.wildignore..table.concat({
    '*.o','*.obj','.git','*.rbc','*.pyc','__pycache__','*~','*.class',
    '*.git/*','*.hg/*','*.svn/*',
    '*/node_modules/*','*/.dist/*','*/.coverage/*'
})

vim.o.joinspaces = false -- when joining lines, don't insert two spaces after '.', '?' or '!'
vim.o.lazyredraw = true --- Don't redraw while executing macros

vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
vim.o.termguicolors = true

vim.o.writebackup = false --╮-- Turn backup off
vim.o.swapfile = false -----╯

vim.o.inccommand = 'nosplit' -- Live substitution

-- create undo file to keep history after closing the file
vim.bo.undofile = true
vim.fn.execute('set undodir='..editor_root..'/undo/')

vim.cmd('set shada^=%') ------- Remember info about open buffers on close

vim.g.switchbuf='useopen,usetab,newtab'
vim.g.showtabline = 2

vim.api.nvim_set_keymap('v', '<', '<gv', {}) --╮-- visual shifting
vim.api.nvim_set_keymap('v', '>', '>gv', {}) --╯

-- Edit the vimrc file
vim.api.nvim_set_keymap('n', '<leader>ev', '<cmd>tabe $MYVIMRC<CR>', {})

-- Opens a new tab with the current buffer's path
vim.api.nvim_set_keymap('n', '<leader>te', ':tabedit <C-r>=expand("%:p:h")<CR>/', {})

-- Switch CWD to the directory of the open buffer
vim.api.nvim_set_keymap('', '<leader>cd', '<cmd>cd %:p:h<CR>:pwd<CR>', {})

-- Toggle spell checking
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>setlocal spell!<CR>', {})

-- Terminal mode mappings
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {})
vim.api.nvim_set_keymap('n', '<leader>s', '<cmd>split term://zsh<CR><C-w><S-j><S-a>', {})
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>vsplit term://zsh<CR><C-w><S-l><S-a>', {})
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>tabedit term://zsh<CR><S-a>', {})
vim.cmd('autocmd TermOpen * setlocal nonumber statusline=%{b:term_title}')

-- view hidden characters by default
vim.o.listchars='tab:>-,space:·,nbsp:␣,trail:•,eol:↲,precedes:«,extends:»,conceal:┊'
vim.api.nvim_set_keymap('n', '<F2>', '<cmd>setlocal list! list? <CR>', { noremap = true })

-- Allow toggling between tabs and spaces
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>lua TabToggle()<cr>', {})
function TabToggle()
  if vim.bo.expandtab then
    vim.bo.expandtab = false
    vim.cmd('retab!')
  else
    vim.bo.expandtab = true
    vim.cmd('retab')
  end
end
-- a manual workaround for syntax highlight problems after retab
-- https://github.com/nvim-treesitter/nvim-treesitter#i-experience-weird-highlighting-issues-similar-to-78
vim.api.nvim_set_keymap('n', '<F4>', '<cmd>write | edit | TSBufEnable highlight<cr>', {})

-- Toggle ColumnColor
vim.api.nvim_command('autocmd filetype * hi ColorColumn ctermbg=black guibg=black')
vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>lua ToggleColorColumn()<CR>', { silent=true })
function ToggleColorColumn()
    vim.wo.colorcolumn = vim.wo.colorcolumn ~= '' and '' or '80'
end

-- Append modeline after last line in buffer
vim.api.nvim_set_keymap('n', '<Leader>ml', '<cmd>lua AppendModeline()<CR>', { silent=true })
function AppendModeline()
  local modeline = string.format(
    " vim: ft=%s ts=%d sw=%d %set %sai",
    vim.bo.filetype,
    vim.bo.tabstop,
    vim.bo.shiftwidth,
    vim.bo.expandtab and '' or 'no',
    vim.bo.autoindent and '' or 'no'
  )
  modeline = { string.format(vim.bo.commentstring, modeline) }
  vim.api.nvim_buf_set_lines(0, -1, -1, true, modeline)
end
--}}}
-- => Plugins ---------------- {{{
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('config')..'/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

-- Automatically run :PackerCompile whenever this file is updated
vim.api.nvim_command('autocmd BufWritePost init.lua PackerCompile')

-- load packer
vim.cmd('packadd packer.nvim')

require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim', opt = true }
  use { 'ammarnajjar/nvim-lspconfig' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-angular' }
  use { 'nvim-lua/completion-nvim' }
  use { 'junegunn/fzf' }
  use { 'junegunn/fzf.vim' }
  use { 'JoosepAlviste/nvim-ts-context-commentstring' }
  use { 'tpope/vim-commentary' }
  use { 'ammarnajjar/nvcode-color-schemes.vim' }
end)

-- colorscheme
vim.wo.cursorline = true

local function LightTheme()
  vim.o.background = 'light'
  vim.api.nvim_command([[
  autocmd BufEnter * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254
  autocmd BufEnter * highlight cursorlinenr term=bold ctermfg=black ctermbg=grey gui=bold guifg=white guibg=grey
  autocmd insertenter * highlight cursorlinenr term=bold ctermfg=black ctermbg=117 gui=bold guifg=white guibg=skyblue1
  autocmd insertenter * highlight cursorline cterm=none ctermfg=none ctermbg=none
  autocmd insertleave * highlight cursorlinenr term=bold ctermfg=black ctermbg=grey gui=bold guifg=white guibg=grey
  autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254]])
end
local function DarkTheme()
  vim.o.background = 'dark'
  vim.g.nvcode_termcolors = 256
  pcall(function() vim.cmd('colorscheme nvcode') end)  -- try colorscheme, fallback to default
  vim.api.nvim_command([[
  autocmd BufEnter * highlight CursorLineNr term=bold ctermfg=yellow ctermbg=black gui=bold guifg=yellow guibg=black
  autocmd InsertEnter * highlight CursorLineNr term=bold ctermfg=black ctermbg=74 gui=bold guifg=black guibg=skyblue1
  autocmd InsertLeave * highlight CursorLineNr term=bold ctermfg=yellow ctermbg=black gui=bold guifg=yellow guibg=black
  ]])
end

if vim.env.KONSOLE_PROFILE_NAME == 'light' or vim.env.ITERM_PROFILE == 'light' then
    LightTheme()
else
    DarkTheme()
end

-- completion
vim.cmd([[set completeopt=menuone,noinsert,noselect]])
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- fzf
vim.g.fzf_layout = { down='~40%', window='enew' }
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>Files<cr>', {})

-- grep text under cursor
vim.api.nvim_set_keymap('n', '<leader>rg', ':Rg <C-R><C-W><CR>', {})
vim.api.nvim_set_keymap('n', '<leader>ag', ':Ag <C-R><C-W><CR>', {})

-- [Buffers] Jump to the existing window if possible
vim.g.fzf_buffers_jump = 1

-- [Commits] Customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- [Tags] Command to generate tags file
vim.g.fzf_tags_command = 'ctags --append=no --recurse --exclude=blib --exclude=dist --exclude=node_modules --exclude=coverage --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

-- show preview with colors using bat if exists
if (vim.fn.executable('bat') ~= 0) then
  vim.env.FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --line-range :150 {}'"
end

-- use ripgrep if exists
if (vim.fn.executable('rg') ~= 0) then
  vim.env.FZF_DEFAULT_COMMAND = 'rg --hidden --files --glob="!.git/*" --glob="!venv/*" --glob="!coverage/*" --glob="!node_modules/*" --glob="!target/*" --glob="!__pycache__/*" --glob="!dist/*" --glob="!build/*" --glob="!*.DS_Store"'
  vim.g.grepprg='rg'
  -- else use the silver searcher if exists
elseif (vim.fn.executable('ag') ~= 0) then
  vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore venv/ --ignore coverage/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store  -g ""'
  vim.g.grepprg='ag --nogroup'
else
  -- else fallback to find
  vim.env.FZF_DEFAULT_COMMAND = [[find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path  'coverage/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null]]
end

LSP_LOADED = false
function LoadLsp()
  if (LSP_LOADED) then
    return
  end
  LSP_LOADED = true
  local nvim_lsp = require('lspconfig')

  local on_attach = function(client)
    require'completion'.on_attach(client)

    local bufnr = 0
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ee', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
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

    -- show diagnostics as a popup
    -- vim.api.nvim_command('autocmd CursorMoved <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
  end

  -- Use a loop to conveniently both setup defined servers
  -- and map buffer local keybindings when the language server attaches
  local servers = {
    "tsserver",
    "cssls",
    "pyright", -- check for compatible nodejs version => tail $(lua vim.lsp.get_log_path())
    "bashls",
    "gopls",
    "rls",
    "dockerls",
    "yamlls",
    "vimls",
  }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
  end

  -- omnisharp c#
  local pid = vim.fn.getpid()
  -- omnisharp install path => $HOME/.omnisharp
  local omnisharp_bin = vim.fn.stdpath('config')..'/../../.omnisharp/run'
  nvim_lsp["omnisharp"].setup {
      cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
      on_attach = on_attach
  }

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
  if (file_exists(lua_lsp_binary)) then
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
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- underline
    underline = true,

    -- virtual text
    virtual_text = true,

    -- signs
    signs = true,

    -- delay update diagnostics
    update_in_insert = false,
  }
  )
end

-- load lsp after colorscheme is applied on buffer
-- else messages will show up without colors (white)
vim.api.nvim_command('autocmd BufNewFile,BufReadPost * lua pcall(function() LoadLsp() end)')

-- nvim-treesitter
pcall(function()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = { enable = true }, ---- false will disable the whole extension
    context_commentstring = {
      enable = true,
    },
  }
end)
-- }}}
-- => autocmd configs ---------------------- {{{
local function indentUsing(indent)
  vim.bo.shiftwidth = indent
  vim.bo.tabstop = indent
  vim.bo.softtabstop = indent
end

local function pythonSetup()
  indentUsing(4)
  vim.bo.formatoptions = vim.bo.formatoptions..'croq'
  vim.bo.cinwords='if,elif,else,for,while,try,except,finally,def,class,with'
end

function FileTypeSetup()
  vim.bo.expandtab = true -------╮
  vim.bo.smartindent = true -----|-- Default 1 tab == 4 spaces
  indentUsing(4) ----------------╯

  local with_two_spaces = {
    'typescript', 'typescript.tsx', 'javascript', 'javascript.jsx',
    'lua', 'ruby', 'html', 'xhtml', 'htm', 'css', 'scss', 'php',
    'json', 'yml', 'yaml', 'dart',
  }
  if (vim.bo.filetype == 'python') then
    pythonSetup()
  else
    for _, filetype in pairs(with_two_spaces) do
      if (vim.bo.filetype == filetype) then
        indentUsing(2)
        break
      end
    end
  end
end

vim.api.nvim_command('autocmd BufEnter,BufNewFile * lua FileTypeSetup()')

-- highlight yanked text
vim.api.nvim_command('autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout=1000 } )')

-- highlight trailing whitespaces
vim.api.nvim_command([[
autocmd BufEnter *.* highlight TrailingWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd InsertEnter *.* match TrailingWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave *.* match TrailingWhitespace /\s\+$/
]])

-- delete trailing white spaces except for markdown
vim.api.nvim_command('autocmd BufWritePre *.* lua DeleteTrailingWS()')
function DeleteTrailingWS()
  if (vim.bo.filetype == 'markdown') then
    return
  end
  vim.api.nvim_command([[normal mz]])
  vim.cmd([[%s/\s\+$//ge]])
  vim.api.nvim_command([[normal 'z]])
end

-- Return to last edit position when opening files
vim.api.nvim_command([[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |  exe "normal! g`\"" | endif]])
-- }}}
-- => Statusline ---------------------- {{{
function TabsFound()
  local curline = vim.api.nvim_buf_get_lines(0, 0, 1000, false)
  for _, value in ipairs(curline) do
    if string.find(value, '\t+') then
      return '[tabs]'
    end
  end
  return ''
end

function HasPaste()
  return vim.o.paste and '[paste]' or ''
end

function GitBranch()
  local get_head_command = 'command -v git >/dev/null 2>&1 && git rev-parse --abbrev-ref HEAD'
  local git_head = call_shell(get_head_command)
  return git_head ~= '' and '[git:' ..call_shell(get_head_command)..']' or ''
end

local status_line = {
  "[%n]", ------------------------------------------------ buffer number
  "%<%.99f", --------------------------------------------- file name (F for full-path)
  "%m%r%h%w", -------------------------------------------- status flags
  "%#question#", --------------------------------------╮
  "%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}", --|-- warning for encoding not utf8
  "%*", -----------------------------------------------╯
  "%#errormsg#", -----------------------╮
  "%{luaeval('HasPaste()')}", ---------------------------- warning if paste mode is active
  "%{luaeval('TabsFound()')}", --------------------------- warning if tabs exist
  "%*", --------------------------------╯
  "%#warningmsg#", ---------------------╮
  GitBranch(), ------------------------------------------- git branch
  "%*", --------------------------------╯
  "%=", -------------------------------------------------- right align
  "%#directory#", ----------------------╮
  "%y", -------------------------------------------------- buffer file type
  "%{&ff!='unix'?'['.&ff.']':''}", ----------------------- fileformat not unix
  "%*", --------------------------------╯
  "%#warningmsg#", ---------------------╮
  " %c%V,%l/", ------------------------------------------- column and row number
  "%*", --------------------------------╯
  "%L %P", ----------------------------------------------- total lines, position in file
}
vim.o.statusline = table.concat(status_line)
-- }}}
-- => local.lua  ---------------------- {{{
local localFile = editor_root..'local.lua'
if (file_exists(localFile)) then
  loadfile(localFile)()
end
-- }}}
-- vim: ft=lua ts=2 sw=2 et ai
