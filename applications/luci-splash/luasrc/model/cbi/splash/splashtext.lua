--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>
Copyright 2010 Manuel Munz <freifunk@somakoma.de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

local fs = require "nixio.fs"

local splashtextfile = "/usr/lib/luci-splash/splashtext.html" 
local splashtextinclude = "/usr/lib/luci-splash/splashtextinclude.html" 


f = SimpleForm("splashtext", translate("Edit the complete splash text"),
	translate("You can enter your own text that is displayed to clients here.<br />" ..
	"It is possible to use the following markers: " ..
	"###HOMEPAGE###, ###LEASETIME###, ###LIMIT### and ###ACCEPT###."))

t = f:field(TextValue, "text")
t.rmempty = true
t.rows = 30
function t.cfgvalue()
	return fs.readfile(splashtextfile) or ""
end

function f.handle(self, state, data)
	if state == FORM_VALID then
		if data.text then
			fs.writefile(splashtextfile, data.text:gsub("\r\n", "\n"))
		else
			fs.unlink(splashtextfile)
		end
	end
	return true
end

g = SimpleForm("splashtextinclude", translate("Include your own text in the default splash"),
	translate("As an alternative to editing the complete splash text you can also just include some custom text in the default splash page by entering it here."))

t = g:field(TextValue, "text")
t.rmempty = true
t.rows = 30
function t.cfgvalue()
	return fs.readfile(splashtextinclude) or ""
end

function g.handle(self, state, data)
	if state == FORM_VALID then
		if data.text then
			fs.writefile(splashtextinclude, data.text:gsub("\r\n", "\n"))
		else
			fs.unlink(splashtextinclude)
		end
	end
	return true
end


return f, g
