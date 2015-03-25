my=require "mymysql"
json=require("cjson")
inspect=require("resty1.inspect")
upload = require "resty.upload"
mgk=require "resty1.magick1"
logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}
match = string.match

export m
m=
  myconnect:my.myconnect
  myquery:my.myquery
  split:(s, delimiter)->
    result = {}
    for match in (s..delimiter)\gmatch("(.-)"..delimiter) do
        table.insert(result, match)
      
    return result
  explode:(del,s)->
    return m.split(s,del)
  
  trim:(s)->
    return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
  
  len:(t)->
    return #t
  
  nsay:(s)->
    ngx.say(json.encode(s))
  
  str_replace:(h,c,s)->
    return s\gsub(h, c)
  
  unslash:(s)->
    if isfill(s) then
      return s\gsub("%\\n","\n")\gsub("%\\r","\r")\gsub("%\\","")
    else 
      return ""
      
  isempty:(s)->
    return s==false or s=='' or s==nil or s==0 or s==ngx.null
  
  isfill:(s) ->
    return not m.isempty(s)
  
  aquery:(q)->
    res=m.myquery(q)
    if m.isempty(res) or #res==0 then
      return nil
    
    return res[1]

  querydict:(q,idx)->
    res=m.myquery(q)
    dic={}
    for i = 1, #res do
      re = res[i]
      dic[re[idx]]=re
      
    return dic
  
  number_format:(v)->
    s = string.format("%d", math.floor(v))
    pos = string.len(s) % 3
    if pos == 0 then pos = 3   
    return string.sub(s, 1, pos)..string.gsub(string.sub(s, pos+1), "(...)", ",%1")
  raw:(...)->
    arg = {...}
    i=0
    for i = 1, #arg do
      v=arg[i]
      if type(v)=='function'
        v()
      else
        ngx.ctx.sbuffer[#ngx.ctx.sbuffer+1]=tostring(v)
                
  craw:(s)->
    print s
  
  start: ->
    ck= require "resty1.cookie"
    ngx.ctx.xcookie,err=ck\new()
    ngx.ctx.xfcookie,err=ngx.ctx.xcookie\get_all()
    ngx.ctx.ses = require("resty1.session").new()
    ngx.ctx.ses\start()
    ngx.ctx.session=ngx.ctx.ses.data
    ngx.ctx.sbuffer={}
    
    args = ngx.req.get_uri_args()
    ngx.ctx.gets={}
    for key, val in pairs(args) do
      ngx.ctx.gets[key]=val
    
    ngx.ctx.uploads=m.getupload()
    ngx.req.read_body()
    ngx.ctx.posts={}
    args, err = ngx.req.get_post_args()
    for key, val in pairs(args) do
        ngx.ctx.posts[key]=val
        ngx.ctx.gets[key]=val
      
    ngx.ctx.cookies={}
    if ngx.ctx.xfcookie==nil then ngx.ctx.xfcookie={}   
    for key, val in pairs(ngx.ctx.xfcookie) do
      ngx.ctx.cookies[key]=val
      
    return ngx.ctx.uploads
  
  finish:->
    for key, val in pairs(ngx.ctx.cookies) do
      if ngx.ctx.xfcookie[key]~=val
        ngx.ctx.xcookie\set(key:key
                            value:val)
      
    ngx.ctx.ses\save()
    ngx.say(ngx.ctx.sbuffer)
    ngx.ctx.sbuffer={}
    if ngx.ctx.mydb then
      ngx.ctx.mydb\set_keepalive(6000, 10) 
      
    ngx.ctx.uploads=nil
    ngx.ctx.gets=nil
    ngx.exit(ngx.HTTP_OK)
  

  getfield:(res)->
    v={}
    res[2]\gsub '([^% ^%;^%=]+)%="([^%;]*)";?', (key,val)->
        v[key]=val
    return v
    
  getext:(filename)->
    return string.match(filename ,".+%.(%w+)$")
  
  removeext:(filename)->
    return string.gsub(filename, '%....$','')
  
  getupload:->
    form = upload\new(100000)
    file_name=""
    input_name=""
    resx=""
    result={}
    while form~=nil do
      typ, res, err = form:read()
      if typ == "header" then
        if res[1]=="Content-Disposition"
          tt=m.getfield(res)
          file_name = tt.filename
          input_name = tt.name
          resx=""
                
      elseif typ == "eof"
        break  
      elseif typ == "body"
        if input_name
          resx=resx..res
          
      elseif typ == "part_  "
        if file_name
          result[input_name]={file_name,resx}
          ngx.ctx.gets[input_name]=file_name
        else
          ngx.ctx.gets[input_name]=resx
          
        resx=""
        
      
    return result
  

  exists:(name)->
    if type(name)~="string" 
      return false   
    return os.rename(name,name) and true or false
  

  isFile:(name)->
    if type(name)~="string" 
      return false   
    if not m.exist(name) 
      return false   
    f = io.open(name)
    if f
      f:close()
      return true
      
    return false
  

  isDir:(name)->
    return (m.exist(name) and not m.isFile(name))
  inspect:inspect
return m