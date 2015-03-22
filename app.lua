dofile("web.lua")
if gets.x == '1' then
  session.data = ''
  cookies.data = ''
end
local view1 = require("views.test")
view1()
cookies.data = "my cookies"
session.data = "my session"
return finish()
