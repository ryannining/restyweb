  -- mysql
->
  mysql = require "luasql.mysql"
  logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}
  m={}
  export env=nil
  export conn=nil
  m=
    myconnect:(server,username,passw,base)->
      env=mysql.mysql()
      conn = env\connect(base,username,passw,server)

    myqueryf:(sql,hash)->
      --if string.find(sql,'nil')~=nil  print (logcolor[3],"\n\nSQL with NIL:\n"..sql.."\n\n") 
      if not hash 
          hash="a"
      else
          hash="n"
      
      row={}
      cursor=conn\execute(sql)
      return ()->
          return cursor\fetch(row,hash)

    myquery:(sql,hash)->
      --if string.find(sql,'nil')~=nil  print (logcolor[3],"\n\nSQL with NIL:\n"..sql.."\n\n") 
      -- print("\n\n",sql,"\n\n")
      if not hash 
          hash="a"
      else
          hash="n"
      
      cursor,errorString = conn\execute(sql)
      if type(cursor)~='number' 
        r = cursor\fetch({}, hash)
        res={}
        i=1
        while r do
          res[i]=r
          i+=1
          r = cursor\fetch({}, hash)
        
        return res
      else
        if errorString 
          print("\n\n",sql,"\n",errorString,"\n\n")
          m.finish()
    close:()->
      conn\close()
      env\close()

  return m