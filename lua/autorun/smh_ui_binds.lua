if SERVER then
	AddCSLuaFile("smh/client/derma/smhbinder.lua")
	return
end

include("smh/client/derma/smhbinder.lua")

local clientVDF = "cfg/client.vdf"

local smhTest = "smh_"

local function test(str)
	return str[1] ~= "-" and string.find(str, smhTest, 1, true)
end

---@type string[]
local smhConVars = {}
---@type string[]
local smhCommands = {}

local function init()
	local commandTable = concommand.GetTable()
	for str, callback in pairs(commandTable) do
		if test(str) then
			table.insert(smhCommands, str)
		end
	end

	local convars = util.KeyValuesToTable(file.Read(clientVDF, "GAME"))
	for str, val in pairs(convars) do
		if test(str) then
			table.insert(smhConVars, str)
		end
	end
end

---Helper for DForm
---@param cPanel ControlPanel|DForm
---@param name string
---@param type "ControlPanel"|"DForm"
---@return ControlPanel|DForm
local function makeCategory(cPanel, name, type)
	---@type DForm|ControlPanel
	local category = vgui.Create(type, cPanel)

	category:SetLabel(name)
	cPanel:AddItem(category)
	return category
end

---@param cpanel ControlPanel|DForm
local function options(cpanel)
	init()

	-- print("Commands")
	-- PrintTable(smhCommands)

	cpanel:Help("#ui.smh.keybinds.help1")
	cpanel:Help("#ui.smh.keybinds.help2")

	local commandCategory = makeCategory(cpanel, language.GetPhrase("ui.smh.keybinds.concommand"), "ControlPanel")

	for _, command in ipairs(smhCommands) do
		local label = commandCategory:Help(command)
		label:SetContentAlignment(6)
		local binder = vgui.Create("SMHBinder", commandCategory)
		binder:SetConsoleString(command)
		commandCategory:AddItem(binder)
	end
end

hook.Remove("PopulateToolMenu", "smh_keybinds")
hook.Add("PopulateToolMenu", "smh_keybinds", function()
	spawnmenu.AddToolMenuOption("Options", "Stop Motion Helper", "smh_keybinds", "Keybinds", "", "", options, {})
end)
