dofile("web.lua")
for fn, fr in pairs(uploads) do
  local img = assert(mgk.load_image_from_blob(fr[2]))
  mgk.thumb(img, "200x200", "static/" .. fr[1])
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
for fn, fr in pairs(uploads) do
  raw(tostring(removeext(fr[1])) .. "<br><img src='static/" .. tostring(fr[1]) .. "'><br>")
end
raw([[</form>

</body>
</html>
]])
return finish()
