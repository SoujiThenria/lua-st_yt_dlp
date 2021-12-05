--[[
    A try to mimic yt-dlp Python interface in Lua (very simple^^)
]]

local st_yt_dlp_module = {}

local OPTIONS = {
    {"yt-dlp", nil, nil},
    {"ignore_errors", "boolean", "-i"},
    {"quiet", "boolean", "--quiet"},
    {"format", "string", "-f"},
    {"merge_output_format", "string", "--merge-output-format"},
    {"link", nil, nil},
    {"output_path", "string", "-o"},
    {"file_name", "string", "-o"},
}

--[[
if a flag already exists and is not set as nill, 
the last char which should be a "'" gets deleted and 
the other string with that flag is added to the one single string

Example:
"output_path" and "file_name" have both the "-o" flag
"output_path" gets called first the flag with the string for "output_path" is stored in the "used_flags" table.
if "file_name" is now called it deletes the "'" from the path and adds the "file_name" with a "'" at the end.
]]

-- build the command based on the keywords found in the options table
function create_command(link, opts)
    used_flags = {}
    
    local result_command = ""

    for _,option_item in pairs(OPTIONS) do
        local option_name = option_item[1]
        if opts[option_name] ~= nil then
            if type(opts[option_name]) == option_item[2] then
                if option_item[3] ~= nil and used_flags[option_item[3]] == nil and opts[option_name] ~= false then
                        result_command = result_command .. " " .. option_item[3]
                        used_flags[option_item[3]] = nil

                    if option_item[2] ~= "boolean" then
                        result_command = result_command .. " '" .. opts[option_name] .. "'"
                        used_flags[option_item[3]] = opts[option_name]
                    end
                elseif used_flags[option_item[3]] ~= nil then
                    result_command = result_command:sub(1, -2)
                    result_command = result_command .. opts[option_name] .. "'"
                end
            end
        elseif option_name == "yt-dlp" then
            if result_command == "" then
                result_command = result_command .. "yt-dlp"
            else
                result_command = result_command .. " yt-dlp"
            end
        elseif option_name == "link" then 
            result_command = result_command .. " '" .. link .. "'"
        end
    end
    
    result_command = result_command .. " 2>&1"

    return result_command
end

-- update yt-dlp
function st_yt_dlp_module.update()
    local handle = io.popen("yt-dlp --update 2>&1")
    local result = handle:read("*a")
    handle:close()
    if string.find(result, "ERROR:") then
        return false
    else
        return true
    end
end

-- test if 'program' can be found via the environment variable
function st_yt_dlp_module.executeable(program)
    local PATH = os.getenv("PATH")
    local t = {}
    local seperator = ":"
    for str in string.gmatch(PATH, "([^" .. seperator .. "]+)") do
        local f = io.open(str .. "/" .. program, "r")
        if f ~= nil then io.close(f) return true end
    end
    return false
end

-- print the command which would be executed
function st_yt_dlp_module.print_download(link, opts)
    print(create_command(link, opts))
end

-- starts the execution and returns file with the 'realtime' output of yt-dlp
function st_yt_dlp_module.download(link, opts)
    local command = create_command(link, opts)
    return io.popen(command)
end

-- starts the execution and returns after the execution finished a file with the output
function st_yt_dlp_module.silent_download(link, opts)
    local command = create_command(link, opts)
    local handle = io.popen(command)
    local output = handle:read("*a")
    handle:close()
    return output
end

return st_yt_dlp_module
