return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		enabled = true,
        -- stylua: ignore
        config = function ()
            vim.keymap.set({"n", "x", "o"}, "s", function() require("flash").jump() end, { desc = "Flash" })
        end,
		opts = {
			modes = {
				char = {
					enabled = false, -- 禁用所有字符跳转（包括 `f/F/t/T/y`）
					keys = {},
				},
				search = {
					enabled = false, -- 禁用 `/` 和 `?` 搜索
				},
			},
		},
		keys = false,
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
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
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			-- "codeium.nvim",
			"saghen/blink.compat",
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"xzbdmw/colorful-menu.nvim",
			{ "luozhiya/fittencode.nvim" },
			"Kaiser-Yang/blink-cmp-avante",
		},

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		opts = {

			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
				preset = "default",
				["<C-k>"] = {
					"select_prev",
					"fallback",
				},
				["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<tab>"] = {
					"snippet_forward",
					"fallback",
				},
				["<S-tab>"] = {
					"snippet_backward",
					"fallback",
				},
			},
			snippets = {
				preset = "luasnip",
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
			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				ghost_text = { enabled = false },
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, via `opts_extend`
			sources = {
				-- compat = { "codeium" },
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					-- fittencode = {
					-- 	name = "fittencode",
					-- 	module = "fittencode.sources.blink",
					-- },
					-- codeium = {
					-- 	kind = "Codeium",
					-- 	score_offset = 100,
					-- 	async = true,
					-- },
					-- avante = {
					-- 	module = "blink-cmp-avante",
					-- 	name = "Avante",
					-- 	opts = {
					-- 		-- options for blink-cmp-avante
					-- 	},
					-- },
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
		init = function()
			vim.g.VM_theme = "purplegray"
			vim.g.VM_mouse_mappings = 1
			-- vim.schedule(function()
			vim.g.VM_maps = {
				["I BS"] = "",
				["Add Cursor Down"] = "<M-J>",
				["Add Cursor Up"] = "<M-K>",
				["Goto Next"] = "]v",
				["Goto Prev"] = "[v",
				["I CtrlB"] = "<M-b>",
				["I CtrlF"] = "<M-f>",
				["I Return"] = "<S-CR>",
				["I Down Arrow"] = "",
				["I Up Arrow"] = "",
			}
			-- end)
		end,
	},
	-- {
	-- 	"Exafunction/codeium.nvim",
	-- 	opts = function()
	-- 		LazyVim.cmp.actions.ai_accept = function()
	-- 			if require("codeium.virtual_text").get_current_completion_item() then
	-- 				LazyVim.create_undo()
	-- 				vim.api.nvim_input(require("codeium.virtual_text").accept())
	-- 				return true
	-- 			end
	-- 		end
	-- 	end,
	-- },
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

	-- {
	-- 	"windwp/nvim-autopairs", -- 按两次）可以跳出 （）
	-- 	event = "InsertEnter",
	-- 	config = true,
	-- 	-- use opts = {} for passing setup options
	-- 	-- this is equivalent to setup({}) function
	-- },
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
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
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			preset = "classic",
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			vim.keymap.set("n", "<leader>df", ":DiffviewFileHistory %<CR>", { noremap = true, silent = true })
		end,
	},
}
