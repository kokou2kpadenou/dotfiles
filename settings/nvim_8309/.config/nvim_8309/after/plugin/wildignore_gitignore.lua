-- Function to read .gitignore and set wildignore
local function setup_gitignore_wildignore()
    -- Find the root directory of the current git repository
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

    -- Check if we are in a git repository
    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        -- Read the .gitignore file content
        local gitignore_path = git_root .. '/.gitignore'
        local gitignore_file = io.open(gitignore_path, "r")

        if gitignore_file then
            local lines = {}
            for line in gitignore_file:lines() do
                -- Trim whitespace and ignore comments/empty lines
                line = line:match("^%s*(.-)%s*$")
                if line ~= "" and not line:match("^#") then
                    -- Convert .gitignore patterns to Vim-compatible wildignore patterns
                    -- Append '*/' for directory patterns
                    if line:sub(-1) == '/' then
                        table.insert(lines, line .. '*')
                    else
                        table.insert(lines, line)
                    end
                end
            end
            io.close(gitignore_file)

            -- Set the global 'wildignore' option using a Lua table
            vim.opt.wildignore = lines
            -- Optionally, add standard Neovim ignores (e.g., swp, bak files)
            -- vim.opt.wildignore:append({'*.swp', '*.bak'})
        end
    end
end

-- Call the function on Neovim startup
setup_gitignore_wildignore()

-- You might also want to call this using a FileReadPost or DirChanged autocmd
-- to update when you switch projects or files
vim.api.nvim_create_autocmd({"BufEnter", "DirChanged"}, {
    callback = setup_gitignore_wildignore,
    desc = "Update wildignore based on .gitignore in the current git root",
})

