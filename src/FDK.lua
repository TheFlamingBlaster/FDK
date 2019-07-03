--[[
	Flame Development Toolkit, Version 1.0.0
	
	Main module for package management.
	
	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]

local baseClass = script.BaseClass
local FDK = baseClass:New("Flame Development Toolkit")
local external = FDK:Lock()
local packages

local serverTest = pcall(function() game:GetService("ServerScriptService") end)

if serverTest then
    packages = game:GetService("ServerScriptService").ServerPackages
else
    packages = game:GetService("ReplicatedStorage").ClientPackages
end

FDK.Import = function(importString)
	local currentIndex = packages

	if (typeof(importString) ~= "string") then
		return error("[FDK - PACKAGE MANAGER] Expected string, got "..typeof(importString))
	end
	
	if (importString == "fdk") then
		return external
	end
	
	if (importString == "Class") then
		return baseClass
	end
	
	local tab = { }

	for x in string.gmatch(importString, "%a+") do
		tab[#tab + 1] = x
	end
	
	for i, v in pairs(tab) do
		if (currentIndex[v]) then
			currentIndex = currentIndex[v]
		else
			return error("[FDK - PACKAGE MANAGER] Package does not exist.")
		end
	end
	
	
	if (currentIndex:IsA("ModuleScript")) then
		local class = require(currentIndex)

		if (typeof(class) ~= "function" and typeof(class) ~= "table") then
			return error("[FDK - PACKAGE MANAGER] Expected function or table, got "..typeof(class).." while initalizing class module.")
		end
			
		FDK.WrapEnv(class)

		return class(), currentIndex.Name
	end
	
	if (currentIndex:IsA("NumberValue") or currentIndex:IsA("IntValue")) then
		local class = require(currentIndex.Value)

		if (typeof(class) ~= "function" and typeof(class) ~= "table") then
			return error("[FDK - PACKAGE MANAGER] Expected function or table, got "..typeof(class).." while initalizing class module.")
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