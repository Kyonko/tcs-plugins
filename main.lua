--[[
Toastercrush Plugins Suite, written by Scuba Steve 9.0. See README for installation instructions and descriptions.

This file is the main loader for the rest of the plugins. It also loads common functions used by several plugins.
Furthermore, it provides a configuration interface for the whole of the plugin suite.
--]]

declare("tcs", {})
tcs.VERSION = "1.0.0"


--[[ The all important require() function. This is responsible for checking which modules are loaded and
loading the modules themselves if they need to be loaded. --]]
tcs._LOADED = { "tcs-plugins"}
tcs.LUA_PATH = "?;?.lua;plugins/?/main.lua;plugins/?/?;plugins/?/?.lua;../?/?;../?/?.lua;../?/main.lua"
tcs.LUA_PATH = tcs.LUA_PATH .. ";snigulp/?/main.lua;snigulp/?/?;snigulp/?/?.lua"
tcs.PROVIDED = {} 					--Table describing the plugins that have provided config interfaces.
									--To add an interface, merely do tcs.ProvideConfig("plugin name", conf_handle, shortdesc)
									--When the plugins list is reloaded by the user, TCS will call conf_handle:on_refresh() if it exists.
									--Conf handle should be an iup handle to the configuration window dialog
									--If it exists, conf_handle:init() will be called ONCE ONLY, then conf_handle will be displayed via ShowDialog()
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

--[[----------------------------------------------------------------------PLUGIN UI STARTS HERE------------------------------------------------------------------------]]
tcs.require("common")
tcs.ui = {}
tcs.ui.configb = iup.stationbutton { title = "TCS Config",
				hotkey = iup.K_t,
				action=function()
					HideDialog(OptionsDialog)
					--tcs.ui.confdlg:setup()
					ShowDialog(tcs.ui.confdlg, iup.CENTER, iup.CENTER)
					tcs.ui.cursubdlg = tcs.ui.confdlg
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
		iup.Append(mainv, iup.hbox{iup.stationbutton{title=key,
								action=function()
									HideDialog(tcs.ui.cursubdlg)
									if value[1].init then
										value[1]:init()
									end
									ShowDialog(value[1], iup.CENTER, iup.CENTER)
									tcs.ui.cursubdlg = value[1]
								end}, iup.label{title=value[2]}, alignment="ACENTER", gap=2 })
		init = true
	end
	
	if not init then
		iup.Append(mainv, iup.hbox{iup.label{title="There are no configuration interfaces registered."}, alignment="ACENTER",gap=2})
	end
	local closebutton = iup.stationbutton{title="Close",action=function() 
								HideDialog(maindlg)
								tcs.ui.cursubdlg = OptionsDialog
								ShowDialog(tcs.ui.cursubdlg, iup.CENTER, iup.CENTER)
							end}
	iup.Append(mainv, iup.hbox{iup.fill{}, closebutton, alignment="ACENTER",gap=2})
	
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


--tcs.ProvideConfig("Test Button", OptionsDialog, "This is a bullshit test button.")
tcs.ui.confdlg = CreateTCSConfDlg()
