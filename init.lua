-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Function to find Clojure namespace declaration and copy it to clipboard
function FindClojureNamespaceAndCopy()
  local ns_pattern = '%(ns%s+([%w%.%-]+)'
  local current_line = vim.api.nvim_get_current_line()
  local namespace = current_line:match(ns_pattern)

  if namespace then
    vim.fn.setreg('+', namespace)
    print('Copied to clipboard: ' .. namespace)
  else
    -- If not found in current line, search buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
      namespace = line:match(ns_pattern)
      if namespace then
        vim.fn.setreg('+', namespace)
        print('Copied to clipboard: ' .. namespace)
        return
      end
    end
    print 'No Clojure namespace declaration found'
  end
end

-- Function to create a new Clojure scratch buffer
function OpenClojureScratchBuffer()
  -- Check if a scratch buffer already exists
  local buffers = vim.api.nvim_list_bufs()
  local scratch_nr = nil

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match '.*ClojureScratch$' then
        scratch_nr = buf
        break
      end
    end
  end

  local buf
  -- Create or reuse buffer
  if scratch_nr and vim.api.nvim_buf_is_valid(scratch_nr) then
    buf = scratch_nr
  else
    -- Create a new buffer (unlisted=false so it shows in buffers list)
    buf = vim.api.nvim_create_buf(true, false)

    -- Add a unique identifier to avoid name collisions
    local timestamp = os.date '%Y%m%d%H%M%S'
    vim.api.nvim_buf_set_name(buf, 'ClojureScratch-' .. timestamp)

    -- Set buffer filetype to clojure
    vim.api.nvim_buf_set_option(buf, 'filetype', 'clojure')

    -- Add initial content with namespace that works with Conjure
    local lines = {
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
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end

  -- Open the buffer in current window
  vim.api.nvim_set_current_buf(buf)

  -- Print info message
  print 'Opened Clojure scratch buffer'
end

-- Function to create a new Markdown scratch buffer
function OpenMarkdownScratchBuffer()
  -- Check if a scratch buffer already exists
  local buffers = vim.api.nvim_list_bufs()
  local scratch_nr = nil

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match '.*MarkdownScratch$' then
        scratch_nr = buf
        break
      end
    end
  end

  local buf
  -- Create or reuse buffer
  if scratch_nr and vim.api.nvim_buf_is_valid(scratch_nr) then
    buf = scratch_nr
  else
    -- Create a new buffer (unlisted=false so it shows in buffers list)
    buf = vim.api.nvim_create_buf(true, false)

    -- Add a unique identifier to avoid name collisions
    local timestamp = os.date '%Y%m%d%H%M%S'
    vim.api.nvim_buf_set_name(buf, 'MarkdownScratch-' .. timestamp .. '.md')

    -- Set buffer filetype to markdown
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

    -- Get project context
    local cwd = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(cwd, ':t')
    local git_branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
    if vim.v.shell_error ~= 0 then
      git_branch = ''
    end

    -- Add initial content with header
    local lines = {
      '<!-- Markdown Scratch Buffer -->',
      '<!-- Created: ' .. os.date '%Y-%m-%d %H:%M:%S' .. ' -->',
      '<!-- Project: ' .. project_name .. ' -->',
    }

    if git_branch ~= '' then
      table.insert(lines, '<!-- Branch: ' .. git_branch .. ' -->')
    end

    table.insert(lines, '')
    table.insert(lines, '# Scratch Notes')
    table.insert(lines, '')
    table.insert(lines, '')

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end

  -- Open the buffer in current window
  vim.api.nvim_set_current_buf(buf)

  -- Print info message
  print 'Opened Markdown scratch buffer'
end

-- Create user commands to open scratch buffers
vim.api.nvim_create_user_command('ClojureScratch', OpenClojureScratchBuffer, {
  desc = 'Open a new Clojure scratch buffer',
})

vim.api.nvim_create_user_command('MarkdownScratch', OpenMarkdownScratchBuffer, {
  desc = 'Open a new Markdown scratch buffer',
})

-- Map to a keybinding (only for Clojure files)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'clojure',
  callback = function()
    vim.keymap.set('n', '<leader>cn', FindClojureNamespaceAndCopy, { buffer = true, desc = '[C]opy Clojure [N]amespace to clipboard' })
    vim.keymap.set('n', '<leader>n', function()
      vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } } }
    end, { buffer = true, desc = 'Clean [N]amespace' })
    vim.keymap.set('n', '<leader>cs', OpenClojureScratchBuffer, { buffer = true, desc = '[C]lojure [S]cratch buffer' })
  end,
})

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99 -- so folds start open

-- File tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
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

-- Enable spell checking for specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'gitcommit', 'fountain' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
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
--   and `:help lua-options-guide`
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

-- Function to copy the current file path relative to project root
function CopyFilePathFromRoot()
  -- Get the current buffer's full path
  local filepath = vim.fn.expand '%:p'

  -- Get the git root directory (or current working directory if not in a git repo)
  local git_root = vim.fn.system('git -C ' .. vim.fn.expand '%:p:h' .. ' rev-parse --show-toplevel'):gsub('\n', '')

  if vim.v.shell_error ~= 0 then
    -- Not in a git repo, use current working directory
    git_root = vim.fn.getcwd()
  end

  -- Make path relative to root
  local relative_path = filepath:gsub('^' .. vim.fn.escape(git_root, '%-%.()[]{}\\^$+*') .. '/', '')

  -- Copy to clipboard
  vim.fn.setreg('+', relative_path)
  print('Copied to clipboard: ' .. relative_path)
end

-- Set keybinding to copy file path
vim.keymap.set('n', '<leader>cp', CopyFilePathFromRoot, { desc = '[C]opy file [P]ath from project root' })

-- Set keybinding to open markdown scratch buffer
vim.keymap.set('n', '<leader>ms', OpenMarkdownScratchBuffer, { desc = '[M]arkdown [S]cratch buffer' })

-- Spell checking keybindings
vim.keymap.set('n', '<leader>ts', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  print(vim.opt_local.spell:get() and 'Spell checking enabled' or 'Spell checking disabled')
end, { desc = '[T]oggle [S]pell checking' })
vim.keymap.set('n', ']s', ']s', { desc = 'Next misspelled word' })
vim.keymap.set('n', '[s', '[s', { desc = 'Previous misspelled word' })
vim.keymap.set('n', 'z=', 'z=', { desc = 'Suggest spelling corrections' })
vim.keymap.set('n', 'zg', 'zg', { desc = 'Add word to dictionary' })
vim.keymap.set('n', 'zw', 'zw', { desc = 'Mark word as misspelled' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })

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

-- Window management with leader key
vim.keymap.set('n', '<leader>wh', function() vim.cmd('wincmd h') end, { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', function() vim.cmd('wincmd j') end, { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>wk', function() vim.cmd('wincmd k') end, { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>wl', function() vim.cmd('wincmd l') end, { desc = 'Move to right window' })
vim.keymap.set('n', '<leader>ws', function() vim.cmd('wincmd s') end, { desc = 'Split horizontally' })
vim.keymap.set('n', '<leader>wv', function() vim.cmd('wincmd v') end, { desc = 'Split vertically' })
vim.keymap.set('n', '<leader>wq', function() vim.cmd('wincmd q') end, { desc = 'Close window' })
vim.keymap.set('n', '<leader>wo', function() vim.cmd('wincmd o') end, { desc = 'Close all other windows' })
vim.keymap.set('n', '<leader>w=', function() vim.cmd('wincmd =') end, { desc = 'Equalize window sizes' })
vim.keymap.set('n', '<leader>w|', function() vim.cmd('wincmd |') end, { desc = 'Maximize window width' })
vim.keymap.set('n', '<leader>w_', function() vim.cmd('wincmd _') end, { desc = 'Maximize window height' })
vim.keymap.set('n', '<leader>wd', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })
vim.keymap.set('n', '<leader>wD', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })

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
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  -- File tree plugin
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local nvim_tree_api = require 'nvim-tree.api'
      require('nvim-tree').setup {
        sort = { sorter = 'case_sensitive' },
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = {
          dotfiles = true, -- Hide dotfiles by default
          git_ignored = true, -- Hide git-ignored files by default
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      }

      -- Toggle hidden files function
      local function toggle_nvim_tree_hidden()
        local api = require 'nvim-tree.api'
        api.tree.toggle_hidden_filter()
        print 'Toggled hidden files'
      end

      -- Toggle git-ignored files function
      local function toggle_nvim_tree_gitignored()
        local api = require 'nvim-tree.api'
        api.tree.toggle_gitignore_filter()
        print 'Toggled git-ignored files'
      end

      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Tree' })
      vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFile<CR>', { desc = 'Find Current File in Tree' })
      vim.keymap.set('n', '<leader>th', toggle_nvim_tree_hidden, { desc = 'Toggle Hidden Files in Tree' })
      vim.keymap.set('n', '<leader>ti', toggle_nvim_tree_gitignored, { desc = 'Toggle Git-Ignored Files in Tree' })
    end,
  },
  -- Symbols list view
  {
    'simrat39/symbols-outline.nvim',
    version = '*',
    lazy = false,
    cmd = 'SymbolsOutline',
    keys = { { '<leader>o', '<cmd>SymbolsOutline<CR>', desc = 'Toggle Symbols Outline' } },
    config = function()
      require('symbols-outline').setup {
        position = 'right',
        relative_width = true,
        width = 45,
        auto_close = true,
        keymaps = { close = { '<Esc>', 'q' } },
        symbols = {},
      }
    end,
  },
  -- Clojure REPL with Conjure
  {
    'Olical/conjure',
    ft = { 'clojure' },
    init = function()
      vim.g['conjure#mapping#prefix'] = ',c'
    end,
    config = function()
      -- Optional: tweak settings, e.g., window height for the log.
      vim.g['conjure#log#winheight'] = 12
    end,
  },
  -- Structural editing with Paredit (slurp and barf)
  {
    'guns/vim-sexp',
    dependencies = {
      'tpope/vim-sexp-mappings-for-regular-people',
      'tpope/vim-repeat',
      'tpope/vim-surround',
    },
    ft = { 'clojure', 'scheme', 'lisp' },
    config = function()
      -- Keep only keybindings that start with > and disable others
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
      -- Keep only keybindings that start with > from vim-sexp-mappings-for-regular-people
      vim.g.sexp_mappings_for_regular_people = {
        sexp_capture_next_element = '', -- <(
        sexp_capture_prev_element = '', -- >)
      }
      -- The only bindings we keep are >)/) for slurp/barf
    end,
  },
  {
    '00msjr/nvim-fountain',
    ft = 'fountain', -- Lazy-load only for fountain files
    config = function()
      require('nvim-fountain').setup {
        -- Optional configuration
        keymaps = {
          next_scene = ']]',
          prev_scene = '[[',
          uppercase_line = '<S-CR>',
        },
        -- Export configuration
        export = {
          pdf = { options = '--overwrite --font Courier' },
        },
      }
    end,
  },
  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
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

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          -- Hide hidden files by default
          hidden = false,
          -- Don't include files in .gitignore by default
          file_ignore_patterns = {},
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
        },
        pickers = {
          find_files = {
            hidden = false,
            no_ignore = false,
          },
          live_grep = {
            -- No additional args by default to respect gitignore and hidden files
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Add toggle functions for telescope
      _G.telescope_toggle_hidden_files = function()
        -- Track toggle state with a global variable since retrieving from Telescope is unreliable
        if _G.telescope_showing_hidden == nil then
          _G.telescope_showing_hidden = false -- Initial state: not showing hidden files
        end

        -- Toggle the state
        _G.telescope_showing_hidden = not _G.telescope_showing_hidden

        -- Get the new state
        local new_hidden = _G.telescope_showing_hidden
        local new_no_ignore = _G.telescope_showing_hidden

        -- Preserve existing configuration by getting current setup
        local telescope = require 'telescope'

        -- Create a modified configuration
        local config = {
          defaults = {
            -- Keep existing mappings from original setup
            mappings = {
              i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            },
            -- Update hidden file settings
            hidden = new_hidden,
            no_ignore = new_no_ignore,
          },
          pickers = {
            find_files = {
              hidden = new_hidden,
              no_ignore = new_no_ignore,
            },
            live_grep = {},
          },
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          },
        }

        -- Set additional args for live_grep based on state
        if new_hidden then
          config.pickers.live_grep.additional_args = function()
            return { '--hidden', '--no-ignore' }
          end
        end

        -- Update configuration
        telescope.setup(config)

        -- Reload extensions to ensure configuration is applied
        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, 'ui-select')

        -- Show status message
        if new_hidden then
          print 'Telescope: Now showing hidden and git-ignored files'
        else
          print 'Telescope: Now hiding hidden and git-ignored files'
        end
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
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- Add keybinding for toggling hidden files in telescope
      vim.keymap.set('n', '<leader>ts', function()
        _G.telescope_toggle_hidden_files()
      end, { desc = '[T]oggle hidden files in [S]earch/telescope' })

      -- Function to search for yanked text using telescope grep
      vim.keymap.set('n', '<leader>sp', function()
        local yanked_text = vim.fn.getreg '"'
        if yanked_text and yanked_text ~= '' then
          -- Remove newlines and extra whitespace
          local cleaned_text = yanked_text:gsub('\n', ' '):gsub('%s+', ' '):match '^%s*(.-)%s*$'
          builtin.live_grep { default_text = cleaned_text }
        else
          print 'No text in yank register'
        end
      end, { desc = '[S]earch for yanked text ([P]aste)' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
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

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        ts_ls = {},
        --

        rust_analyzer = {},
        clojure_lsp = {},

        -- Grammar and spell checking for prose
        ltex = {
          settings = {
            ltex = {
              language = 'en-US',
              disabledRules = {},
              hiddenFalsePositives = {},
            },
          },
        },

        -- Add JSON language server
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'clj-kondo',
        'cljfmt',
        'prettier', -- For JSON formatting
        'typescript-language-server', -- TypeScript LSP
        'ltex-ls', -- Grammar and spell checking
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = { 'n', 'v' },
        desc = '[F]ormat buffer or selection',
      },
      {
        '<leader>j',
        function()
          -- Only run zprint with justified pairs on Clojure files
          if vim.bo.filetype == 'clojure' then
            require('conform').format {
              async = true,
              formatters = { 'zprint_justified' },
            }
          end
        end,
        mode = { 'n', 'v' },
        desc = '[J]ustify Clojure maps/bindings',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, clojure = true, typescript = true, javascript = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        clojure = { 'cljfmt' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        typescript = { 'prettier' },
        javascript = { 'prettier' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      -- Define a custom formatter that only does justified pairs with zprint
      formatters = {
        zprint_justified = {
          command = 'zprint',
          args = {
            '{:style [:respect-nl :justified :ns-justify :sort-dependencies :sort-require]}',
          },
          stdin = true,
        },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
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
        -- See :h blink-cmp-config-keymap for defining your own keymap
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
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
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
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Rainbow parentheses/brackets/braces
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'VimEnter',
    config = function()
      require('rainbow-delimiters.setup').setup()
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

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
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'clojure', 'rust' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
