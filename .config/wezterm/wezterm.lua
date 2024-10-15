-- 加载 wezterm API 和获取 config 对象
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-------------------- 颜色配置 --------------------
config.color_scheme = "tokyonight_moon"
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- 设置字体和窗口大小
config.font = wezterm.font("Fira Code")
config.font_size = 14
config.initial_cols = 140
config.initial_rows = 35
config.window_padding = { left = 9, right = 0, top = 0, bottom = "1cell" }
-- my coolnight colorscheme
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}
config.window_background_opacity = 0.9
config.macos_window_background_blur = 80

-- 设置默认的启动shell
config.set_environment_variables = {
	COMSPEC = "/bin/fish",
}

-------------------- 键盘绑定 --------------------
local act = wezterm.action

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "q", mods = "LEADER", action = act.QuitApplication },

	{ key = "h", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "CTRL", action = act.CloseCurrentPane({ confirm = false }) },

	{ key = "{", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "}", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
	--	{ key = "k", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
	--	{ key = "j", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
	-- F11 切换全屏
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
	-- Ctrl+Shift+C 复制选中区域
	{ key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	-- Ctrl+Shift+V 粘贴剪切板的内容
	{ key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
	-- Ctrl+Shift+PageUp 向上滚动一页
	{ key = "PageUp", mods = "SHIFT|CTRL", action = act.ScrollByPage(-1) },
	-- Ctrl+Shift+PageDown 向下滚动一页
	{ key = "PageDown", mods = "SHIFT|CTRL", action = act.ScrollByPage(1) },

	-- CTRL + T 创建默认的Tab
	{ key = "t", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
	-- CTRL + W 关闭当前Tab
	{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
}

for i = 1, 8 do
	-- CTRL + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = act.ActivateTab(i - 1),
	})
end

-------------------- 鼠标绑定 --------------------
config.mouse_bindings = {
	-- copy the selection
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},

	-- Open HyperLink
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return config
