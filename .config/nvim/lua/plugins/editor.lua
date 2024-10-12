local util = require("conform.util")
return {
	{
		enabled = false,
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
	},

	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {
			highlighters = {
				hsl_color = {
					pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
					group = function(_, match)
						local utils = require("solarized-osaka.hsl")
						--- @type string, string, string
						local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
						--- @type number?, number?, number?
						local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						--- @type string
						local hex_color = utils.hslToHex(h, s, l)
						return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	},

	{
		"telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>fP",
				function()
					require("telescope.builtin").find_files({
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Find Plugin File",
			},
			{
				";f",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
					})
				end,
				desc = "Lists files in your current working directory, respects .gitignore",
			},
			{
				";r",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
			},
			{
				"\\\\",
				function()
					local builtin = require("telescope.builtin")
					builtin.buffers()
				end,
				desc = "Lists open buffers",
			},
			{
				";t",
				function()
					local builtin = require("telescope.builtin")
					builtin.help_tags()
				end,
				desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
			},
			{
				";;",
				function()
					local builtin = require("telescope.builtin")
					builtin.resume()
				end,
				desc = "Resume the previous telescope picker",
			},
			{
				";e",
				function()
					local builtin = require("telescope.builtin")
					builtin.diagnostics()
				end,
				desc = "Lists Diagnostics for all open buffers or a specific buffer",
			},
			{
				";s",
				function()
					local builtin = require("telescope.builtin")
					builtin.treesitter()
				end,
				desc = "Lists Function names, variables, from Treesitter",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")

					local function telescope_buffer_dir()
						return vim.fn.expand("%:p:h")
					end

					telescope.extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = telescope_buffer_dir(),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "Open File Browser with the path of the current buffer",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {},
				},
			})
			opts.pickers = {
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
			}
			opts.extensions = {
				file_browser = {
					theme = "dropdown",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						-- your custom insert mode mappings
						["n"] = {
							-- your custom normal mode mappings
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			}
			telescope.setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			---@type conform.setupOpts
			local opts = {
				default_format_opts = {
					timeout_ms = 3000,
					async = false, -- not recommended to change
					quiet = false, -- not recommended to change
					lsp_format = "fallback", -- not recommended to change
				},
				notify_on_error = true,
				formatters_by_ft = {
					lua = { "stylua" },
					fish = { "fish_indent" },
					sh = { "shfmt" },
					--php = { "pint" },
					php = { "php-cs-fixer" },
					blade = { "blade-formatter", "rustywind" },
					python = { "black" },
					javascript = { "prettierd" },
					-- rust = { "rustfmt" },
				},
				-- LazyVim will merge the options you set here with builtin formatters.
				-- You can also define any custom formatters here.
				---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
				formatters = {
					injected = { options = { ignore_errors = true } },
					-- # Example of using dprint only when a dprint.json file is present
					-- dprint = {
					--   condition = function(ctx)
					--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					--   end,
					-- },
					--
					-- # Example of using shfmt with extra args
					-- shfmt = {
					--   extra_args = { "-i", "2", "-ci" },
					-- },
					pint = {
						meta = {
							url = "https://github.com/laravel/pint",
							description = "Laravel Pint is an opinionated PHP code style fixer for minimalists. Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that your code style stays clean and consistent.",
						},
						command = util.find_executable({
							vim.fn.stdpath("data") .. "/mason/bin/pint",
							"vendor/bin/pint",
						}, "pint"),
						args = { "$FILENAME" },
						stdin = false,
					},
					["php-cs-fixer"] = {
						command = "php-cs-fixer",
						args = {
							"fix",
							"--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
							"$FILENAME",
						},
						stdin = false,
					},
					php = {
						command = "php-cs-fixer",
						args = {
							"fix",
							"$FILENAME",
							"--allow-risky=yes", -- if you have risky stuff in config, if not you dont need it.
						},
						stdin = false,
					},
				},
			}
			return opts
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- @type lspconfig.options
			servers = {
				emmet_ls = {
					filetypes = {
						"astro",
						"blade",
						"css",
						"eruby",
						"html",
						"htmldjango",
						"javascriptreact",
						"less",
						"pug",
						"sass",
						"scss",
						"svelte",
						"typescriptreact",
						"vue",
					},
				},
				intelephense = {
					filetypes = { "php", "blade", "php_only" },
					settings = {
						intelephense = {
							filetypes = { "php", "blade", "php_only" },
							files = {
								associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
								maxSize = 5000000,
							},
						},
					},
				},
			},
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,
			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {
				function(config)
					-- all sources with no handler get passed here

					-- Keep original functionality
					require("mason-nvim-dap").default_setup(config)
				end,
				php = function(config)
					config.configurations = {
						{
							type = "php",
							request = "launch",
							name = "Listen for Xdebug",
							port = 9003,
							pathMappings = {
								-- For some reason xdebug sometimes fails for me, depending on me
								-- using herd or docker. To get it to work, change the order of the mappings.
								-- The first mapping should be the one that you are actively using.
								-- This only started recently, so I don't know what changed.
								["${workspaceFolder}"] = "${workspaceFolder}",
								["/var/www/html"] = "${workspaceFolder}",
							},
						},
					}
					require("mason-nvim-dap").default_setup(config) -- don't forget this!
				end,
			},
			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"php",
				"bash",
				"python",
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"actionlint",
				"ansible-language-server",
				"ansible-lint",
				"antlers-language-server",
				"black",
				"bash-language-server",
				"blade-formatter",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"dot-language-server",
				"emmet-ls",
				"eslint_d",
				"flake8",
				"hadolint",
				"html-lsp",
				"intelephense",
				"nginx-language-server",
				"php-debug-adapter",
				"phpstan",
				"pint",
				"prettierd",
				"pyright",
				"rustywind",
				"shellcheck",
				"shfmt",
				"stylua",
				"tailwindcss-language-server",
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = "LazyFile",
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
				dockerfile = { "hadolint" },
				-- python = { "pylint" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
			},
			-- LazyVim extension to easily override linter options
			-- or add custom linters.
			---@type table<string,table>
			linters = {
				-- -- Example of using selene only when a selene.toml file is present
				-- selene = {
				--   -- `condition` is another LazyVim extension that allows you to
				--   -- dynamically enable/disable linters based on the context.
				--   condition = function(ctx)
				--     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },
			},
		},
	},
	{
		"danymat/neogen",
		config = true,
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
		"echasnovski/mini.files",
		keys = {
			{
				"<leader>e",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (directory of current file)",
			},
			{
				"<leader>E",
				function()
					require("mini.files").open(vim.loop.cwd(), true)
				end,
				desc = "Open mini.files (cwd)",
			},
			{
				"<leader>fm",
				function()
					require("mini.files").open(LazyVim.root(), true)
				end,
				desc = "Open mini.files (root)",
			},
		},
		opts = {
			mappings = {
				go_in = "<CR>",
				go_out = "<Backspace>",
				go_in_plus = "<S-Right>",
				go_out_plus = "<S-Left>",
				go_in_vertical = "<C-V>",
				go_in_horizontal = "<C-S>",
				go_in_vertical_plus = "<C-V>",
				go_in_horizontal_plus = "<C-S>",
				toggle_hidden = ";.",
				change_cwd = ";c",
			},
			windows = {
				width_nofocus = 20,
				width_focus = 50,
				width_preview = 100,
			},
			options = {
				use_as_default_explorer = true,
			},
		},
	},
	{
		"mg979/vim-visual-multi",
	},
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(), -- 使用 Ctrl+j 选择下一项
					["<C-k>"] = cmp.mapping.select_prev_item(), -- 使用 Ctrl+k 选择上一项
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 向上滚动文档
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- 向下滚动文档
					["<C-Space>"] = cmp.mapping.complete(), -- 手动触发补全
					["<C-e>"] = cmp.mapping.abort(), -- 取消补全
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- 确认补全
				}),
				sources = cmp.config.sources({

					{ name = "codeium" },
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "vsnip" }, -- For vsnip users.
				}),
			})
		end,
	},
}
