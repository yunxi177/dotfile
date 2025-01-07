return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},
	{
		"sainnhe/gruvbox-material",
		priority = 1000, -- 确保此主题的加载优先级高于其他插件
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_background = "medium"
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = function()
			return {
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				transparent_background = false,
			}
		end,
	},
}
