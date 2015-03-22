dofile("web.lua")
myconnect("127.0.0.1", "user", "pass", "database")
ck = split(cookies.last or "||||||||||||||", "||")
local res1 = query("select * from customer where telp='" .. tostring(ck[1]) .. "'")
raw("Hello world namaku:" .. tostring(session.namaku) .. ", namamu:" .. tostring(cookies.namamu))
raw("<hr>from view<br>")
glo = "Hi you"
local lc = require("views.test")
lc()
session.namaku = "RYan widi"
cookies.namamu = "Nining"
return finish()
