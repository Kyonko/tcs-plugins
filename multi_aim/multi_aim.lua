--This snigulp adds in multiple autoaim reticles, written by Scuba Steve 9.0.
--Many thanks to a1k0n for answering questions about how the leadoff reticle code works.

local plug_name = "MultiAim"
local OLD_IMAGE_DIR = IMAGE_DIR
local IMAGE_DIR = "plugins/tcs-plugins/multi_aim/"
local leadoffsize = gkini.ReadString("tcs", "ma.LeadoffSize", "40x40")
local addonsize = gkini.ReadString("tcs", "ma.AddonSize", "21x21")
local leadoffvisibility = gkini.ReadString("tcs", "ma.LeadoffVisible", "YES")
local addonvisibility = gkini.ReadString("tcs", "ma.AddonVisible", "YES")
tcs.multiaim = {}
tcs.multiaim.state = gkini.ReadInt("tcs", "ma.state", 0)
tcs.multiaim.images = { 
	iup.LoadImage("hud_target1.png"),
	iup.LoadImage("hud_target_over1.png"),
	iup.LoadImage("hud_target2.png"),
	iup.LoadImage("hud_target_over2.png"),
	iup.LoadImage("hud_target3.png"),
	iup.LoadImage("hud_target_over3.png"),
	iup.LoadImage("hud_target4.png"),
	iup.LoadImage("hud_target_over4.png"),
	iup.LoadImage("hud_target5.png"),
	iup.LoadImage("hud_target_over5.png")
}
local function GenerateLeadoffIcon(portid)
	local leadoff =  iup.radar {
						type = "LEADOFF", 
						image = IMAGE_DIR .. "hud_target"..(portid - 1)..".png",
						imageover = IMAGE_DIR .. "hud_target_over"..(portid - 1)..".png", 
						size = leadoffsize, 
						bgcolor = "255 255 255 255 &", 
						expand = "NO", 
						active = "NO",
						portid = portid,
						visible = string.upper(leadoffvisibility)
					}
	--local addon = iup.button { title = "", image = GetInventoryItemIcon(GetActiveShipItemIDAtPort(portid)), size = "24x24", bgcolor = "255 255 255 255 &", visible = "YES"}
	local addon = iup.radar {
						type = "LEADOFF",
						image = GetInventoryItemIcon(GetActiveShipItemIDAtPort(portid)) or "images/icon_s_rocket.png",
						imageover = GetInventoryItemIcon(GetActiveShipItemIDAtPort(portid)) or "images/icon_s_rocket.png",
						size = addonsize,
						bgcolor = "255 255 255 255 &",
						expand = "NO",
						active = "NO",
						portid = portid,
						visible = string.upper(addonvisibility),

					}
	local icon = iup.hbox {
					iup.hbox {
						addon,
						iup.fill {}
					},
					leadoff,
					iup.fill{}
				}
	return icon, leadoff, addon
end	


tcs.multiaim.leads = {}
local xres = gkinterface.GetXResolution()*HUD_SCALE
local iconsize = math.floor(xres*.04)
							
function tcs.multiaim.CreateLeadoffArrows()
	
	tcs.leadoff_arrow = iup.radar {
							type = "LEADOFF",
							image = OLD_IMAGE_DIR .. "hud_target.png",
							imageover = OLD_IMAGE_DIR .. "hud_target_over.png",
							size = iconsize,
							bgcolor = "255 255 255 255 &",
							expand = "NO",
							active = "NO",
						}

						--VO updates the leadoff arrow to some dumb value when things happen. So we'll replace it
	tcs.leadofflayer = iup.hbox { 
							tcs.leadoff_arrow,
							iup.fill{}
						}
	if(not GetActiveShipNumAddonPorts()) then return end
	local ren = iup.GetParent(HUD.leadofflayer)
	HUD.leadofflayer.visible = "NO"
	local paren = iup.hbox {tcs.leadofflayer}
	iup.Append(ren, paren) 
	
	--iup.Append(paren, tcs.leadoff_arrow)
	for i = 2, 6 do
		tcs.multiaim.leads[i] = {}
		tcs.multiaim.leads[i].icon, tcs.multiaim.leads[i].leadoff, tcs.multiaim.leads[i].addon = GenerateLeadoffIcon(i)
		iup.Append(paren, tcs.multiaim.leads[i].icon) --ffs Ray
		tcs.multiaim.leads[i].icon.visible = "YES"
	end
	iup.Detach(HUD.leadoff_arrow)
	--tcs.leadoff_arrow = iup.hbox { HUD.leadoff_arrow }
	iup.Destroy(HUD.leadoff_arrow)
	HUD.leadoff_arrow = iup.label { title = "" }
	iup.Append(HUD.leadofflayer, HUD.leadoff_arrow)
	--iup.Append(tcs.leadoff_arrow, iup.fill{})
	--iup.Append(paren, tcs.leadoff_arrow)

	return
end

function tcs.multiaim.UpdateLeadoffArrowVisibility()
	local first = false
	HUD.leadofflayer.visible = "NO"
	for portid in pairs(tcs.multiaim.leads) do
		if((not GetActiveShipItemIDAtPort(portid)) or (tcs.multiaim.state == 0)) then
			tcs.multiaim.leads[portid].icon.visible = "NO"
			if(GetActiveShipItemIDAtPort(portid) and not first) then
				tcs.leadoff_arrow.portid = portid
				first = true
			end
		else
			tcs.multiaim.leads[portid].icon.visible = "YES"
		end
	end
	if(tcs.multiaim.state == 1 or not first) then 
		tcs.leadofflayer.visible = "NO"
	else
		tcs.leadofflayer.visible = "YES"
	end
end

function tcs.multiaim.UpdateLeadoffIcons()
	for portid in pairs(tcs.multiaim.leads) do
		if(GetActiveShipItemIDAtPort(portid)) then
			tcs.multiaim.leads[portid].addon.image = GetInventoryItemIcon(GetActiveShipItemIDAtPort(portid))
			tcs.multiaim.leads[portid].addon.imageover = GetInventoryItemIcon(GetActiveShipItemIDAtPort(portid))
		end
	end
end

function tcs.multiaim:OnEvent(event, data)
	if(event == "SHIP_SPAWNED") then
		if(not tcs.multiaim.loaded) then
			tcs.multiaim.CreateLeadoffArrows()
			tcs.multiaim.loaded = true
		end
		tcs.multiaim.UpdateLeadoffArrowVisibility()
	elseif(event == "LEAVING_STATION") then
		tcs.multiaim.UpdateLeadoffIcons()
	elseif(event == "rHUDxscale") then
		tcs.multiaim.CreateLeadoffArrows()
		tcs.multiaim.UpdateLeadoffArrowVisibility()
	end
end

RegisterEvent(tcs.multiaim, "SHIP_SPAWNED")
RegisterEvent(tcs.multiaim, "LEAVING_STATION")
tcs.RegisterHudScaleEvent(tcs.multiaim)
if(GetCharacterID()) then
	tcs.multiaim.CreateLeadoffArrows()
	tcs.multiaim.UpdateLeadoffArrowVisibility()
	tcs.multiaim.loaded = true
end


--[[-----------------------------------------Configuration Interface-------------------------------------------]]

local showleadoff = iup.stationtoggle{value=leadoffvisibility}
local showaddon = iup.stationtoggle{value=addonvisibility}
local leadoff_size = iup.text{value = leadoffsize, size = "80x"}
local addon_size = iup.text{value = addonsize, size = "80x"}

local function OpenHelp()
	StationHelpDialog:Open(
	[[This interface allows you to adjust the behavior of MultiAim. See below for a description of each option
	
		'Reticle Visible' and 'Addion Visible' checkboxes let you specify how MultiAim's leadoff indicator is displayed. With the first checked, the leadoff will be the included reticles only; checking the second will have the leadoff be marked with the addon it is associated with. Check both options to show the default reticle AND the addon image.
		
		The two options specify sizes of the reticle and leadoff bits. Default is '40x40' for the reticle and '21x21' for the addon icon.]])
		
end

local closeb = iup.stationbutton{title="OK", action=function()
											HideDialog(tcs.multiaim.confdlg)
											gkini.WriteString("tcs", "ma.LeadoffSize", leadoff_size.value)
											gkini.WriteString("tcs", "ma.AddonSize", addon_size.value)
											gkini.WriteString("tcs", "ma.LeadoffVisible", showleadoff.value)
											gkini.WriteString("tcs", "ma.AddonVisible", showaddon.value)
											if(GetCharacterID()) then
												for i = 2, 6 do
													tcs.multiaim.leads[i].leadoff.size = leadoff_size.value
													tcs.multiaim.leads[i].addon.size = addon_size.value
													tcs.multiaim.leads[i].leadoff.visible = showleadoff.value
													tcs.multiaim.leads[i].addon.visible = showaddon.value
													iup.Refresh(tcs.multiaim.leads[i].icon)
												end
											end
											--init()
											tcs.cli_menu_adjust(plug_name)
										end}
local cancelb = iup.stationbutton{title="Cancel", action=function()
											HideDialog(tcs.multiaim.confdlg)
											tcs.cli_menu_adjust(plug_name)
										end}

local helpclose = iup.hbox{iup.stationbutton{title="Help", hotkey=iup.K_h, action=function() OpenHelp() end}, iup.fill{}, closeb, cancelb}

local mainv = {
	iup.hbox{showleadoff, iup.label{title="Use reticles in leadoff display"}},
	iup.hbox{showaddon, iup.label{title="Use addons in leadoff display"}},
	iup.hbox{iup.label{title="Reticle Size:"},iup.fill{},leadoff_size},
	iup.hbox{iup.label{title="Addon Size:"},iup.fill{},addon_size},
	iup.fill{},
	helpclose
}

tcs.multiaim.confdlg = tcs.ConfigConstructor("MultiAim Config", mainv, {defaultesc = cancelb})
--[[
function tcs.multiaim.confdlg:init()
	showaddon.value = addonvisiblity
	showleadoff.value = leadoffvisibility
	leadoff_size.value = leadoffsize
	addon_size.value = addonsize
end
]]
local cli_cmd = { cmd = "multiaim", interp = function (input) ma_cli(nil, input) end}

tcs.ProvideConfig(plug_name, tcs.multiaim.confdlg, "Creates separate autoaim reticules for different weapon types", cli_cmd, function(_,v) 
																																if v == 1 then
																																	tcs.multiaim.state = 1
																																	gkini.WriteInt("tcs", "ma.state", 1)
																																elseif v == 0 then
																																	tcs.multiaim.state = 0
																																	gkini.WriteInt("tcs", "ma.state", 0)
																																elseif v == -1 then
																																	return tcs.IntToToggleState(tcs.multiaim.state)
																																end
																																tcs.multiaim.UpdateLeadoffArrowVisibility()
																															end)

																															
function ma_cli (_, data)
	if(not data) then
		print("\127ffffffUsage:\
				\t/tcs multiaim iconsize leadoff [x]: set the reticle size to x\
				\t/tcs multiaim iconsize addon [x]: set the addon picture size to x\
				\t/tcs multiaim visible leadoff [yes|no]: make the reticles visible or invisible\
				\t/tcs multiaim visible addon [yes|no]: make the addon pictures visible or invisible")
	elseif(data[1] and data[1] == "iconsize") then
		if(data[2] and data[2] == "leadoff") then
			if(data[3]) then
				for i = 2, 6 do
					tcs.multiaim.leads[i].leadoff.size = data[3]
					iup.Refresh(tcs.multiaim.leads[i].icon)
				end
				gkini.WriteString("tcs", "ma.LeadoffSize", data[3])
				leadoff_size.value = data[3]
			end
		end
		if(data[2] and data[2] == "addon") then
			if(data[3]) then
				for i = 2, 6 do
					tcs.multiaim.leads[i].addon.size = data[3]
					iup.Refresh(tcs.multiaim.leads[i].icon)
				end
				gkini.WriteString("tcs", "ma.AddonSize", data[3])
				addonsize.value = data[3]
			end
		end
	elseif(data[1] and data[1] == "visible") then
		if(data[2] and data[2] == "leadoff") then
			if(data[3]) then
				showleadoff.value = (string.upper(data[3]) == "YES" and "YES") or "NO"
				gkini.WriteString("tcs", "ma.LeadoffVisible", showleadoff.value)
				for i = 2, 6 do
					tcs.multiaim.leads[i].leadoff.visible = showleadoff.value
				end
				
				
			end
		end
		if(data[2] and data[2] == "addon") then
			if(data[3]) then
				showaddon.value = (string.upper(data[3]) == "YES" and "YES") or "NO"
				gkini.WriteString("tcs", "ma.AddonVisible", showaddon.value)
				for i = 2, 6 do
					tcs.multiaim.leads[i].addon.visible = showaddon.value
				end
				
			end
		end
	end
end
--Keep this around for compatability's sake
RegisterUserCommand("multiaim", ma_cli)
