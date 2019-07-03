--[[
	Flame Development Toolkit, Version 1.0.0
	
	BaseClass module, used as a root for all other classes. Internally indexed as FLAMECLASS
	
	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]

local blankFunction = function() end -- Added for cleaner code
local baseClass = {} -- The baseClass table used for all other classes. It's internally mapped as FLAMECLASS.
local internal = {} -- Used for explicitly this module, no other modules should have access to this.
internal.classes = {} -- Class information

local superLock

superLock = function(tab) -- Allows the making of read-only tables through the use of newproxy
	local proxy = { }

	table.foreach(tab, function(i, k)
		proxy[i] = k 
	end)
	
	setmetatable(proxy, {})
	
	getmetatable(proxy).__index = function(self, k)
		if (typeof(tab[k]) == "table") then
			return superLock(tab[k])
		end

		return tab[k]
	end
	
	getmetatable(proxy).__newindex = function()
		return error("[FDK - CLASS LOCK] Table locked for new indexes.")
	end
	
	getmetatable(proxy).__tostring = function()
		return tostring(tab)
	end
	
	getmetatable(proxy).__metatable = "Locked."
	
	return proxy
end

local external = superLock(baseClass)

internal.equals = function(self, otherClass)
	local props = internal.classes[otherClass]
	
	if (props) then
		if (self:isA(props.ClassName)) then
			return true
		end
	end

	return false
end

internal.__new = function(self, ...)
	if (self[self.ClassName]) then
		if typeof(self[self.ClassName]) == "function" then
			return self[self.ClassName](self:Extend(self.ClassName), ...)
		else
			error("[FDK - CONSTRUCTOR]: No constructor function found for class "..self.ClassName)
		end
	else
		error("[FDK - CONSTRUCTOR]: No constructor function found for class "..self.ClassName)
	end
end

baseClass.New = function(self, className) -- Generates a new metatable and table associated for a class
	if (typeof(className) ~= "string") then
		return error("[FDK - CLASS INITIALISATION]: Expected string, got "..typeof(className)..".")
	end
	
	local newClass = { }
	local classProperties = { } -- Information about the class such as what other classes it inherits. Used in the IsA function.
	
	classProperties.ClassName = className 
	classProperties.Inherits = {["FLAMECLASS"] = external}

	local externalProperties = superLock(classProperties)
	
	local ts = tostring(newClass):sub(7)
	local newClassMT = { }

	newClassMT.__index = function(self, k)
		if (rawget(newClass, k)) then
			return rawget(newClass, k)
		end
		
		if (classProperties[k]) then
			return externalProperties[k]
		end
		
		if (baseClass[k]) then
			return baseClass[k]
		end
	end
	
	newClassMT.__call = internal.__new
	
	newClassMT.__tostring = function()
		return className..": "..ts
	end
	
	newClassMT.__eq = internal.equals
	
	setmetatable(newClass, newClassMT)
	
	internal.classes[newClass] = classProperties
	
	newClass.__properties = externalProperties
	
	return newClass
end

baseClass.Extend = function(extender, className)
	local newClass = baseClass:New(className)
	
	local props = internal.classes[extender]
	internal.classes[newClass].Inherits = props.Inherits
	internal.classes[newClass].Inherits[props.ClassName] = extender
	
	getmetatable(newClass).__index = function(self, k)
		if (rawget(newClass, k)) then
			return rawget(newClass, k)
		end
		
		if (extender[k]) then
			return extender[k]
		end
		
		if (baseClass[k]) then
			return baseClass[k]
		end
	end
	
	
	return newClass
end

baseClass.Lock = function(self)
	return superLock(self)
end

baseClass.isA = function(self, className)
	local properties = internal.classes[self]
	
	if (properties.Inherits[className]) then
		return true
	else
		return false
	end
end

baseClass.Registered = function(o)
	if (internal.classes[o]) then
		return true
	else
		return false
	end
end

return external