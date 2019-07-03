--[[
	Loader for Flame Development Toolkit.
	
	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]

local classPath = "" -- Where the base class will be loaded from. 
local fdkPath = "" -- Where FDK is loaded from.

baseClass = loadstring(classPath)()
fdk = loadstring(fdkPath)()

return fdk