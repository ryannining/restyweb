return function(self)
  return raw("Cookies data: " .. tostring(cookies.data) .. " <br>Session data: " .. tostring(session.data))
end
