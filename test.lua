package.path = package.path .. ";/home/ryanwidi/www/lapis3/resty1/?.lua"
dofile("web.lua")
local mysql = require("luasql.mysql")
myconnect("127.0.0.1", "root", "norikosakai", "diggersf_android")
local x = os.clock()
raw('<br>')
raw(os.clock() - x)
raw('Seconds')
raw("<hr>")
for i = 1, 300000 do
  raw(i % 4, ' ', i % 5)
end
raw(n, 'rows<br>')
raw(os.clock() - x)
raw('Seconds')
raw("<hr>")
return finish()
