-- Example LSP keymap setup
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap.set

	-- LSP navigation
	keymap("n", "gd", vim.lsp.buf.definition, opts)
	keymap("n", "gD", vim.lsp.buf.declaration, opts)
	keymap("n", "gi", vim.lsp.buf.implementation, opts)
	keymap("n", "gr", vim.lsp.buf.references, opts)

	-- Hover / signature help
	keymap("n", "K", vim.lsp.buf.hover, opts)
	keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)

	-- Workspace
	-- TODO: inspect what this is useful for
	-- keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	-- keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	-- keymap("n", "<leader>wl", function()
	--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, opts)

	-- Refactor
	keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
	keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	-- Diagnostics  -- I think these might already be set
	keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
	keymap("n", "[d", function() vim.diagnostic.jump({count = -1}) end, opts)
	keymap("n", "]d", function() vim.diagnostic.jump({count =  1}) end, opts)
	keymap("n", "<leader>q", vim.diagnostic.setqflist, opts)

	-- Formatting - Disabled in favor of conform.nvim
	-- keymap("n", "<leader>cf", function()
	--     vim.lsp.buf.format { async = true }
	-- end, opts)
end

return {
	"neovim/nvim-lspconfig",
	version = "*",
	config = function()
		-- C++
		vim.lsp.config("clangd", { on_attach = on_attach })
		vim.lsp.enable("clangd")

		-- Lua
		vim.lsp.config("lua_ls", {
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")

		-- Python

		-- local python_lsp = "pyrefly"
		-- local python_lsp = "ty"
		local python_lsp = "pyright"

		if python_lsp == "pyrefly" then
			vim.lsp.config("pyrefly", { on_attach = on_attach })
			vim.lsp.enable("pyrefly")
		elseif python_lsp == "ty" then
			vim.lsp.config("ty", { on_attach = on_attach })
			vim.lsp.enable("ty")
		elseif python_lsp == "pyright" then
			vim.lsp.config("pyright", {
				on_attach = on_attach,
				settings = {
					python = {
						analysis = {
							autoImportCompletions = false,
							typeCheckingMode = "off",
						},
					},
				},
			})
			vim.lsp.enable("pyright")
		end

		-- Pyright

		vim.lsp.config("ruff", {})
		vim.lsp.enable("ruff")
	end,
}
