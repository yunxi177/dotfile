return {
	-- Create annotations with one keybind, and jump your cursor in the inserted annotation
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Refactoring tool
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor({})
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- {
	-- 	"jose-elias-alvarez/null-ls.nvim",
	-- 	opts = function(_, opts)
	-- 		local null_ls = require("null-ls")
	-- 		opts.sources = {
	-- 			-- JavaScript/TypeScript 格式化工具和诊断
	-- 			-- null_ls.builtins.formatting.eslint_d.with({
	-- 			-- 	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	-- 			-- }),
	-- 			-- null_ls.builtins.diagnostics.eslint.with({
	-- 			-- 	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	-- 			-- }),
	-- 			-- Go 格式化工具
	-- 			null_ls.builtins.formatting.gofmt.with({
	-- 				filetypes = { "go" },
	-- 			}),
	-- 			null_ls.builtins.formatting.goimports.with({
	-- 				filetypes = { "go" },
	-- 			}),
	-- 		}
	-- 	end,
	-- },
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = function(_, opts)
			opts.provider = "openrouter"
			opts.vendors = {
				openrouter = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "google/gemini-2.5-pro-exp-03-25:free",
				},
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-coder",
					max_tokens = 4096,
				},
			}
			opts.mappings = {
				diff = {
					ours = "<leader>oo", -- 选择本地版本
					theirs = "<leader>ot", -- 可以考虑修改为更易记的快捷键
					all_theirs = "<leader>oa", -- 接受所有远程修改
					both = "<leader>ob", -- 应用两者的更改
					cursor = "<leader>oc", -- 应用当前光标位置的更改
					next = "]x", -- 跳到下一个更改
					prev = "[x", -- 跳到上一个更改
				},
			}
		end,
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"simrat39/symbols-outline.nvim",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		cmd = "SymbolsOutline",
		opts = {
			position = "right",
		},
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		opts = function(_, opts)
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
		end,
	},
}
