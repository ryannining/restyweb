local DB_BACKEND = "resty1.mymysql"
DB_BACKEND = "resty1.luamysql"
return function()
  local my = require("resty1.luamysql")()
  local inspect = require("resty1.inspect")
  local upload = require("resty.upload")
  local mgk = require("resty1.magick1")
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
  local match = string.match
  sbuffer = { }
  sidx = 1
  local lbuffer = { }
  local lsidx = 0
  local ses = { }
  local session = { }
  local gets = { }
  local posts = { }
  local cookies = { }
  local uploads = { }
  local ck = require("resty1.cookie")
  local xcookie, err = ck:new()
  local xfcookie
  xfcookie, err = xcookie:get_all()
  ses = require("resty1.session").new()
  ses:start()
  session = ses.data
  local m = { }
  m = {
    session = session,
    gets = gets,
    posts = posts,
    uploads = uploads,
    cookies = cookies,
    myconnect = my.myconnect,
    myquery = my.myquery,
    myqueryf = my.myqueryf,
    start = function(data)
      local args = ngx.req.get_uri_args()
      for key, val in pairs(args) do
        gets[key] = val
      end
      uploads = m.getupload(uploads)
      if not uploads then
        ngx.req.read_body()
        args, err = ngx.req.get_post_args()
        for key, val in pairs(args) do
          posts[key] = val
          gets[key] = val
        end
      end
      if xfcookie == nil then
        xfcookie = { }
      end
      for key, val in pairs(xfcookie) do
        cookies[key] = val
      end
      return uploads
    end,
    finish = function()
      for key, val in pairs(cookies) do
        if xfcookie[key] ~= val then
          xcookie:set({
            key = key,
            value = val
          })
        end
      end
      ses:save()
      ngx.print(sbuffer)
      sbuffer = nil
      uploads = nil
      gets = nil
      ngx.exit(ngx.HTTP_OK)
      if ngx.ctx.conn then
        return ngx.ctx.conn:close()
      end
    end,
    getfield = function(res)
      local v = { }
      res[2]:gsub('([^% ^%;^%=]+)%="([^%;]*)";?', function(key, val)
        v[key] = val
      end)
      return v
    end,
    getext = function(filename)
      return string.match(filename, ".+%.(%w+)$")
    end,
    removeext = function(filename)
      return string.gsub(filename, '%....$', '')
    end,
    getupload = function(result)
      local form = upload:new(100000)
      local file_name = ""
      local input_name = ""
      local resx = ""
      while form ~= nil do
        local typ, res
        typ, res, err = form:read()
        if typ == "header" then
          if res[1] == "Content-Disposition" then
            local tt = m.getfield(res)
            file_name = tt.filename
            input_name = tt.name
            resx = nil
          end
        elseif typ == "eof" then
          break
        elseif typ == "body" then
          if input_name and res ~= "" then
            if not resx then
              resx = ""
            end
            resx = resx .. res
          end
        elseif typ == "part_end" then
          if resx then
            if file_name then
              result[input_name] = {
                file_name,
                resx
              }
              posts[input_name] = file_name
            else
              posts[input_name] = resx
            end
            resx = nil
          end
        end
      end
      return result
    end,
    split = function(s, delimiter)
      local result = { }
      for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
      end
      return result
    end,
    explode = function(del, s)
      return m.split(s, del)
    end,
    trim = function(s)
      return match(s, '^()%s*$') and '' or match(s, '^%s*(.*%S)')
    end,
    len = function(t)
      return #t
    end,
    nsay = function(s)
      local json = require("cjson")
      return ngx.say(json.encode(s))
    end,
    str_replace = function(h, c, s)
      return s:gsub(h, c)
    end,
    unslash = function(s)
      if isfill(s) then
        return s:gsub("%\\n", "\n"):gsub("%\\r", "\r"):gsub("%\\", "")
      else
        return ""
      end
    end,
    isempty = function(s)
      return s == false or s == '' or s == nil or s == 0 or s == ngx.null
    end,
    isfill = function(s)
      return not m.isempty(s)
    end,
    aquery = function(q, hash)
      local res = m.myquery(q, hash)
      if m.isempty(res) or #res == 0 then
        return nil
      end
      return res[1]
    end,
    querydict = function(q, idx)
      local res = m.myquery(q)
      local dic = { }
      for i = 1, #res do
        local re = res[i]
        dic[re[idx]] = re
      end
      return dic
    end,
    number_format = function(v)
      local s = string.format("%d", math.floor(v))
      local pos = string.len(s) % 3
      if pos == 0 then
        pos = 3
      end
      return string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos + 1), "(...)", ",%1")
    end,
    raw = function(...)
      local a = {
        ...
      }
      for i = 1, #a do
        sbuffer[sidx] = a[i]
        sidx = sidx + 1
      end
    end,
    craw = function(s)
      return print(s)
    end,
    exists = function(name)
      if type(name) ~= "string" then
        return false
      end
      return os.rename(name, name) and true or false
    end,
    isFile = function(name)
      if type(name) ~= "string" then
        return false
      end
      if not m.exist(name) then
        return false
      end
      local f = io.open(name)
      if f then
        f:close()
        return true
      end
      return false
    end,
    isDir = function(name)
      return (m.exist(name) and not m.isFile(name))
    end,
    inspect = inspect,
    ob_start = function()
      lsidx = sidx
      lbuffer = sbuffer
      sbuffer = { }
      sidx = 1
    end,
    ob_get_contents = function()
      return table.concat(sbuffer)
    end,
    ob_end_clean = function()
      sidx = lsidx
      sbuffer = lbuffer
      lbuffer = nil
    end
  }
  my.finish = m.finish
  return m
end
