<h1 align="center">Flame development toolkit</h1>
<div align="center">
	<a href="https://github.com/TheFlamingBlaster/FDK/tree/master/LICENSE">
		<img src="https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg?style=flat-square" alt="Lisence" />
	</a>
</div>

<div align="center">
	FDK is a small lightweight class system that acts like <a href="https://docs.oracle.com/en/">Java</a>.
</div>

<div align="center">
	<b>⚠️ FDK should only be used for experimental projects until v1.0.0 ⚠️</b>
</div>

<div>&nbsp;</div>

## Index

1. [Examples](#examples)
2. [Setup](#Setup)
3. [Usage](#usage)
4. [How to Contribute](#how-to-contribute)

## Setup
Install the FDK module into ReplicatedStorage. The easiest way to do this is to the use FDK installer plugin, which can be found at:

Roblox Plugin: https://www.roblox.com/library/3410089003/FDK-Installer

Source: https://github.com/TheFlamingBlaster/FDK/blob/master/src/Plugin.lua

After this is complete, click the "Install Master" button on the FDK toolbar.
The FDK module and base class should be located in ReplicatedStorage.

```lua
local fdkModule = game:GetService("ReplicatedStorage"):FindFirstChild("FDK")
local fdk = require(fdkModule)
fdk.WrapEnv(getfenv()) -- Add the BaseClass Class and the Import function into the current enviroment.
```

## Usage
Packages are simply ModuleScripts which return a function. The function is automatically wrapped in the FDK enviroment to allow for the BaseClass Class and the Import function to be used.

A basic "Hello, world!" class:
```lua
-- In a package located in either ServerScriptService.ServerPackages or ReplicatedStorage.ClientPackages
-- FDK will automatically provide packages based on the enviroment where the module is running.
return function() 
	local helloWorld = Class:New("HelloWorld")
	helloWorld.Hello = function()
		print("Hello, world!")
	end

	return helloWorld
end

```
In the script requiring FDK:

```lua
local fdkModule = game:GetService("ReplicatedStorage"):FindFirstChild("FDK")
local fdk = require(fdkModule)
fdk.WrapEnv(getfenv()) -- Add the BaseClass Class and the Import function into the current enviroment.

local helloWorld = import("HelloWorld")
helloWorld.Hello() -- > Should print "Hello, world"
```

Like many other programming languages, classes can be initalised:

```lua
return function() 
	initClass = Class:New("Init")
	intClass.Init = function(newClass) -- The init function for a class is the same as the name of the class.
		--newClass is the same is initClass:Extend({}). All of the variables added to the proto class are carried over into the new class
		newClass.Initalised = true
		retur newClass
	end
end
```

## Examples

## How to contribute
