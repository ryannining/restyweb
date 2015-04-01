return function(self)
  local res = query("select * from produk limit 2")
  raw("From web session : " .. tostring(session.data) .. "<br>")
  raw("From web cookie : " .. tostring(cookies.data) .. "<br>")
  raw("From web form : " .. tostring(gets.data) .. "<br>")
  return raw("Global var " .. tostring(glo) .. "<br>From Database select * from produk limit 2:<hr>", inspect(res), "<hr>")
end
