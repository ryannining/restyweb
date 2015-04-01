=>
  res=query("select * from produk limit 2")
  raw "From web session : #{session.data}<br>"
  raw "From web cookie : #{cookies.data}<br>"
  raw "From web form : #{gets.data}<br>"
  raw "Global var #{glo}<br>From Database select * from produk limit 2:<hr>",inspect(res),"<hr>"
  -- do other
  