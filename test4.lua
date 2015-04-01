dofile("web.lua")
myconnect("127.0.0.1", "root", "norikosakai", "diggersf_android")
local fetch = queryf("select * from produk")
while true do
  local row = fetch()
  if not row then
    break
  end
  raw(inspect(row))
end
return finish()
