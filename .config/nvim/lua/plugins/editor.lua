local util = require("conform.util")
return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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
						-- local utils = require("solarized-osaka.hsl")
						-- --- @type string, string, string
						-- local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
						-- --- @type number?, number?, number?
						-- local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						-- --- @type string
						-- local hex_color = utils.hslToHex(h, s, l)
						-- return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		},
	},
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
				preset = "default",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`
			sources = {
				compat = { "codeium" },
				default = { "lsp", "path", "snippets", "buffer", "codeium" },
				providers = {
					codeium = {
						kind = "Codeium",
						score_offset = 100,
						async = true,
					},
				},
				-- optionally disable cmdline completions
				-- cmdline = {},
			},

			-- experimental signature help support
			-- signature = { enabled = true }
		},
		-- allows extending the providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
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
		opts = function(_, opts)
			-- 保留现有的 servers 配置
			opts.servers = opts.servers or {}

			-- volar 配置
			opts.servers.volar = {
				init_options = {
					vue = {
						hybridMode = true,
					},
				},
			}
			-- vtsls 配置
			opts.servers.vtsls = opts.servers.vtsls or {}
			table.insert(opts.servers.vtsls.filetypes, "vue")
			LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
				{
					name = "@vue/typescript-plugin",
					location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
					languages = { "vue" },
					configNamespace = "typescript",
					enableForWorkspaceTypeScriptVersions = true,
				},
			})

			-- emmet_ls 配置
			opts.servers.emmet_ls = {
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
			}

			opts.servers.rust_analyzer = {
				mason = false,
				cmd = { vim.fn.expand("~/.cargo/bin/rust-analyzer") },
				settings = {
					["rust-analyzer"] = {
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
					},
				},
			}
			opts.servers.clangd = {
				keys = {
					{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
				},
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern(
						"Makefile",
						"configure.ac",
						"configure.in",
						"config.h.in",
						"meson.build",
						"meson_options.txt",
						"build.ninja"
					)(fname) or require("lspconfig.util").root_pattern(
						"compile_commands.json",
						"compile_flags.txt"
					)(fname) or require("lspconfig.util").find_git_ancestor(fname)
				end,
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			}
			-- python
			-- setup 配置
			-- opts.setup = {
			-- 	clangd = function(_, opts)
			-- 		local clangd_ext_opts = require("clangd_extensions").setup() or {}
			-- 		require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts, { server = opts }))
			-- 		return false
			-- 	end,
			-- }
			opts.servers.ruff = {
				cmd_env = { RUFF_TRACE = "messages" },
				init_options = {
					settings = {
						logLevel = "error",
					},
				},
				keys = {
					{
						"<leader>co",
						LazyVim.lsp.action["source.organizeImports"],
						desc = "Organize Imports",
					},
				},
			}
			opts.servers.ruff_lsp = {
				keys = {
					{
						"<leader>co",
						LazyVim.lsp.action["source.organizeImports"],
						desc = "Organize Imports",
					},
				},
			}
			opts.servers.taplo = {
				keys = {
					{
						"K",
						function()
							if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
								require("crates").show_popup()
							else
								vim.lsp.buf.hover()
							end
						end,
						desc = "Show Crate Documentation",
					},
				},
			}
			opts.servers.gopls = {
				settings = {
					gopls = {
						usePlaceholders = false,
					},
				},
			}
			-- intelephense 配置
			opts.servers.intelephense = {
				filetypes = { "php", "blade", "php_only" },
				cmd = {
					"/home/yunxi/.local/share/pnpm/global/5/node_modules/intelephense/lib/intelephense.js",
					"--stdio",
				}, -- 指定执行程序路径
				settings = {
					intelephense = {
						filetypes = { "php", "blade", "php_only" },
						files = {
							associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
							maxSize = 5000000,
						},
					},
				},
			}
		end,
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
				"php-debug-adapter",
				"phpcs",
				"php-cs-fixer",
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
				php = { "phpstan" },
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
				phpstan = {
					cmd = "/home/yunxi/.config/composer/vendor/bin/phpstan",
					args = {
						"analyse",
						"--memory-limit=2G",
						"--level=0",
						"--error-format=json",
						"--no-progress",
					},
					stdin = false,
					cwd = vim.fn.getcwd(),
					on_exit = function(_, code, _, _)
						print("PHPStan exited with code " .. code)
					end,
				},
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
				"<leader>E",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (directory of current file)",
			},
			{
				"<leader>e",
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
				go_out = "<S-Left>",
				go_in_plus = "<S-Right>",
				go_out_plus = "<C-b>",
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
	{ "rhysd/git-messenger.vim" },
	{ "echasnovski/mini.comment", version = "*" },
	{ "kevinhwang91/nvim-ufo" },
	{
		"joshuavial/aider.nvim", --  结对编程 ai 工具
		config = function()
			require("aider").setup({
				-- 这里可以添加具体配置参数
			})
		end,
	},

	{
		"windwp/nvim-autopairs", -- 按两次）可以跳出 （）
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "vue", "css", "rust", "ron", "cpp", "ninja", "rst" } },
	},
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				cmp = { enabled = true },
			},
		},
	},
	{
		"rust-lang/rust.vim",
	},
	{
		"keaising/im-select.nvim",
		opts = {
			default_command = "/usr/bin/fcitx5-remote",
			default_im_select = "keyboard-us",
		},
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup()
		end,
	},
	{ "tpope/vim-obsession" },
	{
		"nvim-neotest/neotest-python",
	},
	{
		"mfussenegger/nvim-dap-python",
	},
	{
		"linux-cultist/venv-selector.nvim",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python", --optional
			-- { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		branch = "regexp", -- This is the regexp branch, use this for the new version
		config = function()
			require("venv-selector").setup()
		end,
		keys = {
			-- Keymap to open VenvSelector to pick a venv.
			{ "<leader>vs", "<cmd>VenvSelect<cr>" },
			-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>" },
		},
	},
}
