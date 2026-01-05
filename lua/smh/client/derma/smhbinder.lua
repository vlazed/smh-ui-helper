---@class SMHBinder: DBinder
---@field m_iSelectedNumber number
---@field m_sConsoleString string
---@field GetConsoleString fun(self: SMHBinder): string
local PANEL = {}

AccessorFunc(PANEL, "m_iSelectedNumber", "SelectedNumber")
AccessorFunc(PANEL, "m_sConsoleString", "ConsoleString")

local bindCommand = 'bind %s "%s"'

function PANEL:Init()
	self:SetSelectedNumber(0)
	self:SetSize(60, 30)

	self:SetTooltip("#ui.smh.keybinds.tooltip")

	self.Arguments = {}
end

function PANEL:UpdateText()
	local str = input.GetKeyName(self:GetSelectedNumber())
	if not str then
		str = "NONE"
	end

	str = language.GetPhrase(str)

	self:SetText(str)
end

function PANEL:DoClick()
	if not self:GetConsoleString() then
		return
	end

	local num = self:GetSelectedNumber()
	local key = num > 0 and num
	SetClipboardText(Format(bindCommand, key and input.GetKeyName(key) or "<key>", self:GetConsoleString()))
end

function PANEL:SetSelectedNumber(iNum)
	self.m_iSelectedNumber = iNum
	self:UpdateText()
	self:OnChange(iNum)
end

function PANEL:SetConsoleString(str)
	local convar = GetConVar(str)
	if convar then
		self.m_sConsoleString = str
		self.Arguments[1] = convar:GetString()
		return
	end

	local command = concommand.GetTable()[str]
	if command then
		self.m_sConsoleString = str
		local hasBind = input.LookupBinding(str, true)
		self:SetSelectedNumber(hasBind and input.GetKeyCode(input.LookupBinding(str, true)) or 0)
		return
	end
end

function PANEL:Think()
	local str = self:GetConsoleString()
	if str then
		local hasBind = input.LookupBinding(str, true)
		self:SetSelectedNumber(hasBind and input.GetKeyCode(hasBind) or 0)
	end
end

function PANEL:SetValue(iNumValue)
	self:SetSelectedNumber(iNumValue)
end

function PANEL:GetValue()
	return self:GetSelectedNumber()
end

function PANEL:OnChange(iNum) end

vgui.Register("SMHBinder", PANEL, "DBinder")
