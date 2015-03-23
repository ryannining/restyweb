dofile("web.lua")
myconnect("127.0.0.1", "root", "norikosakai", "ledhemat")
ck = split(cookies.last or "||||||||||||||", "||")
raw([[<!DOCTYPE html>
<html>
<body>

<form method="post">
    Select image to upload:<br>
    <br><input type="text" name="data" id="fileToUpload2">
    <br><input type="submit" value="submit" name="submit">
</form>

]])
local res1 = query("select * from customer where telp='" .. tostring(ck[1]) .. "'")
raw("from cookies namamu:" .. tostring(cookies.namamu))
raw("<hr>from view<br>")
glo = "Hi you"
local lc = require("views.test")
lc()
session.namaku = "RYan widi"
cookies.namamu = "Nining"
return finish()
