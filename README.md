# restyweb
This project is aim to help converting php code to lua/moonscript app server using openresty.

## Changes

**28/3/2015**

Change mysql backend to luasql, add more global variabel to `web.lua`, and begin to work on more complex php convertion.


## install requirement
**openresty** http://openresty.org/

**zerobrane** http://studio.zerobrane.com/

**moonscript** http://moonscript.org/

Also perhaps you need coffeescript and sass compiler, my modified zerobrane module will compile these file too by pressing F6.

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
## Using zerobrane IDE
I use zerobrane IDE to make things easier. and to make things easier, please make this file and put into the zerobrane package folder

**`zerobrane/moonscript.lua`**

Zerobrane package location usually are in `/opt/zbstudio/package`. It will help to syntax highlight moonscript and enable compile moonscript by pressing **F6**

Dont forget to set the `Project->Intepretter` to `Moonscript`

## nginx.conf
Please edit the nginx.conf and set `$home` to match your application location. And perhaps comment out item you dont need ,for example `include "phpsite.conf"`

Currently this nginx.conf have feature:
 1. Multiple web app folder, by setting `$home` on `{server}`
 2. Support for PHP fast-cgi too, just edit the example file `phpsite.conf`
 

## start server
Make the `resty.sh` executable using `chmod +x ./resty.sh`

Restart server : `./resty.sh restart`

Stop server : `./resty.sh stop`


When you change the `nginx.conf`, please restart the server to take effect. Also if you use lua code cache **`on`**, its necessary to restart the server too if you change your website code.

## Start project
~~Usually by editing nginx.conf and place route to your lua file~~. Example :

```
	set $home "/var/www/myapp"
    location / {
		# no need to change this content
		# ...
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

After compiling your moonscript, you can test by open webrowser and load `localhost:8080`, or on terminal, run command

 `curl localhost:8080`

## Request, Cookies and Session
Request, Cookies and session are easy. Just use global variabel `gets`,`posts`,`uploads`,`session` and `cookies` , just dont forget to call `finish` in the end of file.

```
dofile("web.lua")
raw "Request : #{gets.data} <br>Cookies data: #{cookies.data} <br>Session data: #{session.data}"
cookies.data="my cookies"
session.data="my session"
finish!
```

If you run that file, it will show nil at first load on the browser. But on second load (press F5) it will show the session and cookies data.

`posts` is same as get, but only contain data from POST request. While `gets` contain both GET and POST request. `uploads` only contain data from file upload. Oh `gets` contain dat from `uploads` too, but just the filename. If you want to get the data, you must get from `uploads` (each item contain {filename,content}).

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

The result is like php `mysql_fetch_assoc`, which we can get the result using its field name:

```
...
res=query("select * from product limit 10")
raw res[1].totalprice
-- this code is idenctical output, aquery will get first row
res=aquery("select * from product limit 10")
raw res.totalprice
...
```

To get faster performance, you can use `queryf` which is not store the result info buffer, but 
manually fetch one by one

```
...
row=query("select * from product limit 10")
while true
   r=row() -- fetch one row
   if not r then break -- if EOF
   raw r.totalprice 
...
```

## Other function
To make converting php to moonscript easier i have add this function

**explode**
`result = explode (",", "Hello,World")`

**echo** 
same with raw `echo "hello world",view1`

**isfill** `isfill(var)` *return true* if var contain values 
since PHP thread nil,'',0 as false, and lua is not, so i create this function to check.

**isempty** `isempty(var)` *return true* if var contain values 
since PHP thread nil,'',0 as false, and lua is not, so i create this function to check.


## web.lua
This file is called using `dofile` because we need to make some function to global and easier to call. ALso it started the http request, cookies, session processing. You can change is to meet your requirement

default content:

```
web=require("myweb")
uploads=web.start()


query=web.myquery
querydict=web.querydict
aquery=web.aquery
myconnect=web.myconnect

strlen=string.len
floor=math.floor
ceil=math.ceil
strtolower=string.lower
len=web.len
count=web.len
isfill=web.isfill
isempty=web.isempty
str_replace=web.str_replace
trim=web.trim
unslash=web.unslash

echo=web.raw
raw=web.raw

sql_escape=ngx.quote_sql_str
uri_unescape=ngx.unescape_uri
split=web.split
explode=web.explode

die=web.finish
finish=web.finish
null=ngx.null

session=ngx.ctx.session
cookies=ngx.ctx.cookies
gets=ngx.ctx.gets

inspect=web.inspect
getupload=web.getupload
removeext=web.removeext
getfilename=web.getfilename
getext=web.getext
number_format=web.number_format
```

## imageMagick module
After frustating installing and fixing error on magick module. Now i modify a little this module to make it easier. You dont need to install
libimagemagick-dev or install from source. Just need install using standard apt-get.

```
sudo apt-get install imagemagick
```

This module is loaded into `mgk`, so you can open and process image. If fail to load magick, please 
find the library location, usually default location `/usr/lib/x86_64-linux-gnu/libMagickWand.so.5` is correct, but if not
please change the `resty1\magick1.moon` at line 105 to match your lib location

```
lib = try_to_load "/usr/lib/x86_64-linux-gnu/libMagickWand.so.5"
```

We also include the `magick\resample.h` which this module needed. Of course the solution is not elegant, but it will safe many hours to fix why the module is not loaded.

## upload module
To make upload easier, we make function `getupload` which return table of inputname and the {filename,content}. Example:

```
dofile("web.lua")

for fn,fr in pairs uploads
  img=assert(mgk.load_image_from_blob(fr[1]))
  mgk.thumb(img,"200x200","static/"..fn)
  img\destroy() 
```

Right now you dont need to call `getupload` (on previous version), because its called on the `web.lua` and stored at the `uploads` global variable. So you can check if
some input on the http form are contain file name, by checking `uploads['inputname'][1]` if is not `''` then `[2]` will contain the data.

Also other input type (text,button,etc) will captured and stored at `gets` global variable.

Please check the exampel file `testform.moon` for detail information

## Module included
I am using modules from these source, but with some minor modification

https://github.com/openresty/lua-resty-upload

https://github.com/leafo/magick

https://github.com/cloudflare/lua-resty-cookie

https://github.com/bungle/lua-resty-session

~~https://github.com/openresty/lua-resty-mysql~~

http://keplerproject.github.io/luasql/doc/us/manual.html#mysql_extensions


## Others
http://wiki.nginx.org/HttpLuaModule

http://moonscript.org/reference


http://openresty.org/
