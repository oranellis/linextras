local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    local function edit_or_enter()
        local node = api.tree.get_node_under_cursor()
        if node.type == "directory" and not node.open then
            api.node.open.edit()
            vim.cmd('normal! j')
        else
            api.node.open.edit()
        end
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Parent Directory'))
    vim.keymap.set('n', 'l', edit_or_enter, opts('Open'))
end

require("nvim-tree").setup({
    on_attach = on_attach,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        centralize_selection = true,
        width = 30,
    },
    actions = {
        change_dir = {
            global = true,
        },
        open_file = {
            quit_on_open = true,
        },
    },
    renderer = {
        group_empty = true,
        highlight_opened_files = "all",
    },
    filters = {
        custom = {
            '.git',
        }
    },
})

vim.keymap.set('n', '<leader>n', function ()
    local api = require('nvim-tree.api')
    api.tree.toggle()
end)

-- Peristent tree functions

-- vim.keymap.set('n', '<leader>n', function ()
--     local view = require("nvim-tree.view")
--     local api = require("nvim-tree.api")
--     if view.is_visible() then
--         if vim.api.nvim_get_current_win() == view.get_winnr() then
--             vim.cmd("wincmd p")
--         else
--             api.tree.focus()
--         end
--     else
--         api.tree.open()
--     end
-- end)

-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         -- Opens the NvimTree on Neovim start
--         require("nvim-tree.api").tree.toggle({ focus = false })
--     end
-- })

-- vim.api.nvim_create_autocmd("BufEnter", {
--     nested = true,
--     callback = function()
--         -- Count the number of windows currently open
--         if #vim.api.nvim_list_wins() == 1 then
--             local bufname = vim.api.nvim_buf_get_name(0)
--             local count = #vim.tbl_filter(function(b)
--                 return vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" end,
--                 vim.api.nvim_list_bufs())
--             if bufname:match("NvimTree_") and count == 0 then
--                 vim.cmd("quit")
--             end
--         end
--     end,
-- })
