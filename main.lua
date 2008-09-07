--[[
Toastercrush Plugins Suite, written by Scuba Steve 9.0. See README for installation instructions and descriptions.

Copyright info: 
Copyright Tyler Gibbons(Scuba Steve 9.0), 2008. Feel free to use, distribute, and modify any and all sections of code as 
	long as I am attributed as the original author of any code used, modified, or distributed. If you make something cool
	using this code, I'd love to know. Send me a message on IRC, though you'll have to message Miharu first to figure out 
	name I'm currently using.

This file is the main loader for the plugin modules. It also loads common functions used by several plugins.
Furthermore, it provides a configuration interface for the whole of the plugin suite.
--]]

declare("tcs", {})

--[[ The all important require() function. This is responsible for checking which modules are loaded and
loading the modules themselves if they need to be loaded. --]]
tcs._LOADED = { "tcs-plugins"}
tcs.LUA_PATH = "?/main.lua;?/?;?/?.lua;?;?.lua;plugins/?/main.lua;plugins/?/?;plugins/?/?.lua;../?/?;../?/?.lua;../?/main.lua;"
tcs.PROVIDED = {} 					--Table describing the plugins that have provided config interfaces.
									--To add an interface, merely do tcs.ProvideConfig("plugin name", conf_handle, shortdesc[, state_func])
									--When the plugins list is reloaded by the user, TCS will call conf_handle:on_refresh() if it exists.
									--Conf handle should be an iup handle to the configuration window dialog
									--If it exists, conf_handle:init() will be called ONCE ONLY, then conf_handle will be displayed via ShowDialog()
									--state_func is passed 1 if the plugin is enabled, 0 if disabled, and -1 to query the current enabled/disabled state
function tcs.require(libstring)
	--Strip out .lua file extension and any path info.
	libstring = string.gsub(libstring, "\\", "/") -- lawlwindows, backslashes need to be escaped anyway
	libstring = string.gsub(libstring, "(.)%.lua", "%1")
	libstring = string.gsub(libstring, ".+/(.)", "%1")
	libstring = string.lower(libstring)

	if(tcs._LOADED[libstring]) then return true, "ERR_ALREADY_LOADED" end
	local err = nil
	local file = nil

	for path in string.gmatch(tcs.LUA_PATH, "[^;]+") do
		file, err = loadfile(string.gsub(path, "?", libstring))
		if(file) then break end
	end
	
	if(not file) then return false, err end
	tcs._LOADED[libstring] = true
	return true, file()
end
--[[---------------------------------------------------------------------------LOADED PLUGINS-------------------------------------------------------------------------------]]
tcs.require("common")
tcs.require("alert_machine")
tcs.require("auto_nav")
tcs.require("central_info")
tcs.require("chain_fire")
tcs.require("make_friends")
tcs.require("vo_clock")
--[[----------------------------------------------------------------------PLUGIN UI STARTS HERE------------------------------------------------------------------------]]
tcs.ui = {}
tcs.ui.configbs = {}
tcs.ui.enableb = {} 	--Table with references to all our stationtoggles that enable or disable plugins

local function SizeAdjustment(configbs)
	local biggest = 0
	for _, value in pairs(configbs) do
		if tonumber(value.w) > biggest then
			biggest = tonumber(value.w)
		end
	end
	
	for _, value in pairs(configbs) do
		value.size = biggest
	end
end
tcs.ui.configb = iup.stationbutton { title = "TCS Config",
				hotkey = iup.K_t,
				action=function()
					HideDialog(OptionsDialog)
					--tcs.ui.confdlg:setup()
					ShowDialog(tcs.ui.confdlg, iup.CENTER, iup.CENTER)
					SizeAdjustment(tcs.ui.configbs)
					iup.Refresh(tcs.ui.confdlg)
				end}

function tcs.ui.InsertOption(confb)
	dlg = tcs.GetRelative(OptionsDialog, -3)
	i = 1
	while dlg[i+1] do
		i = i + 1								--Walk through all the elements of the dialog. We want to be just before last
	end
	tmp = dlg[i]
	iup.Detach(dlg[i])
	iup.Append(dlg, iup.hbox {confb, iup.label{title="TCS Plugins Config"},alignment="ACENTER", gap=2})
	iup.Append(dlg, tmp)
	iup.Refresh(dlg)
end

tcs.ui.InsertOption(tcs.ui.configb)					--Adds our config button. A button that opens the menu.

local function CreateTCSConfDlg()
	local mainv = iup.vbox{
					iup.hbox{iup.fill{},iup.label{title="TCS Plugin Config Menu",font=Font.H3},iup.fill{}},
					gap=2,
					margin="2x2"
				}
	local init = false
	for key, value in pairs(tcs.PROVIDED) do
		if not key then break end
		if not value then break end
		if value[3] then
			en = iup.stationtoggle{action=value[3],tip="Enable/Disable Plugin",value=value[3](en,-1)}
			table.insert(tcs.ui.enableb, en)
		else
			en = iup.stationtoggle{action=function() end,tip="Enable/Disable Plugin",active="NO"}
		end
		local figb = iup.stationbutton{title=key,
								action=function()
									HideDialog(tcs.ui.confdlg)
									if value[1] and value[1].init then
										value[1]:init()
									end
									ShowDialog(value[1], iup.CENTER, iup.CENTER)
								end}
		
		if not value[1] then figb.active="NO" end
		table.insert(tcs.ui.configbs, figb)
		iup.Append(mainv, iup.hbox{en, figb, iup.label{title=value[2]}, alignment="ACENTER", gap=2 })
		init = true
	end
	
	if not init then
		iup.Append(mainv, iup.hbox{iup.label{title="There are no configuration interfaces registered."}, alignment="ACENTER",gap=2})
	end
	local closebutton = iup.stationbutton{title="Close",action=function() 
								HideDialog(maindlg)
								ShowDialog(OptionsDialog,iup.CENTER, iup.CENTER)
							end}
	iup.Append(mainv, iup.hbox{iup.label{title="v"..tcs.VERSION},iup.fill{}, closebutton, alignment="ACENTER",gap=2})
	
	maindlg = iup.dialog{
		iup.stationhighopacityframe{
			iup.stationhighopacityframebg{
				mainv
			}
		},
		menubox="NO",
		resize="NO",
		border="NO",
		defaultesc = closebutton,
		bgcolor = "0 0 0 0 *"
	}
	return maindlg
end

function tcs.ui.RefreshEnabled()
	for _, toggle in ipairs(tcs.ui.enableb) do
		toggle.value = toggle:action(-1)
	end
	iup.Refresh(tcs.ui.confdlg)
end

--tcs.ProvideConfig("Test Button", OptionsDialog, "This is a bullshit test button.", this_can_be_enabled)
tcs.ui.confdlg = CreateTCSConfDlg()
