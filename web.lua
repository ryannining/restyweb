web=require("resty1.myweb")
mgk=require "resty1.magick1"
json=require("cjson")
uploads=web.start()


query=web.myquery
queryf=web.myqueryf
querydict=web.querydict
aquery=web.aquery
myconnect=web.myconnect

strlen=string.len
function strpos (haystack, needle, offset) 
  local pattern = string.format("(%s)", needle)
  local i       = string.find (haystack, pattern, (offset or 0))
  
  return toint(i)
end

floor=math.floor
max=math.max
min=math.min
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

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
--ngx.null=nil
null=ngx.null

session=ngx.ctx.session
cookies=ngx.ctx.cookies
gets=ngx.ctx.gets
posts=ngx.ctx.posts

inspect=web.inspect
getupload=web.getupload
removeext=web.removeext
getext=web.getext
number_format=web.number_format

exists = web.exists
file_exists = exists
isFile = web.isFile
isDir=web.isDir
unlink=os.remove

file_exists=exists
str_repeat = string.rep
function ob_start()
  ngx.var.sbuffer2=ngx.var.sbuffer
  ngx.var.sbuffer={}
end
function ob_get_contents()
  return table.concat(ngx.var.sbuffer)
end
function ob_end_clean()
  ngx.var.sbuffer=ngx.var.sbuffer2
  ngx.var.sbuffer2=nil
end  


function makekomen(oleh,isi,alt)
    --return $isi;
    if alt==nil then
      alt=''
    end
    --if ($oleh!='tokosenterled')isi=strip_tags_content($isi,"<img>");
    isi=isi:gsub("<img ","<img alt='Senter led $alt' ")
    isi=isi:gsub("<up", "<img onclick='showpicpreview(this)' class=pict1 alt='Senter led $alt' src=static/uploads/")
    isi=isi:gsub("<fp", "<img xonclick='showpicpreview(this)' class=pict1a alt='Gambar' isrc=static/uploads/")

    isi=isi:gsub("\n", "<br>")


    --emoticon
    --:) :D 8/ >:O 8) %) :P :$ ;) :Q %* :C :( :@ %/
    isi=isi:gsub(":%)", "<b class='emo em00'></b>")
    isi=isi:gsub(":D", "<b class='emo em01'></b>")
    isi=isi:gsub("8/", "<b class='emo em02'></b>")
    isi=isi:gsub(">:O", "<b class='emo em03'></b>")
    isi=isi:gsub("8%)", "<b class='emo em04'></b>")

    isi=isi:gsub("%%%)", "<b class='emo em10'></b>")
    isi=isi:gsub(":P", "<b class='emo em11'></b>")
    isi=isi:gsub(":$", "<b class='emo em12'></b>")
    isi=isi:gsub(";%)", "<b class='emo em13'></b>")
    isi=isi:gsub(":Q", "<b class='emo em14'></b>")


    isi=isi:gsub("%%%*", "<b class='emo em20'></b>")
    isi=isi:gsub(":C", "<b class='emo em21'></b>")
    isi=isi:gsub(":%(", "<b class='emo em22'></b>")
    isi=isi:gsub(":@", "<b class='emo em23'></b>")
    isi=isi:gsub("%%/", "<b class='emo em24'></b>")

    --:zz :mask (D 8| (:[ :tai :cry :love :| :tbup :tbdn :kaki :alien :setan :# :x :? :} :siul

    isi=isi:gsub(":8", "<b class='emo em30'></b>")
    isi=isi:gsub(":zz", "<b class='emo em31'></b>")
    isi=isi:gsub(":mask", "<b class='emo em32'></b>")
    isi=isi:gsub("%(D", "<b class='emo em33'></b>")
    isi=isi:gsub("8|", "<b class='emo em34'></b>")

    isi=isi:gsub("%(:[", "<b class='emo em40'></b>")
    isi=isi:gsub(":tai", "<b class='emo em41'></b>")
    isi=isi:gsub(":cry", "<b class='emo em42'></b>")
    isi=isi:gsub(":love", "<b class='emo em43'></b>")
    isi=isi:gsub(":|", "<b class='emo em44'></b>")

    isi=isi:gsub(":tbup", "<b class='emo em50'></b>")
    isi=isi:gsub(":tbdn", "<b class='emo em51'></b>")
    isi=isi:gsub(":kaki", "<b class='emo em52'></b>")
    isi=isi:gsub(":alien", "<b class='emo em53'></b>")
    isi=isi:gsub(":setan", "<b class='emo em54'></b>")

    isi=isi:gsub(":#", "<b class='emo em60'></b>")
    isi=isi:gsub(":x", "<b class='emo em61'></b>")
    isi=isi:gsub(":%?", "<b class='emo em62'></b>")
    isi=isi:gsub(":}", "<b class='emo em63'></b>")
    isi=isi:gsub(":siul", "<b class='emo em64'></b>")
    return isi
end

function toint(x,y)
    if x and y then return tonumber(x[y]) or 0 end
    if x then return tonumber(x) or 0 end
    return 0
end
function tostr(x,y)
    if x and y then return tostring(x[y]) end
    if x then return tostring(x) end
    return ''
end
function xfile(f)
  f=io.open(f,'r')
  ss=f:read()
  f:close()
  return ss
end  
