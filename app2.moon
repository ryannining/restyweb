-- make common function as global to make easier to coding
dofile("web.lua")
myconnect "127.0.0.1","user","pass","database"
export ck=split(cookies.last or "||||||||||||||","||")
res1=query("select * from customer where telp='#{ck[1]}'")
raw "Hello world namaku:#{session.namaku}, namamu:#{cookies.namamu}"
raw "<hr>from view<br>"
export glo="Hi you"
lc=require("views.test")
lc!
session.namaku="RYan widi"
cookies.namamu="Nining"
finish!