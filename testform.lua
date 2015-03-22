dofile("web.lua")
local upload = getupload()
for fn, fr in pairs(upload) do
  local img = assert(mgk.load_image_from_blob(fr))
  mgk.thumb(img, "200x200", "static/" .. fn)
  img:destroy()
end
raw([[<!DOCTYPE html>
<html>
<body>

<form action="testform" method="post" enctype="multipart/form-data">
    Select image to upload:<br>
    <input type="file" name="fileToUpload" id="fileToUpload">
    <br><input type="file" name="fileToUpload2" id="fileToUpload2">
    <br><input type="submit" value="Upload Image" name="submit">
]])
raw("UPLOADED and resized:<br>")
for fn, fr in pairs(upload) do
  raw(tostring(removeext(fn)) .. "<br><img src='static/" .. tostring(fn) .. "'><br>")
end
raw([[</form>

</body>
</html>
]])
return finish()
