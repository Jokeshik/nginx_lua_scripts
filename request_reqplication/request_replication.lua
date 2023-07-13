--[[
Author: Geffrey Chen
Date: 2023-06-14 10:44:54
--]]

local METHOD = nil
if ngx.req.get_method() == "POST" then
    METHOD = ngx.HTTP_POST
else
    METHOD = ngx.HTTP_GET
end

local res1, res2, res3 = ngx.location.capture_multi {
    {"/cleardbmem1", {method = METHOD}},
    {"/cleardbmem2", {method = METHOD}},
    {"/cleardbmem3", {method = METHOD}},
}
ngx.header['Content-Type'] = 'application/json'
if res1.status == ngx.HTTP_OK then
    ngx.say(res1.body)
end
if res2.status == ngx.HTTP_OK then
    ngx.say(res2.body)
end
if res3.status == ngx.HTTP_OK then
    ngx.say(res3.body)
end