return {
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
				"vue-language-server",
				"vtsls",
				"pint",
				"prettierd",
				"pyright",
				"rustywind",
				"shellcheck",
				"shfmt",
				"stylua",
				"tailwindcss-language-server",
				"typescript-language-server",
			},
		},
	},
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"jay-babu/mason-null-ls.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"nvimtools/none-ls.nvim",
		"nvimtools/none-ls-extras.nvim",
		"zapling/mason-lock.nvim",
		"folke/lazydev.nvim",
	},
	config = function()
		require("mason-lspconfig").setup({
			automatic_installation = true,
			handlers = {
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						-- capabilities = capabilities,
					})
				end,
				["volar"] = function()
					require("lspconfig").volar.setup({
						-- NOTE: Uncomment to enable volar in file types other than vue.
						-- (Similar to Takeover Mode)

						-- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },

						-- NOTE: Uncomment to restrict Volar to only Vue/Nuxt projects. This will enable Volar to work alongside other language servers (tsserver).

						-- root_dir = require("lspconfig").util.root_pattern(
						--   "vue.config.js",
						--   "vue.config.ts",
						--   "nuxt.config.js",
						--   "nuxt.config.ts"
						-- ),
						init_options = {
							vue = {
								hybridMode = false,
							},
							-- NOTE: This might not be needed. Uncomment if you encounter issues.

							-- typescript = {
							--   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
							-- },
						},
						settings = {
							typescript = {
								inlayHints = {
									enumMemberValues = {
										enabled = true,
									},
									functionLikeReturnTypes = {
										enabled = true,
									},
									propertyDeclarationTypes = {
										enabled = true,
									},
									parameterTypes = {
										enabled = true,
										suppressWhenArgumentMatchesName = true,
									},
									variableTypes = {
										enabled = true,
									},
								},
							},
						},
					})
				end,

				["tsserver"] = function()
					local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
					local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

					require("lspconfig").tsserver.setup({
						-- NOTE: To enable hybridMode, change HybrideMode to true above and uncomment the following filetypes block.

						-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = volar_path,
									languages = { "vue" },
								},
							},
						},
						settings = {
							typescript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayVariableTypeHintsWhenTypeMatchesName = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
						},
					})
				end,
			},
		})
	end,
}
