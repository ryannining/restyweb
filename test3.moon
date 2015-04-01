dofile("web.lua")

mysql = require "luasql.mysql"

myconnect "127.0.0.1","root","norikosakai","diggersf_android"
s={}
x=os.clock()
si=1
nama="Ryan widi"
for i=1,1000000
  s[si]=i..(i+1)..(i+5)..(i+11)..(i+20)..nama   -- 0.75
  --s[si]="#{i}#{i+1}#{i+5}#{i+11}#{i+20}#{nama}"
  si+=1
  --s[#s+1]=i..(i+1)..(i+5)  -- 1
raw os.clock()-x
raw 'Seconds'
raw "<hr>"
raw jit.version

finish!