local util = require("conform.util")
return {
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
					-- php = { "pint" },
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
}
