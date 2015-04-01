dofile("web.lua")
local mysql = require("luasql.mysql")
myconnect("127.0.0.1", "root", "norikosakai", "diggersf_android")
local s = { }
local x = os.clock()
local si = 1
local nama = "Ryan widi"
for i = 1, 1000000 do
  s[si] = i .. (i + 1) .. (i + 5) .. (i + 11) .. (i + 20) .. nama
  si = si + 1
end
raw(os.clock() - x)
raw('Seconds')
raw("<hr>")
raw(jit.version)
return finish()
