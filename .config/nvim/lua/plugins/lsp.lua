return {
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
}