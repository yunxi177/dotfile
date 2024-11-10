-- 加载 wezterm API 和获取 config 对象
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-------------------- 颜色配置 --------------------
config.color_scheme = "tokyonight_moon"
config.window_decorations = "NONE"
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- 设置字体和窗口大小
config.font = wezterm.font("Fira Code", { weight = "Regular" })

config.font_size = 14
config.initial_cols = 140
config.initial_rows = 35
config.window_padding = { left = 10, right = 10, top = 0, bottom = 0 }
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

local function resize_pane(key, direction)
	return {
		key = key,
		action = wezterm.action.AdjustPaneSize({ direction, 3 }),
	}
end
local projects = require("projects")
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "q", mods = "LEADER", action = act.QuitApplication },

	{ key = "'", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "5", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "p",
		mods = "LEADER",
		-- Present in to our project picker
		action = projects.choose_project(),
	},
	{
		key = "f",
		mods = "LEADER",
		-- Present a list of existing workspaces
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		-- When we push LEADER + R...
		key = "r",
		mods = "LEADER",
		-- Activate the `resize_panes` keytable
		action = wezterm.action.ActivateKeyTable({
			name = "resize_panes",
			-- Ensures the keytable stays active after it handles its
			-- first keypress.
			one_shot = false,
			-- Deactivate the keytable after a timeout.
			timeout_milliseconds = 1000,
		}),
	},
	{ key = "q", mods = "CTRL", action = act.CloseCurrentPane({ confirm = false }) },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	-- F11 切换全屏
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
	-- Ctrl+Shift+C 复制选中区域
	{ key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	-- Ctrl+Shift+V 粘贴剪切板的内容
	{ key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
	-- Ctrl+Shift+PageUp 向上滚动一页
	{ key = "PageUp", mods = "", action = act.ScrollByPage(-1) },
	-- Ctrl+Shift+PageDown 向下滚动一页
	{ key = "PageDown", mods = "", action = act.ScrollByPage(1) },

	-- CTRL + T 创建默认的Tab
	{ key = "t", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
	-- CTRL + W 关闭当前Tab
	-- { key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
}
config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
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

-- Replace the old wezterm.on('update-status', ... function with this:

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wezterm.strftime("%a %b %-d %H:%M"),
		-- wezterm.hostname(),
	}
end

wezterm.on("update-status", function(window)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to, gradient_from = bg
	gradient_from = gradient_to:lighten(0.2)

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)
return config
