return function(self)
  local res = query("select * from produk limit 2")
  raw("hello world namaku : " .. tostring(session.namaku) .. "<br>")
  raw("From web form : " .. tostring(gets.data) .. "<br>")
  return raw("Global var " .. tostring(glo) .. "<br>From Database:<hr>", inspect(res), "<hr>")
end
