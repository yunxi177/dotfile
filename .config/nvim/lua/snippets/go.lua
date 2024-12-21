local ls = require("luasnip")
local rep = require("luasnip.extras").rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

-- 定义 Go 类型的代码片段
ls.add_snippets("go", {
	-- 函数模板
	s("func", {
		t({ "func " }),
		i(1, "FunctionName"),
		t("("),
		i(2, "params"),
		t({ ") ", "" }),
		t({ "{", "\t" }),
		i(3, "// TODO: implement function"),
		t({ "", "}" }),
	}),
	-- main 函数模板
	s("main", {
		t({ "package main", "", 'import "fmt"', "", "func main() {", '\tfmt.Println("' }),
		i(1, "Hello, World!"),
		t({ '")', "}" }),
	}),
	-- if err != nil 模板
	s("iferr", {
		t({ "if err != nil {", "\treturn " }),
		i(1, "err"),
		t({ "", "}" }),
	}),
	s("iferr500", {
		t({ "if err != nil {" }),
		t({ "", "\thttpresponse.Error(c, http.StatusInternalServerError, err.Error(), httpresponse.ERROR_CODE_FAIL)" }),
		t({ "", "}" }),
	}),
	s("iferr400", {
		t({ "if err != nil {" }),
		t({ "", "\thttpresponse.Error(c, http.StatusBadRequest, err.Error(), httpresponse.ERROR_CODE_FAIL)" }),
		t({ "", "}" }),
	}),
	s("genstruct", {
		t({ "type " }),
		i(1),
		t({ " struct{}" }),
		t({ "", "", "func New" }),
		d(2, function(args) -- 动态节点，实时捕获 i(1) 的值
			return sn(nil, {
				t(args[1][1] or "StructName"), -- 如果为空则使用默认值
			})
		end, { 1 }),
		t({ "() *" }),
		rep(1),
		t({ " {" }),
		t({ "", "\treturn &" }),
		rep(1),
		t({ "{}" }),
		t({ "", "}" }),
	}),
	s("genaction", {
		t({ "func (h *" }),
		i(1),
		t({ ") " }),
		i(2),
		t({ "(c *gin.Context) { " }),
		t({ "", "", "}" }),
	}),
})
