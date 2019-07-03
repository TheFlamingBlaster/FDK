--[[
	Loader for Flame Development Toolkit.
	
	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]

local classPath = "https://raw.githubusercontent.com/TheFlamingBlaster/FDK/master/BaseClass.lua" -- Where the base class will be loaded from. 
local fdkPath = "https://raw.githubusercontent.com/TheFlamingBlaster/FDK/master/FDK.lua" -- Where FDK is loaded from.

baseClass = loadstring(classPath)()
fdk = loadstring(fdkPath)()

return fdk