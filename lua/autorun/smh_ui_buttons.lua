if SERVER then
	return
end

local isOpen = false

list.Set("DesktopWindows", "SMHMenu", {
	title = "#ui.smh.buttons.menu",
	icon = "icon64/stopmotionhelper.png",
	init = function(icon, window)
		if not SMH then
			notification.AddLegacy(language.GetPhrase("ui.smh.notinstalled"), NOTIFY_ERROR, 5)
			return
		end

		-- The icon hook doesn't start until after the DoClick event
		function icon:Think()
			-- Don't run the bound checks until the context menu is visible
			if not g_ContextMenu:IsVisible() then
				return
			end

			local x, y = input.GetCursorPos()

			-- If this isn't here, then the mouse pointer is no longer free
			if isOpen then
				if
					x >= icon:GetX()
					and x < icon:GetX() + icon:GetWide()
					and y >= icon:GetY()
					and y < icon:GetY() + icon:GetTall()
				then
					g_ContextMenu:MakePopup()
				else
					g_ContextMenu:SetMouseInputEnabled(false)
					g_ContextMenu:SetKeyboardInputEnabled(false)
				end
			end
		end

		-- Remove the default DFrame that comes with the icon
		window:Remove()

		if not isOpen then
			SMH.Controller.OpenMenu()
			-- We need this to have access to the icon to click
			g_ContextMenu:SetHangOpen(true)
		else
			SMH.Controller.CloseMenu()
			-- We need this to allow the player to close the context menu
			g_ContextMenu:SetMouseInputEnabled(true)
			g_ContextMenu:SetKeyboardInputEnabled(false)
			g_ContextMenu:SetHangOpen(false)
		end
		isOpen = not isOpen
	end,
})

---@param cpanel ControlPanel|DForm
local function options(cpanel)
	if not SMH then
		cpanel:Help("#ui.smh.notinstalled")
		return
	end

	local isPlaying = false

	cpanel:Help("#ui.smh.buttons.playback.help")
	local playButton = cpanel:Button("#ui.smh.buttons.playback.play", "")

	function playButton:DoClick()
		if isPlaying then
			RunConsoleCommand("-smh_playback")
		else
			RunConsoleCommand("+smh_playback")
		end
		isPlaying = not isPlaying
		playButton:SetText(Format("#ui.smh.buttons.playback.%s", isPlaying and "stop" or "play"))
	end
end

hook.Remove("PopulateToolMenu", "smh_buttons")
hook.Add("PopulateToolMenu", "smh_buttons", function()
	spawnmenu.AddToolMenuOption("Options", "Stop Motion Helper", "smh_buttons", "Buttons", "", "", options, {})
end)
