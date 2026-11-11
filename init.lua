-- options sets the leader keys, so it must load before lazy.nvim
require("options")
-- NVIM_NO_PLUGINS=1 runs a plain neovim (used on machines where plugins aren't set up)
if vim.env.NVIM_NO_PLUGINS ~= "1" then
	require("config.lazy")
end
require("tlayout")
