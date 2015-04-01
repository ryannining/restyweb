return function()
  local mysql = require("luasql.mysql")
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
  env = nil
  conn = nil
  m = {
    myconnect = function(server, username, passw, base)
      env = mysql.mysql()
      conn = env:connect(base, username, passw, server)
    end,
    myqueryf = function(sql, hash)
      if not hash then
        hash = "a"
      else
        hash = "n"
      end
      local row = { }
      local cursor = conn:execute(sql)
      return function()
        return cursor:fetch(row, hash)
      end
    end,
    myquery = function(sql, hash)
      if not hash then
        hash = "a"
      else
        hash = "n"
      end
      local cursor, errorString = conn:execute(sql)
      if type(cursor) ~= 'number' then
        local r = cursor:fetch({ }, hash)
        local res = { }
        local i = 1
        while r do
          res[i] = r
          i = i + 1
          r = cursor:fetch({ }, hash)
        end
        return res
      else
        if errorString then
          print("\n\n", sql, "\n", errorString, "\n\n")
          return m.finish()
        end
      end
    end,
    close = function()
      conn:close()
      return env:close()
    end
  }
  return m
end
