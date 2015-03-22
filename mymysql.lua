-- mysql
local mysql = require "resty.mysql"
local m={}
local logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}

function m.myconnect(server,username,passw,base)
  ngx.ctx.mydb,err=mysql:new()
  ngx.ctx.mydb:set_timeout(1000)
  ok, err, errno, sqlstate = ngx.ctx.mydb:connect{
                    host = server,
                    port = 3306,
                    database = base,
                    user = username,
                    password = passw,
                    max_packet_size = 1024 * 1024 }
  if not ok then
      print(logcolor[1],"failed to connect: ", err, ": ", errno, " ", sqlstate)
      m.finish()
  end
end
function m.myquery(sql)
  if string.find(sql,'nil')~=nil then print (logcolor[3],"\n\nSQL with NIL:\n"..sql.."\n\n") end
  res, err, errno, sqlstate=ngx.ctx.mydb:query(sql)
  if not res then
      print (logcolor[2],"\nSQL:\n"..sql.."\nbad result: ", err, ": ", errno, ": ", sqlstate, ".")
      m.finish()
  end
  return res
end
return m