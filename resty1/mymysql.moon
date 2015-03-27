-- mysql
mysql = require "luasql.mysql"
logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}
export m
m=
  myconnect:(server,username,passw,base)->
    ngx.ctx.env=mysql.mysql()
    ngx.ctx.conn = ngx.ctx.env\connect(base,username,passw,server)

  myqueryf:(sql,hash)->
    --if string.find(sql,'nil')~=nil  print (logcolor[3],"\n\nSQL with NIL:\n"..sql.."\n\n") 
    if not hash 
        hash="a"
    else
        hash="n"
    
    row={}
    cursor=ngx.ctx.conn\execute(sql)
    return ()->
        return cursor\fetch(row,hash)

  myquery:(sql,hash)->
    --if string.find(sql,'nil')~=nil  print (logcolor[3],"\n\nSQL with NIL:\n"..sql.."\n\n") 
    -- print("\n\n",sql,"\n\n")
    if not hash 
        hash="a"
    else
        hash="n"
    
    cursor,errorString = ngx.ctx.conn\execute(sql)
    if type(cursor)~='number' 
      r = cursor\fetch({}, hash)
      res={}
      while r do
        res[#res+1]=r
        r = cursor\fetch({}, hash)
      
      return res
    else
      if errorString 
        print("\n\n",sql,"\n",errorString,"\n\n")
        m.finish()
  close:()->
    ngx.ctx.conn\close()
    ngx.ctx.env\close()

return m