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

