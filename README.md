<h1 align="center">Flame Development Toolkit</h1>
<div align="center">
	<a href="https://github.com/TheFlamingBlaster/FDK/tree/master/LICENSE">
		<img src="https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg?style=flat-square" alt="Lisence" />
	</a>
	<a href="https://travis-ci.com/TheFlamingBlaster/FDK">
		<img src="https://img.shields.io/travis/com/TheFlamingBlaster/FDK.svg?style=flat-square" alt="Travis" />
	</a>
	<a href="https://coveralls.io/github/TheFlamingBlaster/FDK?branch=master">
		<img src="https://img.shields.io/coveralls/github/TheFlamingBlaster/FDK.svg?style=flat-square" alt="Coveralls" />
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
Install the FDK module in ReplicatedStorage. The easiest way to do this is to the use FDK installer plugin, which can be found at:

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

Classes can have their variables carried over onto new classes by using the Extend() function of BaseClass.

```lua
local originalClass = Class:New("OriginalClass")
originalClass.Demo = true
local newClass = originalClass:Extend({})
print(newClass.Demo == true) --> Should return true.
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

Packages can be located in folders and subfolders. You can index them using "."

<img src="/images/FolderStructure.png"
     alt="Folder Structure"
     style="float: left; margin-right: 10px;" />

In this example, you could import camera by importing game.user.camera
```lua
import("game.usr.camera")
```
## Examples

## How to contribute
