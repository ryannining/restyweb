DB_BACKEND = "resty1.mymysql"
DB_BACKEND = "resty1.luamysql"
->
  my=require"resty1.luamysql"!
  inspect=require("resty1.inspect")
  upload = require "resty.upload"
  mgk=require "resty1.magick1"
  logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}
  match = string.match
  export sbuffer={}
  export sidx=1
  lbuffer={}
  lsidx=0
  ses={}
  session={}
  gets={}
  posts={}
  cookies={}
  uploads={}
  ck= require "resty1.cookie"
  xcookie,err=ck\new()
  xfcookie,err=xcookie\get_all()
  ses = require("resty1.session").new()
  ses\start()
  session=ses.data
  m={}
  m=
    session:session
    gets:gets
    posts:posts
    uploads:uploads
    cookies:cookies
    myconnect:my.myconnect
    myquery:my.myquery
    myqueryf:my.myqueryf
    
    start: (data)->
      args = ngx.req.get_uri_args()
      for key, val in pairs(args) do
        gets[key]=val
        
      uploads=m.getupload(uploads)
      if not uploads
          ngx.req.read_body()
          args, err = ngx.req.get_post_args()
          for key, val in pairs(args) do
              posts[key]=val
              gets[key]=val
        
      if xfcookie==nil then xfcookie={}   
      for key, val in pairs(xfcookie) do
        cookies[key]=val
        
      
      return uploads
    
    finish:->
      for key, val in pairs(cookies) do
        if xfcookie[key]~=val
          xcookie\set {
            key:key
            value:val
          }
        
      ses\save()
      ngx.print(sbuffer)
      sbuffer=nil
      uploads=nil
      gets=nil
      ngx.exit(ngx.HTTP_OK)
      if ngx.ctx.conn then
        ngx.ctx.conn\close() 
    getfield:(res)->
      v={}
      res[2]\gsub '([^% ^%;^%=]+)%="([^%;]*)";?', (key,val)->
          v[key]=val
      return v
      
    getext:(filename)->
      return string.match(filename ,".+%.(%w+)$")
    
    removeext:(filename)->
      return string.gsub(filename, '%....$','')
    
    getupload:(result)->
      form = upload\new(100000)
      file_name=""
      input_name=""
      resx=""
      while form~=nil do
        typ, res, err = form\read()
        if typ == "header" then
          if res[1]=="Content-Disposition"
            tt=m.getfield(res)
            file_name = tt.filename
            input_name = tt.name
            resx=nil
                  
        elseif typ == "eof"
          break  
        elseif typ == "body"
          if input_name and res~=""
            if not resx
              resx=""
            resx=resx..res
            
        elseif typ == "part_end"
          if resx
            if file_name
              result[input_name]={file_name,resx}
              posts[input_name]=file_name
            else
              posts[input_name]=resx
              
            resx=nil
          
        
      return result

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
      json=require("cjson")
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
    
    aquery:(q,hash)->
      res=m.myquery(q,hash)
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
      a = {...}
      for i = 1, #a do
        sbuffer[sidx]=a[i]
        sidx+=1
    craw:(s)->
      print s
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
        f\close()
        return true
        
      return false
    

    isDir:(name)->
      return (m.exist(name) and not m.isFile(name))
    inspect:inspect
    ob_start:->
      lsidx=sidx
      lbuffer=sbuffer
      sbuffer={}
      sidx=1
    ob_get_contents:->
      return table.concat(sbuffer)
    ob_end_clean:->
      sidx=lsidx
      sbuffer=lbuffer
      lbuffer=nil
    strpos:(haystack, needle, offset) ->
      pattern = string.format("(%s)", needle)
      i       = string.find(haystack, pattern, (offset or 0))
      return toint(i)
    round:(num, idp)->
      mult = 10^(idp or 0)
      return math.floor(num * mult + 0.5) / mult
    toint:(x,y)->
        if x and y then return tonumber(x[y]) or 0 
        if x then return tonumber(x) or 0 
        return 0
    tostr:(x,y)->
        if x and y then return tostring(x[y]) 
        if x then return tostring(x) 
        return ''
    include:(f)->
      f=io.open(f,'r')
      ss=f:read("*all")
      f:close()
      raw(ss)
      
  my.finish=m.finish
  return m
  