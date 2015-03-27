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
m = {
  myconnect = function(server, username, passw, base)
    ngx.ctx.env = mysql.mysql()
    ngx.ctx.conn = ngx.ctx.env:connect(base, username, passw, server)
  end,
  myqueryf = function(sql, hash)
    if not hash then
      hash = "a"
    else
      hash = "n"
    end
    local row = { }
    local cursor = ngx.ctx.conn:execute(sql)
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
    local cursor, errorString = ngx.ctx.conn:execute(sql)
    if type(cursor) ~= 'number' then
      local r = cursor:fetch({ }, hash)
      local res = { }
      while r do
        res[#res + 1] = r
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
    ngx.ctx.conn:close()
    return ngx.ctx.env:close()
  end
}
return m
