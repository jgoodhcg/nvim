--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- Disable netrw — nvim-tree owns directory opens.
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- [[ Setting options ]]
  --  See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Folding: manual folds, all open at start.
  vim.opt.foldmethod = 'manual'
  vim.opt.foldenable = true
  vim.opt.foldlevelstart = 99

  vim.opt.termguicolors = true

  -- Make line numbers default
  vim.o.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  -- vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true

  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- ============================================================
-- SECTION 1.5: USER CUSTOMIZATIONS
-- Custom helpers, user commands, filetype autocmds, custom keymaps
-- (anything that doesn't depend on a plugin — plugin-coupled tweaks
-- live alongside the plugin's setup further down)
-- ============================================================
do
  -- [[ Helper functions ]]

  -- Find a Clojure `(ns ...)` form on the current line (or by scanning the
  -- buffer) and copy the namespace to the system clipboard. Handles map
  -- metadata, simple metadata tokens, and bare ns forms.
  function FindClojureNamespaceAndCopy()
    local ns_patterns = {
      '%(ns%s+%^%b{}%s*([%w%.%-/]+)', -- map metadata: (ns ^{:k v} my.ns)
      '%(ns%s+%^%S+%s*([%w%.%-/]+)', -- simple metadata: (ns ^:private my.ns)
      '%(ns%s+([%w%.%-/]+)', -- no metadata: (ns my.ns)
    }

    local function extract_namespace(s)
      for _, p in ipairs(ns_patterns) do
        local m = s:match(p)
        if m then return m end
      end
      return nil
    end

    local namespace = extract_namespace(vim.api.nvim_get_current_line())
    if namespace then
      vim.fn.setreg('+', namespace)
      print('Copied to clipboard: ' .. namespace)
      return
    end

    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
      namespace = extract_namespace(line)
      if namespace then
        vim.fn.setreg('+', namespace)
        print('Copied to clipboard: ' .. namespace)
        return
      end
    end

    print 'No Clojure namespace declaration found'
  end

  -- Open (or reuse) a Clojure scratch buffer pre-populated with a
  -- shadow-cljs / Conjure starter template.
  function OpenClojureScratchBuffer()
    local buf
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b):match '.*ClojureScratch$' then
        buf = b
        break
      end
    end

    if not buf then
      buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_name(buf, 'ClojureScratch-' .. os.date '%Y%m%d%H%M%S')
      vim.api.nvim_buf_set_option(buf, 'filetype', 'clojure')
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        '(ns user',
        '  (:require',
        '    [shadow.cljs.devtools.api :as shadow]',
        '    [shadow.cljs.devtools.server :as server]))',
        '',
        ';; Clojure Scratch Buffer',
        ';; Created: ' .. os.date '%Y-%m-%d %H:%M:%S',
        '',
        ';; Common REPL commands:',
        ';;',
        ';; Start shadow-cljs:',
        ';;   (server/start!)',
        ';;   (shadow/watch :app)',
        ';;   (shadow/repl :app)',
        ';;',
        ';; Reload current namespace in REPL:',
        ";;   (require 'your.ns :reload)",
        '',
        '(comment',
        '  ;; Your code here',
        '  )',
        '',
      })
    end

    vim.api.nvim_set_current_buf(buf)
    print 'Opened Clojure scratch buffer'
  end

  -- Open (or reuse) a Markdown scratch buffer with a project/branch header.
  function OpenMarkdownScratchBuffer()
    local buf
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b):match '.*MarkdownScratch$' then
        buf = b
        break
      end
    end

    if not buf then
      buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_name(buf, 'MarkdownScratch-' .. os.date '%Y%m%d%H%M%S' .. '.md')
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

      local cwd = vim.fn.getcwd()
      local project_name = vim.fn.fnamemodify(cwd, ':t')
      local git_branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
      if vim.v.shell_error ~= 0 then git_branch = '' end

      local lines = {
        '<!-- Markdown Scratch Buffer -->',
        '<!-- Created: ' .. os.date '%Y-%m-%d %H:%M:%S' .. ' -->',
        '<!-- Project: ' .. project_name .. ' -->',
      }
      if git_branch ~= '' then table.insert(lines, '<!-- Branch: ' .. git_branch .. ' -->') end
      vim.list_extend(lines, { '', '# Scratch Notes', '', '' })

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    vim.api.nvim_set_current_buf(buf)
    print 'Opened Markdown scratch buffer'
  end

  -- Copy current file path relative to the git root (or cwd) to the clipboard.
  function CopyFilePathFromRoot()
    local filepath = vim.fn.expand '%:p'
    local git_root = vim.fn.system('git -C ' .. vim.fn.expand '%:p:h' .. ' rev-parse --show-toplevel'):gsub('\n', '')
    if vim.v.shell_error ~= 0 then git_root = vim.fn.getcwd() end

    local relative_path = filepath:gsub('^' .. vim.fn.escape(git_root, '%-%.()[]{}\\^$+*') .. '/', '')
    vim.fn.setreg('+', relative_path)
    print('Copied to clipboard: ' .. relative_path)
  end

  -- [[ User commands ]]
  vim.api.nvim_create_user_command('ClojureScratch', OpenClojureScratchBuffer, { desc = 'Open a new Clojure scratch buffer' })
  vim.api.nvim_create_user_command('MarkdownScratch', OpenMarkdownScratchBuffer, { desc = 'Open a new Markdown scratch buffer' })

  -- [[ Filetype autocmds ]]

  -- Spell + soft-wrap for prose filetypes.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'text', 'gitcommit', 'fountain' },
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'en_us'
      vim.opt_local.wrap = true
    end,
  })

  -- TypeScript / JavaScript: 2-space soft tabs.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end,
  })

  -- Go: real tabs at width 8 (gofmt convention); hide whitespace markers since
  -- tabs everywhere makes them noisy. Toggle back with <leader>tw if needed.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
      vim.opt_local.expandtab = false
      vim.opt_local.tabstop = 8
      vim.opt_local.shiftwidth = 8
      vim.opt_local.softtabstop = 8
      vim.opt_local.list = false
    end,
  })

  -- Clojure-buffer-local keymaps.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'clojure',
    callback = function()
      vim.keymap.set('n', '<leader>cn', FindClojureNamespaceAndCopy, { buffer = true, desc = '[C]opy Clojure [N]amespace to clipboard' })
      vim.keymap.set('n', '<leader>n', function() vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } } } end, { buffer = true, desc = 'Clean [N]amespace' })
      vim.keymap.set('n', '<leader>cs', OpenClojureScratchBuffer, { buffer = true, desc = '[C]lojure [S]cratch buffer' })
    end,
  })

  -- [[ Custom global keymaps ]]

  vim.keymap.set('n', '<leader>cp', CopyFilePathFromRoot, { desc = '[C]opy file [P]ath from project root' })
  vim.keymap.set('n', '<leader>ms', OpenMarkdownScratchBuffer, { desc = '[M]arkdown [S]cratch buffer' })

  -- Spell/grammar/zen toggles.
  vim.keymap.set('n', '<leader>ts', function()
    vim.opt_local.spell = not vim.opt_local.spell:get()
    print(vim.opt_local.spell:get() and 'Spell checking enabled' or 'Spell checking disabled')
  end, { desc = '[T]oggle [S]pell checking' })

  vim.keymap.set('n', '<leader>tw', function()
    vim.opt_local.list = not vim.opt_local.list:get()
    print(vim.opt_local.list:get() and 'Whitespace markers enabled' or 'Whitespace markers disabled')
  end, { desc = '[T]oggle [W]hitespace markers' })

  -- ltex auto-starts on prose buffers (see Section 5). This toggle is for
  -- when you want it temporarily quiet. Disabled state:
  -- `vim.lsp.enable(name, false)` clears the auto-attach flag, then
  -- `client:stop()` kills the running instance. Re-enable just reverses both
  -- by calling `vim.lsp.enable(name)` (which re-attaches to existing buffers).
  vim.keymap.set('n', '<leader>tg', function()
    local clients = vim.lsp.get_clients { name = 'ltex' }
    if #clients == 0 then
      vim.lsp.enable 'ltex'
      print 'Grammar checking enabled'
    else
      vim.lsp.enable('ltex', false)
      for _, client in ipairs(clients) do
        client:stop()
      end
      print 'Grammar checking disabled'
    end
  end, { desc = '[T]oggle [G]rammar checking' })

  vim.keymap.set('n', '<leader>tz', function()
    local ok, zen = pcall(require, 'zen-mode')
    if not ok then
      vim.notify('Zen Mode is not available', vim.log.levels.ERROR)
      return
    end
    zen.toggle()
  end, { desc = '[T]oggle [Z]en (with Twilight)' })

  -- Spell navigation rebinds — same behavior, but `desc` makes them
  -- discoverable in which-key.
  vim.keymap.set('n', ']s', ']s', { desc = 'Next misspelled word' })
  vim.keymap.set('n', '[s', '[s', { desc = 'Previous misspelled word' })
  vim.keymap.set('n', 'z=', 'z=', { desc = 'Suggest spelling corrections' })
  vim.keymap.set('n', 'zw', 'zw', { desc = 'Mark word as misspelled' })

  -- `zg` does two things: vim's native dictionary add, then dispatch to
  -- ltex_extra's client-side handler so ltex's hint disappears immediately
  -- AND is persisted. ltex_extra registers `_ltex.addToDictionary` in
  -- vim.lsp.commands — that's the path the gra-menu's "Add to dictionary"
  -- uses. Sending the command via workspace/executeCommand to the server
  -- skips ltex_extra entirely (the server doesn't implement it).
  vim.keymap.set('n', 'zg', function()
    local word = vim.fn.expand '<cword>'
    if word == '' then return end

    vim.cmd 'normal! zg' -- vim spell: append to .add + recompile .spl

    local handler = vim.lsp.commands['_ltex.addToDictionary']
    if not handler then return end
    for _, client in ipairs(vim.lsp.get_clients { name = 'ltex' }) do
      handler({
        command = '_ltex.addToDictionary',
        arguments = {
          { uri = vim.uri_from_bufnr(0), words = { ['en-US'] = { word } } },
        },
      }, { bufnr = 0, client_id = client.id })
    end
  end, { desc = 'Add word to dictionary (vim spell + ltex)' })

  -- Window management.
  vim.keymap.set('n', '<leader>wh', function() vim.cmd 'wincmd h' end, { desc = 'Move to left window' })
  vim.keymap.set('n', '<leader>wj', function() vim.cmd 'wincmd j' end, { desc = 'Move to lower window' })
  vim.keymap.set('n', '<leader>wk', function() vim.cmd 'wincmd k' end, { desc = 'Move to upper window' })
  vim.keymap.set('n', '<leader>wl', function() vim.cmd 'wincmd l' end, { desc = 'Move to right window' })
  vim.keymap.set('n', '<leader>ws', function() vim.cmd 'wincmd s' end, { desc = 'Split horizontally' })
  vim.keymap.set('n', '<leader>wv', function() vim.cmd 'wincmd v' end, { desc = 'Split vertically' })
  vim.keymap.set('n', '<leader>wq', function() vim.cmd 'wincmd q' end, { desc = 'Close window' })
  vim.keymap.set('n', '<leader>wo', function() vim.cmd 'wincmd o' end, { desc = 'Close all other windows' })
  vim.keymap.set('n', '<leader>w=', function() vim.cmd 'wincmd =' end, { desc = 'Equalize window sizes' })
  vim.keymap.set('n', '<leader>w|', function() vim.cmd 'wincmd |' end, { desc = 'Maximize window width' })
  vim.keymap.set('n', '<leader>w_', function() vim.cmd 'wincmd _' end, { desc = 'Maximize window height' })
  vim.keymap.set('n', '<leader>wd', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })
  vim.keymap.set('n', '<leader>wD', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })
end

-- ============================================================
-- SECTION 2: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is a new plugin manager built into Neovim,
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()
  --
  --
  --  Throughout the rest of the config there will be examples
  --  of how to install and configure plugins using `vim.pack`.
  --
  --  In this section we set up some autocommands to run build
  --  steps for certain plugins after they are installed or updated.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Because lua is a real programming language, you can also have some logic to your installation -
  -- like only installing a plugin if a condition is met.
  --
  -- Here we only install `nvim-web-devicons` (which adds pretty icons) if we have a Nerd Font,
  -- since otherwise the icons won't display properly.
  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
  --
  -- See `:help gitsigns` to understand what each configuration key does.
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>tz', desc = 'Zen Mode' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { '<leader>w', group = '[W]indow' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = false }, -- Disable italics in comments
    },
  }

  -- Load the colorscheme here.
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.cmd.colorscheme 'tokyonight-night'

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  -- Simple and easy statusline.
  --  You could remove this setup call if you don't like it,
  --  and try some other statusline plugin
  local statusline = require 'mini.statusline'
  -- Set `use_icons` to true if you have a Nerd Font
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we set the section for
  -- cursor location to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  -- ... and there is more!
  --  Check out: https://github.com/nvim-mini/mini.nvim
end

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
  -- [[ Fuzzy Finder (files, lsp, etc) ]]
  --
  -- Telescope is a fuzzy finder that comes with a lot of different things that
  -- it can fuzzy find! It's more than just a "file finder", it can search
  -- many different aspects of Neovim, your workspace, LSP, and more!
  --
  -- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
  -- so feel free to experiment and see what you like!
  --
  -- The easiest way to use Telescope, is to start by doing something like:
  --  :Telescope help_tags
  --
  -- After running this command, a window will open up and you're able to
  -- type in the prompt window. You'll see a list of `help_tags` options and
  -- a corresponding preview of the help.
  --
  -- Two important keymaps to use while in Telescope are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Telescope picker. This is really useful to discover what Telescope can
  -- do as well as how to actually do it!

  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  -- NOTE: You can install multiple plugins at once
  vim.pack.add(telescope_plugins)

  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      hidden = false,
      file_ignore_patterns = {},
      mappings = {
        i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      },
    },
    pickers = {
      find_files = { hidden = false, no_ignore = false },
      live_grep = {},
    },
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  -- Re-call telescope.setup() to flip `hidden`/`no_ignore` together across the
  -- defaults and pickers. State lives on _G so toggling is idempotent across
  -- reloads.
  _G.telescope_toggle_hidden_files = function()
    if _G.telescope_showing_hidden == nil then _G.telescope_showing_hidden = false end
    _G.telescope_showing_hidden = not _G.telescope_showing_hidden
    local on = _G.telescope_showing_hidden

    local config = {
      defaults = {
        mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine' } },
        hidden = on,
        no_ignore = on,
      },
      pickers = {
        find_files = { hidden = on, no_ignore = on },
        live_grep = {},
      },
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }
    if on then
      config.pickers.live_grep.additional_args = function() return { '--hidden', '--no-ignore' } end
    end

    require('telescope').setup(config)
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    print(on and 'Telescope: Now showing hidden and git-ignored files' or 'Telescope: Now hiding hidden and git-ignored files')
  end

  -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  -- If you later switch picker plugins, this is where to update these mappings.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Find references for the word under your cursor.
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

      -- Jump to the implementation of the word under your cursor.
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

      -- Jump to the definition of the word under your cursor.
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

      -- Fuzzy find all the symbols in your current document.
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

      -- Fuzzy find all the symbols in your current workspace.
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

      -- Jump to the type of the word under your cursor.
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Override default behavior and theme when searching
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set(
    'n',
    '<leader>s/',
    function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    { desc = '[S]earch [/] in Open Files' }
  )

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

  -- Live-grep the unnamed yank register (whitespace collapsed) — convenient for
  -- "find every other place this thing I just yanked appears".
  vim.keymap.set('n', '<leader>sp', function()
    local yanked = vim.fn.getreg '"'
    if yanked and yanked ~= '' then
      local cleaned = yanked:gsub('\n', ' '):gsub('%s+', ' '):match '^%s*(.-)%s*$'
      builtin.live_grep { default_text = cleaned }
    else
      print 'No text in yank register'
    end
  end, { desc = '[S]earch for yanked text ([P]aste)' })

  -- Toggle hidden + git-ignored files across telescope (renamed from <leader>ts
  -- to avoid colliding with the spell toggle).
  vim.keymap.set('n', '<leader>sH', function() _G.telescope_toggle_hidden_files() end, { desc = '[S]earch toggle [H]idden files' })
end

-- ============================================================
-- SECTION 5: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  ---@type table<string, vim.lsp.Config>
  local servers = {
    stylua = {}, -- Used to format Lua code

    gopls = {},
    ts_ls = {},
    rust_analyzer = {},
    clojure_lsp = {},

    -- Grammar / spell checking for prose. Auto-attaches to markdown/text/etc.
    -- Toggle off temporarily with <leader>tg when its hints get noisy.
    -- Dictionary persistence is handled by ltex_extra (see Section 8.5) — the
    -- `dictionary` table here is the in-memory starting set; ltex_extra
    -- populates it from disk on attach via `init_check`.
    ltex = {
      settings = {
        ltex = {
          language = 'en-US',
          disabledRules = {},
          hiddenFalsePositives = {},
          dictionary = { ['en-US'] = {} },
        },
      },
    },

    jsonls = {
      settings = {
        json = { validate = { enable = true } },
      },
    },

    -- Special Lua Config, as recommended by neovim help docs
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Automatically install LSPs and related tools to stdpath for Neovim
  require('mason').setup {}

  -- Ensure the servers and tools above are installed
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, you can run
  --    :Mason
  --
  -- You can press `g?` for help in this menu.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'clj-kondo',
    'cljfmt',
    'prettier',
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    -- The legacy `autostart = false` field is not honored by vim.lsp.enable(),
    -- so we gate it ourselves. No server currently uses it; pattern is here
    -- in case you want to add an opt-out server later (set autostart=false on
    -- the config, then enable it on demand via `vim.lsp.enable(name)`).
    if server.autostart ~= false then vim.lsp.enable(name) end
  end
end

-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    -- Disable-list rather than allow-list: format on save unless the filetype
    -- is on this list. C/C++ have no standardized style, Clojure is formatted
    -- manually via <leader>f / <leader>j, TS/JS are formatted by their LSP on
    -- save in some projects and we let that be authoritative.
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true, clojure = true, typescript = true, javascript = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      clojure = { 'cljfmt' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      typescript = { 'prettier' },
      javascript = { 'prettier' },
      html = { 'prettier' },
    },
    -- Custom zprint variant used by <leader>j to format Clojure maps/bindings
    -- with justified key alignment + namespace sorting.
    formatters = {
      zprint_justified = {
        command = 'zprint',
        args = { '{:style [:respect-nl :justified :ns-justify :sort-dependencies :sort-require]}' },
        stdin = true,
      },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer or selection' })

  -- Clojure-only: run zprint with justified pairs.
  vim.keymap.set({ 'n', 'v' }, '<leader>j', function()
    if vim.bo.filetype == 'clojure' then require('conform').format { async = true, formatters = { 'zprint_justified' } } end
  end, { desc = '[J]ustify Clojure maps/bindings' })
end

-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]

  -- NOTE: You can also specify plugin using a version range for its git tag.
  --  See `:help vim.version.range()` for more info
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'default',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      per_filetype = {
        sql = { 'lsp', 'path', 'snippets', 'lazydev', 'dadbod' },
        mysql = { 'lsp', 'path', 'snippets', 'lazydev', 'dadbod' },
        plsql = { 'lsp', 'path', 'snippets', 'lazydev', 'dadbod' },
        dbout = { 'dadbod' },
      },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 8: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  --  Used to highlight, edit, and navigate code
  --
  --  See `:help nvim-treesitter-intro`

  -- NOTE: You can also specify a branch or a specific commit
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Ensure basic parsers are installed
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 8.5: USER PLUGINS
-- All extras on top of kickstart. Everything eager-loaded — see
-- :help vim.pack and `vim.loader.enable()` for why startup cost is fine.
-- Where globals need to be set before a plugin sources its vim files,
-- the assignment sits directly above the corresponding vim.pack.add.
-- ============================================================
do
  -- lazydev — load nvim's runtime types into lua_ls and provide a blink.cmp
  -- source for nvim Lua development. blink.cmp's providers reference lazydev
  -- by module string; the actual require happens on first use, so setup
  -- order here vs Section 7 doesn't matter.
  vim.pack.add { gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }

  -- ----- File tree -----
  vim.pack.add {
    gh 'nvim-tree/nvim-tree.lua',
    gh 'nvim-tree/nvim-web-devicons',
  }
  require('nvim-tree').setup {
    sort = { sorter = 'case_sensitive' },
    view = { width = 35 },
    renderer = { group_empty = true },
    filters = {
      dotfiles = true,
      git_ignored = true,
    },
    actions = {
      open_file = { quit_on_open = true },
    },
  }

  vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Tree' })
  vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFile<CR>', { desc = 'Find Current File in Tree' })
  vim.keymap.set('n', '<leader>eh', function()
    require('nvim-tree.api').tree.toggle_hidden_filter()
    print 'Toggled hidden files'
  end, { desc = 'Toggle Hidden Files in Tree' })
  vim.keymap.set('n', '<leader>ei', function()
    require('nvim-tree.api').tree.toggle_gitignore_filter()
    print 'Toggled git-ignored files'
  end, { desc = 'Toggle Git-Ignored Files in Tree' })

  -- ----- Symbol outline -----
  vim.pack.add { gh 'hedyhli/outline.nvim' }
  require('outline').setup {
    outline_window = { position = 'right', relative_width = true, width = 45, auto_close = true },
    keymaps = { close = { '<Esc>', 'q' } },
  }
  vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle Symbols Outline' })

  -- ----- Conjure (Clojure REPL) -----
  -- Conjure reads these globals as it sources, so they must be set first.
  vim.g['conjure#mapping#prefix'] = ',c'
  vim.g['conjure#log#winheight'] = 12
  vim.pack.add { gh 'Olical/conjure' }

  -- ----- vim-sexp + paredit helpers -----
  -- Intentional: disable nearly every default mapping. The bindings we use
  -- daily are slurp/barf via vim-sexp-mappings-for-regular-people and a
  -- subset of vim-sexp's defaults that don't appear in the disable list.
  -- (Audit before changing — this list was tuned by hand.)
  vim.g.sexp_mappings = {
    sexp_round_head_wrap_element = '',
    sexp_round_tail_wrap_element = '',
    sexp_square_head_wrap_element = '',
    sexp_square_tail_wrap_element = '',
    sexp_curly_head_wrap_element = '',
    sexp_curly_tail_wrap_element = '',
    sexp_round_head_wrap_list = '',
    sexp_round_tail_wrap_list = '',
    sexp_square_head_wrap_list = '',
    sexp_square_tail_wrap_list = '',
    sexp_curly_head_wrap_list = '',
    sexp_curly_tail_wrap_list = '',
    sexp_splice_list = '',
    sexp_raise_list = '',
    sexp_raise_element = '',
    sexp_swap_list_backward = '',
    sexp_swap_list_forward = '',
    sexp_swap_element_backward = '',
    sexp_swap_element_forward = '',
    sexp_emit_head_element = '',
    sexp_emit_tail_element = '',
    sexp_capture_head_element = '',
    sexp_capture_tail_element = '',
  }
  vim.g.sexp_mappings_for_regular_people = {
    sexp_capture_next_element = '', -- <(
    sexp_capture_prev_element = '', -- >)
  }
  vim.pack.add {
    gh 'tpope/vim-repeat',
    gh 'tpope/vim-surround',
    gh 'guns/vim-sexp',
    gh 'tpope/vim-sexp-mappings-for-regular-people',
  }

  -- ----- Database (dadbod) -----
  -- Global must be set before vim-dadbod-ui sources (same pattern as conjure
  -- and vim-sexp above). Trigger commands: :DBUI, :DBUIToggle.
  vim.g.db_ui_use_nerd_fonts = 1
  vim.pack.add {
    gh 'tpope/vim-dadbod',
    gh 'kristijanhusak/vim-dadbod-ui',
    gh 'kristijanhusak/vim-dadbod-completion',
  }

  -- ----- Fountain (screenwriting) -----
  vim.pack.add { gh '00msjr/nvim-fountain' }
  require('nvim-fountain').setup {
    keymaps = { next_scene = ']]', prev_scene = '[[', uppercase_line = '<S-CR>' },
    export = { pdf = { options = '--overwrite --font Courier' } },
  }

  -- ----- Markdown helpers -----
  vim.pack.add { gh 'preservim/vim-markdown' }

  -- ----- ltex_extra: persist ltex dictionary / disabled rules / false positives -----
  -- ltex_extra registers handlers for the `_ltex.*` workspace commands the
  -- code-action menu invokes, so adds survive restart. We point it at
  -- ~/.config/nvim/spell (the same dir vim uses for `zg`/`zw` words).
  --
  -- Single-source-of-truth bootstrap: ltex_extra hard-codes its dictionary
  -- filename as `dictionary.<lang>.txt`, while vim's spell uses `en.utf-8.add`.
  -- We symlink the ltex name to the vim name so both tools read/write the
  -- same physical file. Idempotent — only acts on a fresh machine where the
  -- symlink doesn't already exist.
  --
  -- Caveat: when ltex adds a word via "gra → Add to dictionary", it lands in
  -- the shared file immediately and ltex stops flagging it. But vim's spell
  -- checker reads from a compiled `.spl` binary, not the `.add` text file —
  -- and that `.spl` only regenerates when vim writes the spellfile (which
  -- `zg` triggers automatically). So a word added via ltex will still show
  -- vim's spell squiggle until you next restart nvim (or `zg` any other
  -- word, which forces a recompile that pulls in ltex-added entries too).
  do
    local spell_dir = vim.fn.stdpath 'config' .. '/spell'
    vim.fn.mkdir(spell_dir, 'p')
    local vim_dict = spell_dir .. '/en.utf-8.add'
    local ltex_dict = spell_dir .. '/dictionary.en-US.txt'
    if vim.fn.filereadable(vim_dict) == 0 then vim.fn.writefile({}, vim_dict) end
    if vim.uv.fs_lstat(ltex_dict) == nil then vim.uv.fs_symlink(vim_dict, ltex_dict) end
  end

  vim.pack.add { gh 'barreiroleo/ltex_extra.nvim' }
  -- ltex_extra.setup() with `init_check = true` reads the on-disk dictionary
  -- and pushes it into the running ltex client. That only works once ltex is
  -- attached, so we defer setup to the first LspAttach for ltex (rather than
  -- calling it eagerly during init, when no client exists yet). The one-shot
  -- guard prevents re-registering handlers if ltex re-attaches later.
  do
    local ltex_extra_initialized = false
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        if ltex_extra_initialized then return end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'ltex' then
          ltex_extra_initialized = true
          require('ltex_extra').setup {
            load_langs = { 'en-US' },
            init_check = true,
            path = vim.fn.stdpath 'config' .. '/spell',
            log_level = 'none',
          }
        end
      end,
    })
  end

  -- ----- Distraction-free writing -----
  vim.pack.add { gh 'folke/twilight.nvim' }
  require('twilight').setup {
    dimming = { alpha = 0.25 },
    context = 8,
    expand = { 'markdown' },
    exclude = { 'lazy', 'mason' },
  }

  vim.pack.add { gh 'folke/zen-mode.nvim' }
  require('zen-mode').setup {
    window = {
      width = 90,
      options = { number = false, relativenumber = false, signcolumn = 'no' },
    },
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = false },
      tmux = { enabled = true },
    },
    on_open = function()
      vim.b._zen_previous_view = {
        wrap = vim.opt_local.wrap:get(),
        linebreak = vim.opt_local.linebreak:get(),
        spell = vim.opt_local.spell:get(),
        colorcolumn = vim.opt_local.colorcolumn:get(),
        conceallevel = vim.opt_local.conceallevel:get(),
      }
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.spell = true
      vim.opt_local.colorcolumn = ''
      vim.opt_local.conceallevel = 2
    end,
    on_close = function()
      local p = vim.b._zen_previous_view
      if p then
        vim.opt_local.wrap = p.wrap
        vim.opt_local.linebreak = p.linebreak
        vim.opt_local.spell = p.spell
        vim.opt_local.colorcolumn = p.colorcolumn
        vim.opt_local.conceallevel = p.conceallevel
        vim.b._zen_previous_view = nil
      end
    end,
  }

  -- ----- Commenting -----
  vim.pack.add { gh 'numToStr/Comment.nvim' }
  require('Comment').setup {}

  -- ----- Rainbow delimiters -----
  vim.pack.add { gh 'HiPhish/rainbow-delimiters.nvim' }
  require('rainbow-delimiters.setup').setup()
end

-- ============================================================
-- SECTION 9: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
  -- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  -- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
