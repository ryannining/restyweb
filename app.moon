dofile("web.lua")
myconnect "127.0.0.1","root","norikosakai","ledhemat"
if gets.x=='1'
  session.data=''
  cookies.data=''
export glo="yes global"
view1=require("views.test")
view1!

cookies.data="my cookies"
session.data="my session"
finish!