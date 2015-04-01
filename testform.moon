dofile("web.lua")


raw [[
<!DOCTYPE html>
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
]]    
  
if uploads

  for fn,fr in pairs uploads
    img=mgk.load_image_from_blob(fr[2])
    if img
      mgk.thumb(img,"200x200","static/"..fr[1])
      img\destroy() 

  raw "UPLOADED and resized:<br>"
  for fn,fr in pairs uploads
    raw "#{removeext(fr[1])}<br>#{fr[1]}<br><img src='static/#{fr[1]}'><br>"
raw "Form content: #{posts.input1} <br>Input name:input2 -> GETS:#{gets.input2} and POSTS:#{posts.input2}"    
raw [[</body></html>]]

finish!
