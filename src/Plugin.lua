--[[
	Installer for Flame Development Toolkit. Version 0.1

	Allows for the easy automatic installation of FDK's branches.

	TheFlamingBlaster, 2019
	Licenced under the terms at: https://www.apache.org/licenses/LICENSE-2.0.txt
--]]

local toolbar = plugin:CreateToolbar("Import FDK")

local master = {
	["BaseClass"] = "https://raw.githubusercontent.com/TheFlamingBlaster/FDK/master/src/BaseClass.lua",
	["FDK"] = "https://raw.githubusercontent.com/TheFlamingBlaster/FDK/master/src/FDK.lua"
}
-- Where the sources for each branch are located.
-- local dev = { } :: TODO
-- local legacy = { } :: TODO

local masterButton = toolbar:CreateButton("Import Master", "Imports the master FDK enviroment into ReplicatedStorage."..
	"This one should be stable and fully functional.", "")
local newPackageButton = toolbar:CreateButton("New Package", "Creates a new package", "")
-- Add the toolbar button to import.

local hs = game:GetService("HttpService")

local function getPackages() -- Add the proper package folders.
	local serverPackages
	serverPackages = game:GetService("ServerScriptService"):FindFirstChild("ServerPackages")
	if not serverPackages then
		serverPackages = Instance.new("Folder", game:GetService("ServerScriptService"))
		serverPackages.Name = "ServerPackages"
	end

	local clientPackages
	clientPackages = game:GetService("ReplicatedStorage"):FindFirstChild("ClientPackages")
	if not clientPackages then
		clientPackages = Instance.new("Folder", game:GetService("ReplicatedStorage"))
		clientPackages.Name = "ClientPackages"
	end

	return serverPackages, clientPackages
end

local function uninstall() -- Auto-remove FDK if it exists. Packages are preserved.
	local fdk = game:GetService("ReplicatedStorage"):FindFirstChild("FDK")
	if fdk then
		fdk:Destroy()
	end
end

local function getHttp(url, cache)
	local testHttp = pcall(function() hs:GetAsync("https://google.com") end)
	if testHttp == false then
		return error("Enable http to import from GitHub.") -- returns an error message for http
	end

	local response = hs:GetAsync(url, cache)
	return response
end

masterButton.Click:Connect(function()
	print("\nInstalling FDK...\n")
	uninstall()
	getPackages()
	local masterBase = getHttp(master.BaseClass, true)
	local masterFDK = getHttp(master.FDK, true)

	local fdk = Instance.new("ModuleScript", game:GetService("ReplicatedStorage"))
	fdk.Name = "FDK"
	fdk.Source = masterFDK

	local baseClass = Instance.new("ModuleScript", fdk)
	baseClass.Name = "BaseClass"
	baseClass.Source = masterBase

	print("\nSuccessfully installed FDK into ReplicatedStorage.\nCheck the GitHub page at" ..
		" TheFlamingBlaster/FDK for usage instructions in setting up your own packages.")
end)

newPackageButton.Click:Connect(function()
	local newModule = Instance.new("ModuleScript")
	newModule.Name = "NewPackage"
	newModule.Source = "return function()\n	\nend"
	local selection = game.Selection:Get()
	if selection[1] then
		newModule.Parent = selection[1]
	else
		local serverPackages = getPackages()
		newModule.Parent = serverPackages
	end
	plugin:OpenScript(newModule)
	game.Selection:Set({newModule})
end)