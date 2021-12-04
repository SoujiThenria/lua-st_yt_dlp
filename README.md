# lua-st_yt_dlp

This is a simple yt-dlp wrapper written in Lua.  
Below is one example which you can copy and execute, moreover are the available functions explained further below.
To install, place st_yt_dlp.lua wherever you need the module to be.

Currently there are not that many options supported. But if there is enough interest in this wrapper, the command list can be easily expanded.

## Example
Downbelow is an example how to use the module.
```lua
local st_yt_dlp = require("st_yt_dlp")

local cool_videos = {
        "https://www.youtube.com/watch?v=n353dOY1D3U&ab_channel=KINGAMV%27s%E5%A4%A2",
        "https://www.youtube.com/watch?v=JSpK8LxBKqQ&ab_channel=Prettyok",
}
local cool_options = {
    ["file_name"] = "%(title)s.%(ext)s",
    ["output_path"] = "~/Videos/yt_dlp_downloads/",
    ["format"] = "bestvideo[vcodec!^=av0]+bestaudio",
    ["ignore_errors"] = true,
    ["merge_output_format"] = "mp4",
}

local downloads = {
    [cool_videos] = cool_options
}


for links,opts in pairs(downloads) do
    for _,link in pairs(links) do
        local output = st_yt_dlp.download(link, opts)
        for line in output:lines() do
            print(line)
        end
        output:close()
    end
end

```

## Functions
There are a couple of functions in the module. They are listed below with example code.

`update()` updates yt-dlp and returns *true* or *false* based on the output of the command.
```lua
if not st_yt_dlp.update() then
    print("[ERROR]" .. " yt-dlp update failed")
    os.exit(-1)
end
```

`executeable(program)` checks if *program* can be opened via the paths specified in the environment variable. Returns *true* or *false*.
```lua
if not st_yt_dlp.executeable("yt-dlp") then
    print("[ERROR]" .. " yt-dlp does not exist or is not accessable via the PATH variable")
    os.exit(-1)
end
```

`print_download(link, opts)` prints the command which would be executed.
```lua
st_yt_dlp.print_download("https://www.youtube.com/watch?v=JSpK8LxBKqQ&ab_channel=Prettyok", cool_options)
```

`download(link, opts)` starts the execution and returns file with the 'realtime' output of yt-dlp. The file have to be closed after the execution.
```lua
local output = st_yt_dlp.print_download("https://www.youtube.com/watch?v=JSpK8LxBKqQ&ab_channel=Prettyok", cool_options)
for line in output:lines() do
    print(line)
end
output:close()
```

`silent_download(link, opts)` starts the execution and returns after the execution finished a file with the output.
```lua
local output = st_yt_dlp.print_download("https://www.youtube.com/watch?v=JSpK8LxBKqQ&ab_channel=Prettyok", cool_options)
print(output)
```
