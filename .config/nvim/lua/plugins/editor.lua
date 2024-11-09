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
			-- setup 配置
			opts.setup = {
				clangd = function(_, opts)
					local clangd_ext_opts = require("clangd_extensions").setup() or {}
					require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts, { server = opts }))
					return false
				end,
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
				go_out = "<C-b>",
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
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), -- 使用 Ctrl+j 选择下一项
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), -- 使用 Ctrl+k 选择上一项
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 向上滚动文档
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- 向下滚动文档
					["<C-Space>"] = cmp.mapping.complete(), -- 手动触发补全
					["<C-e>"] = cmp.mapping.abort(), -- 取消补全
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- 确认补全
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered({
						placement = function(_, _)
							-- 自动检测可用空间，如果上方没有足够空间，放置在下方
							local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
							if wininfo.topline > 10 then
								return "top"
							else
								return "bottom"
							end
						end,
						max_height = 15,
						max_width = 60,
						col_offset = 0,
						side_padding = 1,
					}),
				},
				sources = cmp.config.sources({
					{ name = "codeium" },
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "vsnip" }, -- For vsnip users.
				}),
			})
		end,
		opts = function(_, opts)
			table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
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
		opts = { ensure_installed = { "vue", "css", "rust", "ron", "cpp" } },
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
}
