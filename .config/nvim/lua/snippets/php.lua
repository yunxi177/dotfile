local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- 向上查找最近的 composer.json 所在目录
local function find_project_root(filepath)
	local dir = vim.fn.fnamemodify(filepath, ":h")
	while dir and dir ~= "/" do
		if vim.fn.filereadable(dir .. "/composer.json") == 1 then
			return dir
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return nil
end

-- 读取并 decode composer.json
local function load_composer(ps_path)
	local lines = vim.fn.readfile(ps_path)
	if vim.tbl_isempty(lines) then
		return nil, "无法读取 " .. ps_path
	end
	local ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not ok then
		return nil, "JSON 解析失败：" .. data
	end
	return data, nil
end

-- 主函数：返回 PHP 命名空间（不含类名）
local function get_namespace()
	local filepath = vim.fn.expand("%:p")
	local project_root = find_project_root(filepath)
	if not project_root then
		print("❌ 未找到 composer.json，无法确定项目根目录")
		return
	end

	local composer, err = load_composer(project_root .. "/composer.json")
	if not composer then
		print("❌ " .. err)
		return
	end

	-- 先尝试 PSR-4
	local psr4 = composer["autoload"] and composer["autoload"]["psr-4"]
	if psr4 then
		for ns, rel in pairs(psr4) do
			local key_ns = ns:gsub("\\+$", "")
			local key_path = (project_root .. "/" .. rel):gsub("/+$", "")
			if filepath:sub(1, #key_path) == key_path then
				local rel_file = filepath:sub(#key_path + 2):gsub("%.php$", ""):gsub("/", "\\")
				local dir_part = rel_file:match("(.+)\\[^\\]+$") or ""
				local php_ns = key_ns .. (dir_part ~= "" and ("\\" .. dir_part) or "")
				print("✅ Namespace（PSR-4）：", php_ns)
				return php_ns
			end
		end
	end

	-- PSR-4 未命中：仅用文件相对路径（去掉根目录名）生成 namespace
	-- 1. 得到相对路径（带子目录和文件名），转为反斜杠
	local rel = filepath:sub(#project_root + 2):gsub("%.php$", ""):gsub("/", "\\")
	-- 2. 去掉文件名，只保留目录结构
	local dir_part = rel:match("(.+)\\[^\\]+$") or rel
	local php_ns = dir_part
	print("⚠️ 默认 Namespace（去掉根目录）：", php_ns)
	return php_ns
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
	s("phpinterface", {
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
		t("interface "),
		f(function()
			return get_class_name()
		end, {}),
		t({ "", "{" }),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s("phpabclass", {
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
		t("abstract class "),
		f(function()
			return get_class_name()
		end, {}),
		t({ "", "{" }),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
})
