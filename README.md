# restyweb
This project is aim to help converting php code to lua/moonscript app server using openresty.

## start server
Make the `resty.sh` executable using `chmod +x ./resty.sh`

Restart server : `./resty.sh restart`
Stop server : `./resty.sh stop`

When you change the `nginx.conf`, please restart the server to take effect. Also if you use lua code cache `**on**`, its necessary to restart the server too if you change your website code.

## nginx.conf
Please edit the nginx.conf file to check

## Using zerobrane IDE
I use zerobrane IDE to make things easier. and to make things easier, please make this file and put into the zerobrane package folder

`**zerobrane/moonscript.lua**`

Zerobrane package location usually are in `/opt/zbstudio/package`. It will help to syntax highlight moonscript and enable compile moonscript by pressing **F6**

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

## Cookies and Session
Cookies and session are easy. Just use global variabel `session` and `cookies` , just dont forget to call `finish` in the end of file.

```
dofile("web.lua")
raw "Cookies data: #{cookies.data} <br>Session data: #{session.data}"
cookies.data="my cookies"
session.data="my session"
finish!
```

If you run that file, it will show nil at first load on the browser. But on second load (press F5) it will show the session and cookies data.

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

