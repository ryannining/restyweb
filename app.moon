dofile("web.lua")
if gets.x=='1'
  session.data=''
  cookies.data=''
view1=require("views.test")
view1!

cookies.data="my cookies"
session.data="my session"
finish!