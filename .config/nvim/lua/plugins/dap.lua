return {
	-- 主插件: nvim-dap
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy", -- 或根据需要触发加载
		priority = 1000,
		config = function()
			local dap = require("dap")

			-- 配置 GDB 调试适配器
			dap.adapters.gdb = {
				type = "executable",
				command = "arm-none-eabi-gdb", -- 替换为你的 GDB 可执行文件路径
				name = "gdb",
			}

			-- 配置 STM32 的调试任务
			dap.configurations.c = {
				{
					name = "Debug STM32",
					type = "gdb",
					request = "launch",
					program = "${workspaceFolder}/Debug/learn.elf", -- 替换为实际 ELF 文件路径
					cwd = "${workspaceFolder}",
					miDebuggerPath = "arm-none-eabi-gdb", -- 替换为 GDB 路径
					target = "localhost:3333", -- OpenOCD 的默认调试端口
					remote = true,
				},
			}

			-- 断点快捷键（可选）
			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "启动调试" })
			vim.keymap.set("n", "<F8>", function()
				dap.toggle_breakpoint()
			end, { desc = "切换断点" })
			vim.keymap.set("n", "<F9>", function()
				dap.step_over()
			end, { desc = "单步执行" })
			vim.keymap.set("n", "<F10>", function()
				dap.step_into()
			end, { desc = "进入函数" })
			vim.keymap.set("n", "<F11>", function()
				require("dap").step_out()
			end, { desc = "跳出函数" })
		end,
	},

	-- 可视化界面: nvim-dap-ui
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		priority = 900,
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dapui = require("dapui")

			-- 配置 UI
			dapui.setup()

			-- 自动打开/关闭 UI
			local dap = require("dap")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- 虚拟文本: nvim-dap-virtual-text
	{
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		priority = 800,
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- 依赖树: mason-nvim-dap
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		priority = 700,
		dependencies = { "mfussenegger/nvim-dap", "williamboman/mason.nvim" },
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb", "gdb" }, -- 自动安装调试工具
				automatic_installation = true,
			})
		end,
	},
	{ "nvim-neotest/nvim-nio" },
}
