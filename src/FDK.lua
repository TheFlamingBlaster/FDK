--[[
	Flame Development Toolkit, Version 1.0.0

	Main module for package management.

	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]
local baseClass
local packages

if (__LEMUR__  == nil) then -- checking if this is lemur
	if game:GetService("RunService"):IsClient() == true then
	    packages = game:GetService("ReplicatedStorage").ClientPackages
	else
	    packages = game:GetService("ServerScriptService").ServerPackages
	end

	baseClass = require(script.BaseClass)
elseif (__LEMUR__ == true) then
	packages = script.Parent.Parent.tests -- setting the packages to be the tests
	baseClass = require(script.Parent.BaseClass)

end

local FDK = baseClass:New("Flame Development Toolkit")
local external = FDK:Lock()

FDK.Import = function(importString)
	local currentIndex = packages

	if (typeof(importString) ~= "string") then
		return error("[FDK - PACKAGE MANAGER] Expected string, got "..typeof(importString))
	end

	if (importString == "FDK") then
		return external
	end

	if (importString == "Class") then
		return baseClass
	end

	local tab = { }

	for x in string.gmatch(importString, "%a+") do
		tab[#tab + 1] = x
	end

	for _, v in pairs(tab) do
		if (currentIndex[v]) then
			currentIndex = currentIndex[v]
		else
			return error("[FDK - PACKAGE MANAGER] Package does not exist.")
		end
	end

	if (currentIndex:IsA("ModuleScript")) then
		local class = require(currentIndex)

		if (typeof(class) ~= "function" and typeof(class) ~= "table") then
			return error("[FDK - PACKAGE MANAGER] Expected function or table, got "
				.. typeof(class) .. " while initalizing class module.")
		end

		FDK.WrapEnv(class)

		return class(), currentIndex.Name
	end

	if (currentIndex:IsA("NumberValue") or currentIndex:IsA("IntValue")) then
		local class = require(currentIndex.Value)

		if (typeof(class) ~= "function" and typeof(class) ~= "table") then
			return error("[FDK - PACKAGE MANAGER] Expected function or table, got "
				.. typeof(class) .." while initalizing class module.")
		end

		FDK.WrapEnv(class)

		return class(), currentIndex.Name
	end

	return error("[FDK - PACKAGE MANAGER] Package does not exist.")
end

FDK.WrapEnv = function(func)
	local funcEnv

	if (typeof(func) == "function") then
		funcEnv = getfenv(func)
	end

	if (typeof(func) == "table") then
		funcEnv = func
	end

	if (not funcEnv) then
		return error("[FDK - PACKAGE MANAGER] Expected function or table, got "..typeof(funcEnv)..".")
	end

	funcEnv.import = function(importString)
		local class, name = FDK.Import(importString)

		return class, name
	end

	funcEnv.Class = baseClass
	funcEnv.new = FDK.New
end

_G.FDK = external

return external