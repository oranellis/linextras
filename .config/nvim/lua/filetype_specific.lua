-- Filetype specific and default values
function TabStop(spaces)
	vim.opt_local.tabstop = spaces
	vim.opt_local.softtabstop = spaces
	vim.opt_local.shiftwidth = spaces
	vim.opt_local.expandtab = false
end

vim.api.nvim_create_autocmd({"BufRead"}, {
	pattern = {'*.jsx'},
	callback = function(_)
		TabStop(2)
	end
})
