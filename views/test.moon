=>
  res=query("select * from produk limit 2")
  raw "hello world namaku : #{session.namaku}<br>"
  raw "From web form : #{gets.data}<br>"
  raw "Global var #{glo}<br>From Database:<hr>",inspect(res),"<hr>"
  -- do other
  