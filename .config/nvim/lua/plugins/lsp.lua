local lspconfig = require("lspconfig")
return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "<c-k>", false, mode = "i" }
		end,
		opts = function(_, opts)
			-- 保留现有的 servers 配置
			opts.servers = opts.servers or {}
			local mason_registry = require("mason-registry")
			-- local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
			-- 	.. "/node_modules/@vue/language-server"
			-- -- volar 配置
			opts.servers.volar = {
				-- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
				-- init_options = {
				-- 	vue = {
				-- 		hybridMode = false,
				-- 	},
				-- },
			}
			opts.setup = {
				phpactor = function(_, opts)
					vim.lsp.handlers["$/progress"] = function(...) end
					require("lspconfig").phpactor.setup(opts)
					return true
				end,
			}
			-- -- ts 配置
			opts.servers.ts_ls = {
				filetypes = { "javascript", "typescript", "vue" },
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							-- location = vue_language_server_path,
							location = "/home/yunxi/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin",
							languages = { "vue", "javascript", "typescript" },
						},
					},
				},
			}
			opts.servers.harper_ls = {
				settings = {
					["harper-ls"] = {
						userDictPath = "",
						fileDictPath = "",
						linters = {
							SpellCheck = true,
							SpelledNumbers = false,
							AnA = true,
							SentenceCapitalization = true,
							UnclosedQuotes = true,
							WrongQuotes = false,
							LongSentences = true,
							RepeatedWords = true,
							Spaces = true,
							Matcher = true,
							CorrectNumberSuffix = true,
						},
						codeActions = {
							ForceStable = false,
						},
						markdown = {
							IgnoreLinkTitle = false,
						},
						diagnosticSeverity = "hint",
						isolateEnglish = false,
						dialect = "American",
					},
				},
			}
			-- vtsls 配置
			-- opts.servers.vtsls = {
			-- 	filetypes = { "vue" },
			-- }
			-- table.insert(opts.servers.vtsls.filetypes, "vue")
			-- LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
			-- 	{
			-- 		name = "@vue/typescript-plugin",
			-- 		location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
			-- 		languages = { "vue" },
			-- 		configNamespace = "typescript",
			-- 		enableForWorkspaceTypeScriptVersions = true,
			-- 	},
			-- })

			--eslint
			opts.servers.eslint = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"vue",
					"html",
					"markdown",
					"json",
					"jsonc",
					"yaml",
					"toml",
					"xml",
					"gql",
					"graphql",
					"astro",
					"svelte",
					"css",
					"less",
					"scss",
					"pcss",
					"postcss",
				},
				settings = {
					rulesCustomizations = customizations,
				},
			}

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
			opts.servers.phpactor = {
				cmd = { "phpactor", "language-server" },
				filetypes = { "php" },
				root_dir = lspconfig.util.root_pattern(".git", ".phpactor.json", ".phpactor.yml"),
				init_options = {
					-- ["completion_worse.completor.docblock.enabled"] = false,
				},
			}
			-- intelephense 配置
			-- opts.servers.intelephense = {
			-- 	filetypes = { "php", "blade", "php_only" },
			-- 	cmd = {
			-- 		"/home/yunxi/.local/share/pnpm/global/5/node_modules/intelephense/lib/intelephense.js",
			-- 		"--stdio",
			-- 	}, -- 指定执行程序路径
			-- 	settings = {
			-- 		intelephense = {
			-- 			filetypes = { "php", "blade", "php_only" },
			-- 			files = {
			-- 				associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
			-- 				maxSize = 5000000,
			-- 			},
			-- 		},
			-- 	},
			-- }
		end,
	},
}
