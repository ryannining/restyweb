local m={}
my=require "mymysql"
json=require("cjson")
inspect=require("inspect")
upload = require "resty.upload"
mgk=require "resty1.magick1"
m.myconnect=my.myconnect
m.myquery=my.myquery

local logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}
getmetatable('').__call = function(str,i,j)
  if type(i)~='table' then return string.sub(str,i,j)
    else local t={}
    for k,v in ipairs(i) do t[k]=string.sub(str,v,v) end
    return table.concat(t)
    end
  end
  
function m.split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
function m.explode(del,s)
  return m.split(s,del)
end
local match = string.match
function m.trim(s)
  return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end
function m.len(t)
  return #t
end
--getmetatable('').__index = function(str,i) return string.sub(str,i,i) end

function m.nsay(s)
  ngx.say(json.encode(s))
end
function m.str_replace(h,c,s)
  return s:gsub(h, c)
end

function m.unslash(s)
  if isfill(s) then
    return s:gsub("%\\n","\n"):gsub("%\\r","\r"):gsub("%\\","")
  else 
    return ""
  end
end
function m.isempty(s)
  return s==false or s=='' or s==nil or s==0 or s==ngx.null or #s==0
end
function m.isfill(s)
  return not m.isempty(s)
end
function m.aquery(q)
  local res=m.myquery(q)
  if m.isempty(res) or #res==0 then
    return nil
  end
  return res[1]
end

function m.querydict(q,idx)
  res=m.myquery(q)
  dic={}
  for i = 1, #res do
    local re = res[i]
    dic[re[idx]]=re
  end
  return dic
end
function m.number_format(v)
	local s = string.format("%d", math.floor(v))
	local pos = string.len(s) % 3
	if pos == 0 then pos = 3 end
	return string.sub(s, 1, pos)
		.. string.gsub(string.sub(s, pos+1), "(...)", ",%1")
end

function m.raw (...)
    local arg = {...}
    local i=0
    for i = 1, #arg do
      v=arg[i]
      if type(v)=='function' then
        v()
      else
        ngx.ctx.sbuffer[#ngx.ctx.sbuffer+1]=tostring(v)
      end
    end
  --ngx.say(s)
end
function m.craw (s)
  --ngx.say(s)
end

-- ==================
function m.start()
  ck= require "resty1.cookie"
  ngx.ctx.xcookie,err=ck:new()
  ngx.ctx.xfcookie,err=ngx.ctx.xcookie:get_all()
  ngx.ctx.ses = require("resty1.session").new()
  ngx.ctx.ses:start()
  ngx.ctx.session=ngx.ctx.ses.data
  ngx.ctx.sbuffer={}
  
  args = ngx.req.get_uri_args()
  ngx.ctx.gets={}
  for key, val in pairs(args) do
    ngx.ctx.gets[key]=val
  end
  
  ngx.ctx.uploads=m.getupload()
  ngx.req.read_body()
  ngx.ctx.posts={}
  args, err = ngx.req.get_post_args()
  for key, val in pairs(args) do
      ngx.ctx.posts[key]=val
      ngx.ctx.gets[key]=val
  end
  ngx.ctx.cookies={}
  if ngx.ctx.xfcookie==nil then ngx.ctx.xfcookie={} end
  for key, val in pairs(ngx.ctx.xfcookie) do
    ngx.ctx.cookies[key]=val
  end
  return ngx.ctx.uploads
end
function m.finish()
  for key, val in pairs(ngx.ctx.cookies) do
    if ngx.ctx.xfcookie[key]~=val then
      ngx.ctx.xcookie:set({key=key,value=val})
    end
  end
  ngx.ctx.ses:save()
  ngx.say(ngx.ctx.sbuffer)
  ngx.ctx.sbuffer={}
  if ngx.ctx.mydb then
    ngx.ctx.mydb:set_keepalive(6000, 10) 
  end
  ngx.ctx.uploads=nil
  ngx.ctx.gets=nil
  ngx.exit(ngx.HTTP_OK)
end

function m.getfield(res)
  local v={}
  res[2]:gsub('([^% ^%;^%=]+)%="([^%;]*)";?',
		function(key,val)
			v[key]=val
		end)
	return v
end
function m.getext(filename)
  return string.match(filename ,".+%.(%w+)$")
end
function m.removeext(filename)
  return string.gsub(filename, '%....$','')
end
-- handle uploaded file
function m.getupload()
  local form = upload:new(100000)
  local file_name=""
  local input_name=""
  local resx=""
  local result={}
  while form~=nil do
    typ, res, err = form:read()
    if typ == "header" then
      if res[1]=="Content-Disposition" then
        tt=m.getfield(res)
        file_name = tt.filename
        input_name = tt.name
        resx=""
      end      
    elseif typ == "eof" then
      break  
    elseif typ == "body" then
      if input_name then
        resx=resx..res
      end
    elseif typ == "part_end" then
      if file_name then
        result[input_name]={file_name,resx}
        ngx.ctx.gets[input_name]=file_name
      else
        ngx.ctx.gets[input_name]=resx
      end
      resx=""
    end
  end
  return result
end

function m.exists(name)
    if type(name)~="string" then return false end
    return os.rename(name,name) and true or false
end

function m.isFile(name)
    if type(name)~="string" then return false end
    if not m.exist(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end

function m.isDir(name)
    return (m.exist(name) and not m.isFile(name))
end

m.inspect=inspect
my.finish=m.finish
return m