local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
})
