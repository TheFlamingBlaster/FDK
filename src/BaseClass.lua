--[[
	BaseClass module, used as a root for all other classes. Internally indexed as BaseClass

	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]

local BaseClass = { }
local internal = { }

internal.classes = { }


--[[
	Function: Checks the object against any types given. cleans code up
	Arguments: object - check against, ... - types
]]
local function checkTypes(object, ...)
	for _, check in pairs({ ... }) do
		if (typeof(object) == check) then
			return true
		end
	end

	return false
end

--[[
	Function: Tries to get the metamethod of a metatable
	Arguments: object - class or any table /shrug, try - what is being tried
]]
local function tryGetMetatable(object, try)
	local _, got = pcall(function()
		return getmetatable(object)[try]
	end)

	return got
end

--[[
	Function: Creates a proxy interface for locked classes
	Arguments: object - class or any table /shrug
]]
local function createProxyInterface(object)
	local cachedObject = { } -- should cached be a weak table to prevent garbage collection?

	return setmetatable({ }, {
		__index = function(self, index)
			if (typeof(object[index]) == "table") then
				if (cachedObject[index] == nil) then
					cachedObject[index] = createProxyInterface(object[index])
				end

				return cachedObject[index]
			end

			return object[index]
		end,

		__newindex = function(self, index, value)
			return error("[BaseClass - LOCKED] This table is locked")
		end,

		__call = function(self, ...)
			return object(...):lock()
		end,

		__tostring = function(self)
			return tostring(object)
		end,

		--Class Metamethods
		__concact = tryGetMetatable(object, "__concat"),
		__unm = tryGetMetatable(object, "__unm"),
		__add = tryGetMetatable(object, "__add"),
		__sub = tryGetMetatable(object, "__sub"),
		__mul = tryGetMetatable(object, "__mul"),
		__div = tryGetMetatable(object, "__div"),
		__mod = tryGetMetatable(object, "__mod"),
		__pow = tryGetMetatable(object, "__pow"),
		__eq = tryGetMetatable(object, "__eq"),
		__lt = tryGetMetatable(object, "__lt"),
		__le = tryGetMetatable(object, "__le"),
		__gc = tryGetMetatable(object, "__gc"),
		__len = tryGetMetatable(object, "__len"),
		__mode = tryGetMetatable(object, "__mode"),
		--Class Metamethods

		__metatable = "B-Locked."
	})
end

--[[
	Function: Checks if the classes are the exact same
	Arguments: self - the class, value - the other class
]]
internal.__eq = function(self, value)
	return internal.classes[value] and self:isA(value["className"]) or false
end

--[[
	Function: When the init function is called this is called and returns an extended class
	Arguments: self - the class, ... - values supplied by the user
]]
internal.__call = function(self, ...)
	local className = self.className
	local initFunction = self[className]

	if (initFunction and checkTypes(initFunction, "function")) then
		return initFunction(self:Extend(className), ...)
	end

	return error("[BaseClass - CONSTRUCTOR]: No constructor function found for class " .. className)
end

local external = createProxyInterface(BaseClass)

--[[
	Function: Creates a new class from the class name
	Arguments: self - the module, className - the class name
]]
BaseClass.new = function(self, className)
	if (not checkTypes(className, "string") or string.len(className) == 0) then
		return error("[FDK - CLASS INITIALISATION]: Expected string, got " .. className .. ".")
	end

	local newClass, classProperties = { }, {
		["className"] = className,
		["inherits"] = {
			["BaseClass"] = external
		}
	}

	local externalClassProperties, classString =
		createProxyInterface(classProperties),
		className .. ": " ..tostring(newClass):sub(7)

	internal.classes[newClass] = classProperties
	newClass.__properties = externalClassProperties

	return setmetatable(newClass, {
		__index = function(self, index)
			if (rawget(newClass, index)) then
				return rawget(newClass, index)
			end

			if (classProperties[index]) then
				return externalClassProperties[index]
			end

			if (BaseClass[index]) then
				return BaseClass[index]
			end
		end,

		__newindex = function(self, index, value)
			if (string.sub(index, 1, string.len("__")) == "__" and checkTypes(value, "function", "string")) then
				getmetatable(self)[index] = value
			end

			return rawset(self, index, value)
		end,


		__tostring = function(self)
			return classString
		end,

		__eq = internal.__eq,

		__call = internal.__call
	})
end

--[[
	Function: Creates a new class and allows access to the inherited class
	Arguments: extender - the original class, className - the new class name
]]
BaseClass.extend = function(extender, className)
	local newClass, properties =
		BaseClass:New(className), internal.classes[extender]

	internal.classes[newClass].inherits = properties.inherits
	internal.classes[newClass].inherits[properties.className] = extender

	getmetatable(newClass).__index = function(self, k)
		if (rawget(newClass, k)) then
			return rawget(newClass, k)
		end

		if (extender[k]) then
			return extender[k]
		end

		if (BaseClass[k]) then
			return BaseClass[k]
		end
	end

	return newClass
end

--[[
	Function: Returns a locked class
	Arguments: self - the class
]]
BaseClass.lock = function(self)
	return createProxyInterface(self)
end

--[[
	Function: Tells if a class is inheritied by antoher
	Arguments: self - the class, className - the other class
]]
BaseClass.isA = function(self, className)
	return internal.classes[self].inherits[className] ~= nil
end

--[[
	Function: Tells if a class is registered in internals
	Arguments: self - this class, class - checking another class
	Explain: If you provide the argument class it will check that instead of this class, self
]]
BaseClass.registered = function(self, class)
	return internal.classes[class ~= nil and class or self] ~= nil
end

--[[
	Function: Allows unregistering classes
	Arguments: self - the class to unregister
]]
BaseClass.unregister = function(self)
	internal.classes[self] = nil
end

--Legacy Support
BaseClass.Registered = BaseClass.registered
BaseClass.IsA = BaseClass.isA
BaseClass.Lock = BaseClass.lock
BaseClass.Extend = BaseClass.extend
BaseClass.New = BaseClass.new
--Legacy Support

return external