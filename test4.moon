dofile("web.lua")

myconnect "127.0.0.1","root","norikosakai","diggersf_android"

fetch=queryf("select * from produk limit 4")
while true
  row=fetch()
  if not row then break
  raw inspect(row)

finish!