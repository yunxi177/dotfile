--local discipline = require("craftzdog.discipline")

--discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<leader>oa", ":AiderOpen --no-auto-commits --deepseek<CR>", { noremap = true, silent = true })
-- keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
-- 生成注释
keymap.set("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
keymap.set("n", "<Leader>nc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
keymap.set("n", "<Leader>nt", ":lua require('neogen').generate({ type = 'type' })<CR>", opts)
-- 关闭所有 buffer
keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
keymap.set("n", "L", "g_", opts)
keymap.set("n", "H", "^", opts)
keymap.set("i", "<Esc>", function()
	local luasnip = require("luasnip")
	if luasnip.in_snippet() then
		luasnip.unlink_current()
	end
	return "<Esc>"
end, { expr = true, noremap = true, silent = true, desc = "清除片段上下文" })

-- local ls = require("luasnip")
-- keymap.set({ "i" }, "<C-E>", function()
-- 	ls.expand()
-- end, { silent = true })
-- keymap.set({ "i", "s" }, "<C-J>", function()
-- 	ls.jump(1)
-- end, { silent = true })
-- keymap.set({ "i", "s" }, "<C-K>", function()
-- 	ls.jump(-1)
-- end, { silent = true })
--
-- keymap.set({ "i", "s" }, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })
-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
--keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})
vim.keymap.set("n", "<leader>ld", "<cmd>LazyDocker<CR>", { desc = "Toggle LazyDocker", noremap = true, silent = true })

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit <CR>")
keymap.set("n", "tw", ":tabclose <CR>")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
-- Resize window
keymap.set("n", "<C-Up>", "<C-w>+")
keymap.set("n", "<C-Down>", "<C-w>-")
keymap.set("n", "<C-right>", "<C-w><")
keymap.set("n", "<C-left>", "<C-w>>")

keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")
-- delete without overwrite p
vim.keymap.set("n", "x", '"_d', { noremap = true })
vim.keymap.set("v", "x", '"_d', { noremap = true })

-- leader + sc 复制选中内容到系统剪贴板
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "yu", '"+yy', { noremap = true, silent = true })

-- keymap.set("n", "<leader>r", function()
-- 	require("craftzdog.hsl").replaceHexWithHSL()
-- end)
