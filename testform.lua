dofile("web.lua")
raw([[<!DOCTYPE html>
<html>
<body>

<form action="testform?input2=getshello" method="post" enctype="multipart/form-data">
    Select image to upload:<br>
    <input type="file" name="fileToUpload" id="fileToUpload">
    <br><input type="file" name="fileToUpload2" id="fileToUpload2">
    <br><input type="checkbox" name="input1" >
    <br><input type="text" name="input2" >
    <br><input type="submit" value="Upload Image" name="submit">
</form>
]])
if uploads then
  for fn, fr in pairs(uploads) do
    local img = mgk.load_image_from_blob(fr[2])
    if img then
      mgk.thumb(img, "200x200", "static/" .. fr[1])
      img:destroy()
    end
  end
  raw("UPLOADED and resized:<br>")
  for fn, fr in pairs(uploads) do
    raw(tostring(removeext(fr[1])) .. "<br>" .. tostring(fr[1]) .. "<br><img src='static/" .. tostring(fr[1]) .. "'><br>")
  end
end
raw("Form content: " .. tostring(posts.input1) .. " <br>Input name:input2 -> GETS:" .. tostring(gets.input2) .. " and POSTS:" .. tostring(posts.input2))
raw([[</body></html>]])
return finish()
