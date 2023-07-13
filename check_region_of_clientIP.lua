--[[
Author: Geffrey Chen
Date: 2021-07-20 14:45:29
--]]


-- local cjson=require 'cjson'
local geo=require('resty.maxminddb')
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

-- 初始化geoip
if not geo.initted() then
    geo.init("/usr/local/openresty/lualib/GeoIP2-City.mmdb")
end

-- 正式逻辑
local res,err=geo.lookup(real_ip)

if not res then
    ngx.log(ngx.ERR, "Can not found. errMsg: ", err)
    return ngx.exit(ngx.HTTP_NOT_FOUND)
else
    if is_whitelist(real_ip, ip_whiteList) and res["country"]["iso_code"] == "JP" then
        return
    else
        ngx.log(ngx.ERR, "Access Forbbiden! request_ip: ", real_ip, " area: ", res["country"]["iso_code"])
        return ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end
