--[[
Author: Geffrey Chen
Date: 2021-08-05 18:19:56
--]]

local real_ip=ngx.var.http_x_forwarded_for or ngx.var.remote_addr
local ip_whiteList = {
    "1.1.1.1",
    "2.2.2.2"
}

-- 判断是否白名单IP
function is_whitelist(value, tab)
    for k,v in ipairs(tab) do
        if v == value then
            return true
        end
    end
    return false
end

if is_whitelist(real_ip, ip_whiteList) then
    return "whiteserverlist"
else
    return "serverlist"
end