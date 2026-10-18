local function setup_external_apps()
    local json_path = vim.fn.getcwd() .. "/.external_apps.json"

    -- Read and Decode JSON
    local file = io.open(json_path, "r")
    if not file then
        vim.notify("Could not find .external_apps.json", vim.log.levels.ERROR)
        return
    end

    local content = file:read("*a")
    file:close()
    local apps = vim.json.decode(content)

    -- Recursive runner
    local function process_list(list, index, callback)
        if index > #list then
            callback() -- Done with this level
            return
        end

        local app = list[index]

        -- Step 1: Check if installed
        vim.system({ "sh", "-c", app.check_cmd }, {}, function(check_obj)
            local is_installed = (check_obj.code == 0)

            if is_installed then
                vim.schedule(function()
                    vim.notify("[✓] " .. app.name .. " is already installed.", vim.log.levels.INFO)
                end)

                -- Recurse into children, then move to next sibling
                if app.children and #app.children > 0 then
                    process_list(app.children, 1, function()
                        process_list(list, index + 1, callback)
                    end)
                else
                    process_list(list, index + 1, callback)
                end
            else
                -- Step 2: Attempt Install
                if not app.install_cmd or app.install_cmd == "" then
                    vim.schedule(function()
                        vim.notify("[!] " .. app.name .. " missing and no install command.", vim.log.levels.WARN)
                    end)
                    process_list(list, index + 1, callback) -- Skip children, go to next sibling
                    return
                end

                vim.schedule(function()
                    vim.notify("[-] Installing " .. app.name .. "...", vim.log.levels.WARN)
                end)

                vim.system({ "sh", "-c", app.install_cmd }, {}, function(inst_obj)
                    if inst_obj.code == 0 then
                        vim.schedule(function()
                            vim.notify("[+] Success: " .. app.name, vim.log.levels.INFO)
                        end)

                        -- Run post_install if it exists
                        if app.post_install_cmd then
                            vim.system({ "sh", "-c", app.post_install_cmd }, {})
                        end

                        -- Recurse into children after successful install
                        if app.children and #app.children > 0 then
                            process_list(app.children, 1, function()
                                process_list(list, index + 1, callback)
                            end)
                        else
                            process_list(list, index + 1, callback)
                        end
                    else
                        -- Installation failed: Escape children, move to next sibling
                        vim.schedule(function()
                            vim.notify("[X] Failed to install " .. app.name .. ". Skipping branch.", vim.log.levels.ERROR)
                        end)
                        process_list(list, index + 1, callback)
                    end
                end)
            end
        end)
    end

    -- Start the chain
    process_list(apps, 1, function()
        vim.schedule(function()
            vim.notify("Full environment setup check complete.", vim.log.levels.INFO)
        end)
    end)
end

-- Call it
setup_external_apps()
