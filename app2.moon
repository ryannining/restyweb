-- make common function as global to make easier to coding
dofile("web.lua")
myconnect "127.0.0.1","root","norikosakai","ledhemat"
export ck=split(cookies.last or "||||||||||||||","||")

raw [[
<!DOCTYPE html>
<html>
<body>

<form method="post">
    Select image to upload:<br>
    <br><input type="text" name="data" id="fileToUpload2">
    <br><input type="submit" value="submit" name="submit">
</form>

]]

res1=query("select * from customer where telp='#{ck[1]}'")
raw "from cookies namamu:#{cookies.namamu}"
raw "<hr>from view<br>"
export glo="Hi you"
lc=require("views.test")
lc!
session.namaku="RYan widi"
cookies.namamu="Nining"
finish!