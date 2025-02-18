return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	-- animations
	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.scroll = {
				enable = false,
			}
		end,
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		--dependencies = { "craftzdog/solarized-osaka.nvim" },
		dependencies = { "catppuccin/nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function() end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},
	{
		"echasnovski/mini.indentscope",
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		dependencies = { "echasnovski/mini.indentscope" },
		lazy = false,
		keys = {
			{
				"o",
				mode = "o",
				desc = "Move outer indentation",
				function()
					require("mini.indentscope").setup({})
					local operator = vim.v.operator
					if operator == "d" then
						local scope = MiniIndentscope.get_scope()
						local top = scope.border.top
						local bottom = scope.border.bottom
						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						local move = ""
						if row == bottom then
							move = "k"
						elseif row == top then
							move = "j"
						end
						local ns = vim.api.nvim_create_namespace("border")
						vim.api.nvim_buf_add_highlight(0, ns, "Substitute", top - 1, 0, -1)
						vim.api.nvim_buf_add_highlight(0, ns, "Substitute", bottom - 1, 0, -1)
						vim.defer_fn(function()
							vim.api.nvim_buf_set_text(0, top - 1, 0, top - 1, -1, {})
							vim.api.nvim_buf_set_text(0, bottom - 1, 0, bottom - 1, -1, {})
							vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
						end, 150)
						return "<esc>" .. move
					else
						return "o"
					end
				end,
			},
		},
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = { -- https://patorjk.com/software/taag/?ref=devas.life#p=display&f=ANSI%20Shadow&t=devaslife 生成
					header = [[
██████╗ ███████╗██╗   ██╗ █████╗ ███████╗██╗     ██╗███████╗███████╗
██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██║     ██║██╔════╝██╔════╝
██║  ██║█████╗  ██║   ██║███████║███████╗██║     ██║█████╗  █████╗  
██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══██║╚════██║██║     ██║██╔══╝  ██╔══╝  
██████╔╝███████╗ ╚████╔╝ ██║  ██║███████║███████╗██║██║     ███████╗
╚═════╝ ╚══════╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝     ╚══════╝
                                                                    ]],
				},
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
	},
}
