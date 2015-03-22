dofile("web.lua")

upload=getupload()
for fn,fr in pairs upload
  img=assert(mgk.load_image_from_blob(fr))
  mgk.thumb(img,"200x200","static/"..fn)
  img\destroy() 

raw [[
<!DOCTYPE html>
<html>
<body>

<form action="testform" method="post" enctype="multipart/form-data">
    Select image to upload:<br>
    <input type="file" name="fileToUpload" id="fileToUpload">
    <br><input type="file" name="fileToUpload2" id="fileToUpload2">
    <br><input type="submit" value="Upload Image" name="submit">
]]    
  
raw "UPLOADED and resized:<br>"
for fn,fr in pairs upload
  raw "#{removeext(fn)}<br><img src='static/#{fn}'><br>"
raw [[
</form>

</body>
</html>
]]

finish!