-- Filetype specific and default values
function TabStop(spaces)
    vim.opt_local.tabstop = spaces
    vim.opt_local.softtabstop = spaces
    vim.opt_local.shiftwidth = spaces
    vim.opt_local.expandtab = true
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.cpp", "*.cc", "*.h", "*.c", "*.hpp"},
    callback = function()
        if vim.fn.executable("clang-format") == 1 then
            vim.cmd("silent! %!clang-format")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rs"},
    callback = function()
        if vim.fn.executable("rustfmt") == 1 then
            vim.cmd("silent! %!rustfmt")
        end
    end,
})

vim.api.nvim_create_autocmd({"BufRead"}, {
    pattern = {'*.jsx'},
    callback = function(_)
        TabStop(2)
    end
})

vim.api.nvim_create_autocmd({"BufRead"}, {
    pattern = {'*.md'},
    callback = function(_)
        vim.opt_local.wrap = true
    end
})

vim.api.nvim_create_autocmd({"BufRead"}, {
    pattern = {'*.py'},
    callback = function(_)
        TabStop(4)
    end
})

vim.api.nvim_create_autocmd({"BufRead"}, {
    pattern = {'*.xml'},
    callback = function(_)
        TabStop(2)
    end
})
