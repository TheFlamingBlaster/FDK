--[[
	Loader for Flame Development Toolkit.
	
	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]
local hs = game:GetService("HttpService")

local classPath = "https://raw.githubusercontent.com/TheFlamingBlaster/FDK/master/src/BaseClass.lua" -- Where the base class will be loaded from. 
local fdkPath = "https://raw.githubusercontent.com/TheFlamingBlaster/FDK/master/src/FDK.lua" -- Where FDK is loaded from.

baseClass = loadstring(hs:GetAsync(classPath))()
fdk = loadstring(hs:GetAsync(fdkPath))
setfenv(fdk, getfenv())

return fdk()