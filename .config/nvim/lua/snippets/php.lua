local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function extract_before_slash(input)
	local slash_pos = string.find(input, "/")
	if slash_pos then
		return string.sub(input, 1, slash_pos - 1)
	end
	return input -- 如果没有斜杠，返回整个字符串
end
local function get_namespace()
	-- 获取当前文件路径
	local filepath = vim.fn.expand("%:p")
	-- 假设项目代码存放在 src 目录下
	local namespaceBase = {
		["weiqing/addons"] = "",
		["dy_takeout/app"] = "dy_takeout/App",
	}
	local src_index
	local projectNmae

	for project, alias in pairs(namespaceBase) do
		src_index = filepath:find(project .. "/")
		if src_index then
			projectNmae = project
			if alias ~= "" then
				filepath = filepath:gsub(project, alias)
			end
			break
		end
	end
	if not src_index then
		return ""
	end
	projectNmae = extract_before_slash(projectNmae)
	-- 提取 src/ 之后的路径
	local namespace = filepath:sub(src_index + string.len(projectNmae) + 1):gsub("/", "\\")
	-- 去掉文件名部分
	namespace = namespace:match("(.+)\\[^\\]+%.php$")
	return namespace
end

local function get_class_name()
	-- 获取文件名去掉扩展名
	return vim.fn.expand("%:t:r")
end

-- 定义 PHP 类型的代码片段
ls.add_snippets("php", {
	-- 函数模板
	s("phpclass", {
		t("<?php"),
		t({ "", "", "" }),
		f(function()
			local namespace = get_namespace()
			if namespace and namespace ~= "" then
				return "namespace " .. namespace .. ";"
			end
			return ""
		end, {}),
		t({ "", "", "" }),
		t("class "),
		f(function()
			return get_class_name()
		end, {}),
		t({ "", "{" }),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
})
