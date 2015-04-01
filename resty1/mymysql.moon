->
  -- mysql
  mysql = require "resty1.mysql"
  logcolor= {'\033[95m','\033[94m','\033[92m','\033[93m','\033[91m','\033[0m','\033[1m','\033[4m'}
  m={}
  mydb=mysql\new()
  m=
    myconnect:(server,username,passw,base)->
      mydb\set_timeout(10000)
      ok, err, errno, sqlstate = mydb\connect {
          host: server
          port: 3306
          database: base
          user: username
          password: passw
          max_packet_size: 1024 * 1024 
      }
      if not ok
          print(logcolor[1],"failed to connect: ", err, ": ", errno, " ", sqlstate)
          m.finish()


    myqueryf:(sql,hash)->
      mydb\send_query(sql)
      return mydb\fread_result()
    myquery:(sql,hash)->
      res, err, errno, sqlstate=mydb\query(sql)
      if not res
        print logcolor[2],"\nSQL:\n"..sql.."\nbad result: ", err, ": ", errno, ": ", sqlstate, "."
        m.finish()
      return res

    close:()->
      mydb\set_keepalive(10000, 10)

  return m