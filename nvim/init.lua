-- https://github.com/saahiluppal/configfiles/blob/main/nvim/init.lua

-- vim.opt.exrc = true

vim.opt.background = dark
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.backspace = indent,eol,start

-- NOTE this should be enabled by default
vim.cmd('filetype plugin indent on')

-- disable mouse
vim.opt.mouse = ''

vim.opt.history = 1000


-- hide bottom bar
vim.cmd('set laststatus=0 ruler')

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.hidden = true
-- set backspace to clear hlsearch
vim.cmd('nmap <silent> <BS>  :nohlsearch<CR>')

-- vim.opt.completeopt = { "menu" , "menuone" , "noselect" }

-- vim.opt.wrap = false
-- vim.opt.swapfile = false
-- vim.opt.backup = false

vim.opt.undodir = vim.fn.expand("~") .. "/.config/nvim/undodir/"
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 300

vim.opt.scrolloff = 10

-- modify leader
vim.g.mapleader = " "
local keymap_opts = { noremap=true, silent=true }

-- quicker navigation
-- space+p will move to next buffer
vim.api.nvim_set_keymap('n', '<leader>p', ':bn<cr>', keymap_opts)
-- space+o will move to previous buffer
vim.api.nvim_set_keymap('n', '<leader>o', ':bp<cr>', keymap_opts)

-- close buffer
vim.api.nvim_set_keymap('n', '<leader>x', ':bd<cr>', keymap_opts)

-- toggle gitgutter
vim.api.nvim_set_keymap('n', '<leader>g', ':GitGutterToggle<cr>', keymap_opts)

-- remember last position
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- line numbers
-- vim.opt.relativenumber = true
-- vim.opt.number = true

-- colorscheme
vim.cmd('colorscheme molokai')
-- vim.cmd('colorscheme monokai-pro-classic')

-- treat some file differently
vim.cmd('autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4')
vim.cmd('autocmd BufNewFile,BufRead Vagrantfile setlocal ts=2 sw=2 sts=2')
vim.cmd('autocmd BufRead,BufNewFile *.yml,*.yaml setlocal ts=2 sw=2 sts=2')
vim.cmd('autocmd BufRead,BufNewFile *.json setlocal ts=2 sw=2 sts=2')
vim.cmd('autocmd BufRead,BufNewFile *.md setlocal ts=2 sw=2 sts=2')

-- highlight nbsp and trailing whitespace
vim.cmd('autocmd BufNewFile,BufRead * highlight nbsp ctermbg=Red')
vim.cmd('autocmd BufNewFile,BufRead * match nbsp "[\xc2\xa0]"')
vim.cmd('autocmd BufNewFile,BufRead * highlight trailing_spaces ctermbg=Red guibg=#ff0000')
vim.cmd('autocmd BufNewFile,BufRead * match trailing_spaces /\\s\\+$/')


-----------------------------------------------------------------------------------
-- PLUGINS                                                                       --
-----------------------------------------------------------------------------------
-- https://github.com/folke/lazy.nvim
-- NOTE path defaults to ~/.local/share/nvim/
-- NOTE verify with ":checkhealth lazy"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    { 'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = { 'nvim-lua/plenary.nvim'} },
    { 'airblade/vim-gitgutter' },
    { 'tpope/vim-fugitive', tag = 'v3.7' },
    { 'fatih/vim-go', tag = 'v1.28' },
    { 'williamboman/mason.nvim', tag = 'v1.10.0' },
    { 'williamboman/mason-lspconfig.nvim', tag = 'v1.29.0' },
    --{ 'catppuccin/nvim', name = 'catppuccin', priority = 1000 , tag = 'v1.7.0' },
    --{ 'rebelot/kanagawa.nvim', name = 'kanagawa', priority = 1000 },
    { 'loctvl842/monokai-pro.nvim', name = 'monokai', priority = 1000 },

    {
        'folke/zen-mode.nvim',
        tag = 'v1.3.0',
        opts = {
            window = {
                width=0.8,
            },
        },
    },

    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    },

    {
      "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
      tag = 'v0.1.8',
      lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
      dependencies = {
        -- main one
        { "ms-jpq/coq_nvim", branch = "coq" },

        -- 9000+ Snippets
        -- { "ms-jpq/coq.artifacts", branch = "artifacts" },

        -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
        -- Need to **configure separately**
        -- { 'ms-jpq/coq.thirdparty', branch = "3p" }
        -- - shell repl
        -- - nvim lua api
        -- - scientific calculator
        -- - comment banner
        -- - etc
      },
      init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up', -- can also be true if you want to start COQ at startup
            -- Your COQ settings here
        }
      end,
      config = function()
        -- Your LSP settings here
      end,
    },
  })


-- nvim-telescope
local telescope_builtin = require('telescope.builtin')
require('telescope').setup({
    pickers = {
        buffers = {
            sort_lastused = true,
            ignore_current_buffer = true,
            --sorting_strategy = "ascending"
        },
    },
})
vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, {})
vim.keymap.set('n', '<C-k>', telescope_builtin.buffers, {})
vim.keymap.set('n', '<C-i>', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<CR>', ':Telescope grep_string default_text=' .. vim.fn.expand('<cword>') .. '<cr>', {})
--telescope_builtin.buffers({ sort_lastused = true, ignore_current_buffer = true, sorting_strategy = "ascending" })
vim.cmd('hi TelescopeSelection ctermfg=white')
vim.cmd('hi TelescopePreviewLine ctermfg=white ctermbg=darkgray')


-- vim-fugitive
vim.keymap.set('n', '<C-h>', ':Git blame<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>b', ':Git blame<cr>', keymap_opts)


-- vim-gitgutter
vim.cmd('highlight GitGutterAdd ctermfg=darkgreen')


-- zenmode
vim.api.nvim_set_keymap('n', '<leader>z', ':ZenMode<cr>', keymap_opts)


-- neotree
-- https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#quickstart
require("neo-tree").setup({
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil , -- use a custom function for sorting files and directories in the tree
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "+",
            folder_open = "-",
            folder_empty = " ",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified  = "M", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted   = "X",-- this can only be used in the git_status source
              renamed   = "R",-- this can only be used in the git_status source
              -- Status type
              untracked = "U",
              ignored   = "I",
              unstaged  = "",
              staged    = "+",
              conflict  = "C",
            }
          },
          -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
          file_size = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = true,
            required_width = 122, -- min width of window required to show this column
          },
          last_modified = {
            enabled = true,
            required_width = 88, -- min width of window required to show this column
          },
          created = {
            enabled = true,
            required_width = 110, -- min width of window required to show this column
          },
          symlink_target = {
            enabled = false,
          },
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-custom-commands-global`
        commands = {},
        window = {
          position = "left",
          width = 90,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
                "toggle_node",
                nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use 
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            -- Read `# Preview Mode` for more information
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none" -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          }
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = false, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                                  -- in whatever position is specified in window.position
                                -- "open_current",  -- netrw disabled, opening a directory opens within the
                                                  -- window like netrw would, regardless of window.position
                                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                                          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["og"] = { "order_by_git_status", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
              -- ['<key>'] = function(state) ... end,
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
              -- ['<key>'] = function(state, scroll_padding) ... end,
            },
          },

          commands = {} -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --              -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          }
        }
      })
vim.api.nvim_set_keymap('n', '<c-l>', ':Neotree<cr>', keymap_opts)
vim.api.nvim_set_keymap('n', '<c-j>', ':Neotree close<cr>', keymap_opts)


-- mason
-- NOTE execute ":Mason"
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "pyright", },
    automatic_installation = true,
}


-- LSP setup
-- NOTE ensure node is installed with the following - https://nodejs.org/en/download/package-manager
-- Temp fix - npm config set strict-ssl false
lspconfig = require('lspconfig')

lspconfig.pyright.setup {}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  --root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}
