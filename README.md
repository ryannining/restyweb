# restyweb
This project is aim to help converting php code to lua/moonscript app server using openresty.
## install requirement
**openresty** http://openresty.org/
**zerobrane** http://studio.zerobrane.com/

Check openresty website to install from source. For editor, i prefer zerobrane over atom, but if you like atom, its no problem. Atom is more mature and have packages for moonscript.

The performance i have check its 2-3x faster on complex website. You can check it using siege on my website:

**PHP**
```
siege -t 20s http://lampu.tokoled.net
Transactions:		         150 hits
Availability:		      100.00 %
Elapsed time:		       19.20 secs
Data transferred:	        2.77 MB
Response time:		        1.35 secs
Transaction rate:	        7.81 trans/sec
Throughput:		        0.14 MB/sec
Concurrency:		       10.58
Successful transactions:         150
Failed transactions:	           0
Longest transaction:	        3.37
Shortest transaction:	        0.26
```

**RESTYWEB**
```
siege -t 20s http://lampu.tokoled.net:8080
Transactions:		         501 hits
Availability:		      100.00 %
Elapsed time:		       19.33 secs
Data transferred:	       10.28 MB
Response time:		        0.11 secs
Transaction rate:	       25.92 trans/sec
Throughput:		        0.53 MB/sec
Concurrency:		        2.86
Successful transactions:         501
Failed transactions:	           0
Longest transaction:	        0.48
Shortest transaction:	        0.06

```

## start server
Make the `resty.sh` executable using `chmod +x ./resty.sh`

Restart server : `./resty.sh restart`

Stop server : `./resty.sh stop`


When you change the `nginx.conf`, please restart the server to take effect. Also if you use lua code cache **`on`**, its necessary to restart the server too if you change your website code.

## nginx.conf
Please edit the nginx.conf file to check

## Using zerobrane IDE
I use zerobrane IDE to make things easier. and to make things easier, please make this file and put into the zerobrane package folder

**`zerobrane/moonscript.lua`**

Zerobrane package location usually are in `/opt/zbstudio/package`. It will help to syntax highlight moonscript and enable compile moonscript by pressing **F6**

Dont forget to set the `Project->Intepretter` to `Moonscript`

## Start project
Usually by editing nginx.conf and place route to your lua file. Example :

```
    location / {
      default_type text/html;
      content_by_lua_file 'app.lua';
    }
```

Then make new file `app.moon` in the project, and put codes. This is example code for simple "Hello world"

```
ngx.say("Hello world")
```

Or using the resty web framework i make

```
dofile("web.lua")
raw "Hello world"
finish!
```

Why make hello world complicated ? its because we need to parse HTTP request, session, cookies. If you dont need these feature, just use `ngx.say` to send something to client.

calling `finish` also terminate the execution, so if you call in the midle of code, it will terminate, just like php `die` function. In fact, you can call `die` too it linked to `finish` anyway.

## Request, Cookies and Session
Request, Cookies and session are easy. Just use global variabel `gets`,`session` and `cookies` , just dont forget to call `finish` in the end of file.

```
dofile("web.lua")
raw "Request : #{gets.data} <br>Cookies data: #{cookies.data} <br>Session data: #{session.data}"
cookies.data="my cookies"
session.data="my session"
finish!
```

If you run that file, it will show nil at first load on the browser. But on second load (press F5) it will show the session and cookies data.

## views
On folder views (or other folder) you can make a views script started with **`=>`** and call it on you main app

**`views/test.moon`**
```
=>
  raw "Cookies data: #{cookies.data} <br>Session data: #{session.data}"
  -- do other things	
```

**`app.moon`**
```
dofile("web.lua")
view1=require("views.test")
view1!

cookies.data="my cookies"
session.data="my session"
finish!
```

Also you can send it together with other stuff on `raw` call

```
raw "Hello world",view1
```

Notice that there is no ! in the code. `raw` function will call the view1 internally. Its because the nature of `raw` is collect all stuff as buffer. 
If we put ! in the view it will cause the view1 codes inserted before the "Hello world" string.

## Mysql database
To connect mysql database, call `myconnect`, example:

```
dofile("web.lua")
json=require("cjson")
myconnect("127.0.0.1", "user", "pass", "databasename")
res=query("select * from product limit 10")
raw json.encode(res)
finish!
```

## Other function
To make converting php to moonscript easier i have add this function

**explode**
`result = explode (",", "Hello,World")`
**echo** same with raw `echo "hello world",view1`


## imageMagick module
This module is loaded into `mgk`, so you can open and process image.

## upload module
To make upload easier, we make function `getupload` which return table of filename and the content. Example:

```
dofile("web.lua")

upload=getupload()
for fn,fr in pairs upload
  img=assert(mgk.load_image_from_blob(fr))
  mgk.thumb(img,"200x200","static/"..fn)
  img\destroy() 
```

Please check the exampel file `testform.moon` for detail information

## Module included
I am using modules from these source, but with some minor modification

https://github.com/openresty/lua-resty-upload

https://github.com/leafo/magick

https://github.com/cloudflare/lua-resty-cookie

https://github.com/bungle/lua-resty-session

## Others
http://wiki.nginx.org/HttpLuaModule

http://moonscript.org/reference


http://openresty.org/
