return function()
  local mysql = require("resty1.mysql")
  local logcolor = {
    '\033[95m',
    '\033[94m',
    '\033[92m',
    '\033[93m',
    '\033[91m',
    '\033[0m',
    '\033[1m',
    '\033[4m'
  }
  local m = { }
  local mydb = mysql:new()
  m = {
    myconnect = function(server, username, passw, base)
      mydb:set_timeout(10000)
      local ok, err, errno, sqlstate = mydb:connect({
        host = server,
        port = 3306,
        database = base,
        user = username,
        password = passw,
        max_packet_size = 1024 * 1024
      })
      if not ok then
        print(logcolor[1], "failed to connect: ", err, ": ", errno, " ", sqlstate)
        return m.finish()
      end
    end,
    myqueryf = function(sql, hash)
      mydb:send_query(sql)
      return mydb:fread_result()
    end,
    myquery = function(sql, hash)
      local res, err, errno, sqlstate = mydb:query(sql)
      if not res then
        print(logcolor[2], "\nSQL:\n" .. sql .. "\nbad result: ", err, ": ", errno, ": ", sqlstate, ".")
        m.finish()
      end
      return res
    end,
    close = function()
      return mydb:set_keepalive(10000, 10)
    end
  }
  return m
end
