dofile("web.lua")

mysql = require "luasql.mysql"

myconnect "127.0.0.1","root","norikosakai","diggersf_android"


x=os.clock()
fetch=queryf("select * from transaksi limit 100000")
raw '<br>'
raw os.clock()-x
raw 'Seconds'
raw "<hr>"
--x=os.clock()
r=fetch()
while r
  raw r.totalprice,r.jumlah,r.idmtr
  r=fetch()

raw '<br>'
raw os.clock()-x
raw 'Seconds'
raw "<hr>"


finish!