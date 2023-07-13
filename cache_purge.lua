--[[
Author: Geffrey Chen
Date: 2022-04-21 16:16:08
--]]

-- 判断字符串开头
function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end
 
-- 判断字符串结尾
function string.ends(String,End)
    return End=='' or string.sub(String,-string.len(End))==End
end

cache_path = ngx.var.cache_path

if string.ends(ngx.var[1], '/') then
    clear_uri = ngx.var[1]
elseif string.ends(ngx.var[1], '*') then
    clear_uri = string.match(ngx.var[1], '(%S+)*')
else
    clear_uri = ngx.var[1] .. '$'
end

ret_res = "CLEAR URI: " .. ngx.var[1] .. "\n"
success_file = ""
failed_file = ""
-- 获取匹配的文件
stat, res, code = os.execute("find " .. cache_path .. " -type f |xargs grep 'KEY: " .. clear_uri .. "' > /tmp/cache_files.txt")
if stat == false then
    ngx.exit(500)
end

-- 对已匹配的文件进行处理
for line in io.lines("/tmp/cache_files.txt") do
    file_name = string.match(line, "Binary file (%S+) matches")
    -- 获取需要清理的文件名
    for li in io.lines(file_name) do
        file_uri = string.match(li, "KEY: (%S+)")
        if file_uri ~= nil then
            break
        end
    end

    stat = os.remove(file_name)
    if stat == true then
        success_file = success_file .. file_uri .. '\n'
    else
        failed_file = failed_file ..  file_uri .. '\n'
    end
end

-- 打印结果
if failed_file == "" then
    ret_res = ret_res .. "SUCESS FILE: \n" .. success_file
    ngx.say(ret_res)
    ngx.exit(200)
else
    ret_res = ret_res .. "SUCESS FILE: \n" .. success_file .. "FAILED FILE: \n" .. failed_file
    ngx.say(ret_res)
    ngx.exit(500)
end