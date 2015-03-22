return function(self)
  return raw("Request : " .. tostring(gets.data) .. " <br>Cookies data: " .. tostring(cookies.data) .. " <br>Session data: " .. tostring(session.data))
end
