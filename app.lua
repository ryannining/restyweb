dofile("web.lua")
myconnect("127.0.0.1", "root", "norikosakai", "ledhemat")
if gets.x == '1' then
  session.data = ''
  cookies.data = ''
end
glo = "yes global"
local view1 = require("views.test")
view1()
cookies.data = "my cookies"
session.data = "my session"
return finish()
