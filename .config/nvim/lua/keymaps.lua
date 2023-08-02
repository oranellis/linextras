-- custom quit commands
local function check_empty()
	if vim.fn.expand('%:t') == '' then
		if vim.api.nvim_buf_line_count(0) and vim.fn.getline(1) == '' then
			return true
		end
	end
	return false
end

local function custom_quit()
	if vim.fn.expand('%:t') == '' then
		if vim.api.nvim_buf_line_count(0) and vim.fn.getline(1) == '' then
			vim.api.nvim_command('q') -- quit on last invocation of 'q'
		else
			print('Enter a name for this buffer or leave blank to delete')
			local fname = vim.fn.input('File: ')
			if fname == '' then
				vim.api.nvim_command('bd!')
				if check_empty() then
					vim.api.nvim_command('q') -- quit on last invocation of 'q'
				end
			else
				vim.api.nvim_command('w ' .. fname)
				vim.api.nvim_command('bd')
				if check_empty() then
					vim.api.nvim_command('q') -- quit on last invocation of 'q'
				end
			end
		end
	else
		if vim.api.nvim_buf_get_option(0, 'readonly') == true then
			vim.api.nvim_command('bd!')
			if check_empty() then
				vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		elseif vim.api.nvim_buf_get_option(0, 'buftype') ~= '' then
			vim.api.nvim_command('bd!')
			if check_empty() then
				vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		else
			vim.api.nvim_command('w')
			vim.api.nvim_command('bd')
			if check_empty() then
				vim.api.nvim_command('q') -- quit on last invocation of 'q'
			end
		end
	end
end

vim.keymap.set({'n', 't'}, '<leader>q', custom_quit)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>t', vim.cmd.terminal)
vim.keymap.set('n', '<leader>w', vim.cmd.wa)
