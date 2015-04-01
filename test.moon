package.path = package.path..";/home/ryanwidi/www/lapis3/resty1/?.lua"
dofile("web.lua")

mysql = require "luasql.mysql"

myconnect "127.0.0.1","root","norikosakai","diggersf_android"


--res=query("select * from transaksi limit 50000")

x=os.clock()
raw '<br>'
raw os.clock()-x
raw 'Seconds'
raw "<hr>"
--x=os.clock()

--for r in *res
--  raw r.idtr," "
for i=1,300000
  raw i%4,' ',i%5

raw n,'rows<br>'
raw os.clock()-x
raw 'Seconds'
raw "<hr>"


finish!