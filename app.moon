dofile("web.lua")
view1=require("views.test")
view1!

cookies.data="my cookies"
session.data="my session"
finish!