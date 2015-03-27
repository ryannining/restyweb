local my = require("resty1.mymysql")
local json = require("cjson")
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
m = {
  myconnect = my.myconnect,
  myquery = my.myquery,
  myqueryf = my.myqueryf,
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
    local arg = {
      ...
    }
    local i = 0
    for i = 1, #arg do
      local v = arg[i]
      if type(v) == 'function' then
        v()
      else
        ngx.ctx.sbuffer[#ngx.ctx.sbuffer + 1] = tostring(v)
      end
    end
  end,
  craw = function(s)
    return print(s)
  end,
  start = function()
    local ck = require("resty1.cookie")
    local err
    ngx.ctx.xcookie, err = ck:new()
    ngx.ctx.xfcookie, err = ngx.ctx.xcookie:get_all()
    ngx.ctx.ses = require("resty1.session").new()
    ngx.ctx.ses:start()
    ngx.ctx.session = ngx.ctx.ses.data
    ngx.ctx.sbuffer = { }
    local args = ngx.req.get_uri_args()
    ngx.ctx.gets = { }
    for key, val in pairs(args) do
      ngx.ctx.gets[key] = val
    end
    ngx.ctx.uploads = m.getupload()
    ngx.req.read_body()
    ngx.ctx.posts = { }
    args, err = ngx.req.get_post_args()
    for key, val in pairs(args) do
      ngx.ctx.posts[key] = val
      ngx.ctx.gets[key] = val
    end
    ngx.ctx.cookies = { }
    if ngx.ctx.xfcookie == nil then
      ngx.ctx.xfcookie = { }
    end
    for key, val in pairs(ngx.ctx.xfcookie) do
      ngx.ctx.cookies[key] = val
    end
    return ngx.ctx.uploads
  end,
  finish = function()
    for key, val in pairs(ngx.ctx.cookies) do
      if ngx.ctx.xfcookie[key] ~= val then
        ngx.ctx.xcookie:set({
          key = key,
          value = val
        })
      end
    end
    ngx.ctx.ses:save()
    ngx.say(ngx.ctx.sbuffer)
    ngx.ctx.sbuffer = { }
    if ngx.ctx.conn then
      ngx.ctx.conn:close()
    end
    ngx.ctx.uploads = nil
    ngx.ctx.gets = nil
    return ngx.exit(ngx.HTTP_OK)
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
  getupload = function()
    local form = upload:new(100000)
    local file_name = ""
    local input_name = ""
    local resx = ""
    local result = { }
    while form ~= nil do
      local typ, res, err = {
        form = read()
      }
      if typ == "header" then
        if res[1] == "Content-Disposition" then
          local tt = m.getfield(res)
          file_name = tt.filename
          input_name = tt.name
          resx = ""
        end
      elseif typ == "eof" then
        break
      elseif typ == "body" then
        if input_name then
          resx = resx .. res
        end
      elseif typ == "part_  " then
        if file_name then
          result[input_name] = {
            file_name,
            resx
          }
          ngx.ctx.gets[input_name] = file_name
        else
          ngx.ctx.gets[input_name] = resx
        end
        resx = ""
      end
    end
    return result
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
    if f({
      f = close()
    }) then
      return true
    end
    return false
  end,
  isDir = function(name)
    return (m.exist(name) and not m.isFile(name))
  end,
  inspect = inspect
}
return m
