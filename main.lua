--[[
Toastercrush Plugins Suite, written by Scuba Steve 9.0. See README for installation instructions and descriptions.

Copyright info: 
Copyright Tyler Gibbons(Scuba Steve 9.0), 2008-2011. Feel free to use, distribute, and modify any and all sections of code as 
	long as I am attributed as the original author of any code used, modified, or distributed. If you make something cool
	using this code, I'd love to know. Send me a message on IRC @ slashnet.org as 'kavec' and say hi!

This file is the main loader for the plugin modules. It also loads common functions used by several plugins.
Furthermore, it provides a configuration interface for the whole of the plugin suite.
--]]

declare("tcs", {})
tcs.e = {}
--End with / for any actual directories!
--Diagnostic function
function tcs.test(plugin)
	if plugin == "common" then printtable({loadfile("plugins/tcs-plugins/common.lua")}) return end
	printtable({loadfile("plugins/tcs-plugins/"..plugin.."/main.lua")})
end


--[[ The all important require() function. This is responsible for checking which modules are loaded and
loading the modules themselves if they need to be loaded. --]]
tcs._LOADED = { "tcs-plugins"}
tcs.LUA_PATH = "?/main.lua;?/?;?/?.lua;?;?.lua;plugins/?/main.lua;plugins/?/?;plugins/?/?.lua;../?/?;../?/?.lua;../?/main.lua;"
tcs.PROVIDED = {} 					--Table describing the plugins that have provided config interfaces.
									--To add an interface, merely do tcs.ProvideConfig("plugin name", conf_handle, shortdesc[, cli_cmd[, state_func]])
									--When the plugins list is reloaded by the user, TCS will call conf_handle:on_refresh() if it exists.
									--Conf handle should be an iup handle to the configuration window dialog
									--If it exists, conf_handle:init() will be called ONCE ONLY, then conf_handle will be displayed via ShowDialog()
									--cli_cmd is a table like so:
									--	{cmd = "word"[,interp = function]} 
									--	'cmd' must be a one-word string command. It will be used to open the relevant options dialog when called
									--	'interp' is an OPTIONAL function that will receive command arguments when presented by the user
									--state_func is passed 1 if the plugin is enabled, 0 if disabled, and -1 to query the current enabled/disabled state
--Holds our interps for command. Use tcs.COMMAND[cli_cmd](input) to use these
--Also! cli_cmd is the same as cli_cmd.cmd from above 									
tcs.COMMAND = {}
function tcs.require(libstring)
	--Strip out .lua file extension and any path info.
	libstring = string.gsub(libstring, "\\", "/") -- lawlwindows, backslashes need to be escaped anyway
	libstring = string.gsub(libstring, "(.)%.lua", "%1")
	libstring = string.gsub(libstring, ".+/(.)", "%1")
	libstring = string.lower(libstring)

	if(tcs._LOADED[libstring]) then return true, "ERR_ALREADY_LOADED" end
	local err = nil
	local file = nil
	local load_path
	for path in string.gmatch(tcs.LUA_PATH, "[^;]+") do
		load_path = string.gsub(path, "?", libstring)
		file, err = loadfile(load_path)
		if (err) and (not err:find("No such file or directory", 1, true)) then
			return false, err
		end
		if(file) then break end
	end
	
	if(not file) then return false, err end
	tcs._LOADED[libstring] = true
	return true, file()
end
--[[---------------------------------------------------------------------------LOADING PLUGINS-------------------------------------------------------------------------------]]
local lib_err = {}
local FAILED = false
function load_libs() 
	local libs = {
		"common",
		"cli",
		"alert_machine",
		"auto_nav",
		"central_info",
		"chain_fire",
		"make_friends",
		"multi_aim",
		"vo_clock",
		"misc"
	}
	local res, err
	for _, lib in ipairs(libs) do
		res, err = tcs.require(lib)
		if not res then FAILED = true end
		table.insert(lib_err, err)
	end
end
local psuccess, perr = pcall(load_libs)

if (not psuccess) or FAILED then 
	console_print("\127ffffff------------\n\127ff2020WARNING\127ffffff: TCS has \12740ccffNOT\127ffffff loaded correctly.\n\tIf you didn't cause this on purpose, post the following message to the TCS thread in Community Projects or contact 'Kavec' on irc.slashnet.org:#scuba. If you did, gofix it yourself you butt :|")
	printtable(lib_err)
	if perr and type(perr) ~= "function" then console_print(perr) end
	console_print("------------")
	return
else
	console_print("\127ffffff------------\nTCS loaded successfully!\n------------")
end

--Do some rHUDxscale stuff to setup our HUD plugins
function tcs.e:PLAYER_ENTERED_GAME(e)
	for _,callback_table in ipairs(tcs.e) do
		RegisterEvent(callback_table, "rHUDxscale")
	end
end

function tcs.e:PLAYER_LOGGED_OUT(e) 
	for _,callback_table in ipairs(tcs.e) do
		UnregisterEvent(callback_table,"rHUDxscale")
	end
end
RegisterEvent(tcs.e, "PLAYER_ENTERED_GAME")
RegisterEvent(tcs.e, "PLAYER_LOGGED_OUT")

--Make sure to hide/show dialog for proper hudscale effects to take place
function tcs.e:rHUDxscale(e)
	if(HUD.dlg.visible == "YES") then
		--iup.Refresh(HUD.dlg)
		HideDialog(HUD.dlg)
		ShowDialog(HUD.dlg)
	end
end

function tcs.e:OnEvent(e)
	if (tcs.StringAtStart(e, "TCS_HUD_") and HUD.dlg.visible == "YES") then
		tcs.e.timer = Timer()
		tcs.e.timer:SetTimeout(50, function()
									iup.Refresh(HUD.dlg)
									HideDialog(HUD.dlg)
									ShowDialog(HUD.dlg)
									end)
	end
end

RegisterEvent(tcs.e, "TCS_HUD_CENTRALINFO_SETUP")
RegisterEvent(tcs.e, "TCS_HUD_VOCLOCK_SETUP")
RegisterEvent(tcs.e, "TCS_HUD_MISC_SETUP")

tcs.RegisterHudScaleEvent(tcs.e)

--[[----------------------------------------------------------------------PLUGIN UI STARTS HERE------------------------------------------------------------------------]]
tcs.ui = {}
tcs.ui.configbs = {}
tcs.ui.enableb = {} 	--Table with references to all our stationtoggles that enable or disable plugins

function tcs.SizeAdjustment(configbs)
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
					tcs.SizeAdjustment(tcs.ui.configbs)
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
tcs.ui.version = iup.label{title="v"..tcs.VERSION} 
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
		if value.state_func then
			en = iup.stationtoggle{action=value.state_func,tip="Enable/Disable Plugin",value=value.state_func(en,-1)}
			table.insert(tcs.ui.enableb, en)
		else
			en = iup.fill{size="17"}--iup.stationtoggle{action=function() end,tip="Enable/Disable Plugin",active="NO"}
		end
		local figb = iup.stationbutton{title=key,
								action=function()
									HideDialog(tcs.ui.confdlg)
									if value.dlg and value.dlg.init then
										value.dlg:init()
									end
									ShowDialog(value.dlg, iup.CENTER, iup.CENTER)
								end}
		if value.dlg and value.dlg.init then
			value.dlg:init()
		end
		
		if not value.dlg then figb.active="NO" end
		table.insert(tcs.ui.configbs, figb)
		iup.Append(mainv, iup.hbox{en, figb, iup.label{title=value.shortdesc}, alignment="ACENTER", gap=2 })
		init = true
	end
	
	if not init then
		iup.Append(mainv, iup.hbox{iup.label{title="There are no configuration interfaces registered."}, alignment="ACENTER",gap=2})
	end
	local closebutton = iup.stationbutton{title="Close",action=function() 
								HideDialog(maindlg)
								if not tcs.used_cli then ShowDialog(OptionsDialog,iup.CENTER, iup.CENTER)
								else 
									tcs.used_cli = nil
									local incap = GetCurrentStationType() == 1
									local instation = PlayerInStation()
									if incap then
										ShowDialog()
									elseif instation and not incap then 
										ShowDialog(StationDialog)
									elseif not (instation and incap) then
										ShowDialog(HUD)
									end
								end
							end}
	iup.Append(mainv, iup.hbox{tcs.ui.version,iup.fill{}, closebutton, alignment="ACENTER",gap=2})
	
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

