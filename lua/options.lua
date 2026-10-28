-- the following yanks everything always to the clipboard
-- vim.opt.clipboard = "unnamedplus"

vim.opt.virtualedit = "block"
vim.opt.termguicolors = true

-- one line per mouse scroll event. A discrete wheel notch arrives as 3 events
-- (macOS reports a notch as ~3 lines), so a notch moves 3 lines; a trackpad
-- tick is 1 event, so it moves 1 line
vim.opt.mousescroll = "ver:1,hor:6"

-- line/tab behaviors
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 88
vim.opt.colorcolumn = { 88, 100 }
vim.opt.cursorline = true
vim.opt.signcolumn = "yes" -- prevent gutter changing width

-- whitespace visualization
vim.opt.listchars = {
	tab = "→ ",
	space = "·",
	trail = "•",
	extends = "⟩",
	precedes = "⟨",
	nbsp = "␣",
}
vim.keymap.set("n", "<leader>l", ":set list!<CR>", { desc = "toggle whitespace characters" })

-- disable tree sitter indenting and just use something local context aware
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.cindent = false
vim.cmd("filetype indent off")

-- vim.opt.formatoptions = "jcroql" -- defaults
-- The reason we have to create this autocmd is that these options are set on a filetype
-- basis and so whatever global default options are, they will get overridden
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.c", "*.cpp", "*lua", "*.py" },
	callback = function()
		-- these remove the behavior that comments are automatically continued on
		-- the next line when inserting a newline either from insert or normal modes
		vim.opt.formatoptions:remove({ "t", "o", "r", "c" })
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- view all of the changes, such as from a search/replace command in a split at the
-- bottom. Helpful because it will show changes not currently visible also
vim.opt.inccommand = "split"

-- ignore type case when doing autocomplete for options and things
vim.opt.ignorecase = true

-- Use tree-sitter for folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- vim.g.mapleader = " " -- setup by lazy.ngim

-- Setup Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
})
local function V_ToggleDiagnostics()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end
vim.keymap.set(
	"n",
	"<leader>bD",
	V_ToggleDiagnostics,
	{ desc = "Toggle diagnostics on and off for the current buffer" }
)

-- Trim trailing whitespace and make exactly one newline
local function trim_whitespace_and_trailing_newlines()
	local save_cursor = vim.fn.getpos(".")
	-- Remove all trailing whitespace
	vim.cmd([[%s/\s\+$//e]])
	-- Remove all trailing newlines
	vim.cmd([[%s/\n\+\%$//e]])
	-- VIM will automatically add a trailing newline when saving the file
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
	pattern = "*",
	callback = trim_whitespace_and_trailing_newlines,
})

-- some useful keymaps
local function close_buffer_preserve_layout()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_win = vim.api.nvim_get_current_win()
	local alt_buf = vim.fn.bufnr("#")

	-- Get all listed buffers
	local buffers = vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and buf ~= current_buf
	end, vim.api.nvim_list_bufs())

	local target_buf = nil

	-- Prefer alternate buffer if it's valid and not current
	if
		alt_buf ~= -1
		and alt_buf ~= current_buf
		and vim.api.nvim_buf_is_valid(alt_buf)
		and vim.bo[alt_buf].buflisted
	then
		target_buf = alt_buf
	elseif #buffers > 0 then
		-- Otherwise use the first available buffer from the list
		target_buf = buffers[1]
	else
		-- No other buffers exist, create new empty buffer
		target_buf = vim.api.nvim_create_buf(true, false)
	end

	-- Explicitly set the target buffer in the current window to preserve layout
	vim.api.nvim_win_set_buf(current_win, target_buf)

	-- Set alternate to prevent toggling on next call
	vim.fn.setreg("#", target_buf)

	-- Delete the original buffer (force delete to avoid prompts)
	vim.api.nvim_buf_delete(current_buf, { force = false })
end

vim.keymap.set("n", "<leader>bd", close_buffer_preserve_layout, { desc = "close a buffer but preserve window layout" })
vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "force close neovim" })

-- autoload .nvim.lua files
vim.o.exrc = true

-- make the background whatever terminal's background is set to
-- local function apply_terminal_bg()
-- 	local transparent_groups =
-- 		{ "Normal", "NormalFloat", "NormalNC", "FloatBorder", "Pmenu", "PmenuSbar", "PmenuThumb" }
-- 	for _, group in ipairs(transparent_groups) do
-- 		vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
-- 	end
-- end
-- apply_terminal_bg()
-- uncomment below if you want this setting every time a colorscheme is loaded
-- vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_terminal_bg })

-- enable syntax highlighting within the language blocks
vim.g.markdown_fenced_languages = { "html", "python", "bash=sh", "cpp", "c" }

-- pyrefly is sending a lot of INFO messages to stderr
-- comment this line out if trying to debug an lsp issue
vim.lsp.log.set_level("WARN")
