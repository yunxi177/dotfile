return {
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
			},
		},
	},
}
