--This snigulp adds in multiple autoaim reticles, written by Scuba Steve 9.0.
--Many thanks to a1k0n for answering questions about how the leadoff reticle code works.

local IMAGE_DIR = "plugins/MultiAim/"
local leadoffsize = gkini.ReadString("MultiAim", "LeadoffSize", "40x40")
local addonsize = gkini.ReadString("MultiAim", "AddonSize", "21x21")
local leadoffvisibility = gkini.ReadString("MultiAim", "LeadoffVisible", "YES")
local addonvisibility = gkini.ReadString("MultiAim", "AddonVisible", "YES")
tcs.multiaim = {}
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
function tcs.multiaim.CreateLeadoffArrows()
	if(not GetActiveShipNumAddonPorts()) then return end
	for i = 2, 6 do
		tcs.multiaim.leads[i] = {}
		tcs.multiaim.leads[i].icon, tcs.multiaim.leads[i].leadoff, tcs.multiaim.leads[i].addon = GenerateLeadoffIcon(i)
		iup.Append(iup.GetParent(HUD.leadoff_arrow), tcs.multiaim.leads[i].icon) --ffs Ray
		tcs.multiaim.leads[i].icon.visible = "YES"
	end
	local paren = iup.GetParent(HUD.leadoff_arrow)
	iup.Detach(HUD.leadoff_arrow)
	iup.Destroy(HUD.leadoff_arrow)
	HUD.leadoff_arrow = iup.label{title = ""}
	iup.Append(paren, HUD.leadoff_arrow)
	return
end

function tcs.multiaim.UpdateLeadoffArrowVisibility()
	for portid in pairs(tcs.multiaim.leads) do
		if(not GetActiveShipItemIDAtPort(portid)) then
			tcs.multiaim.leads[portid].icon.visible = "NO"
		else
			tcs.multiaim.leads[portid].icon.visible = "YES"
		end
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
	end
	if(event == "LEAVING_STATION") then
		tcs.multiaim.UpdateLeadoffIcons()
	end
end

RegisterEvent(tcs.multiaim, "SHIP_SPAWNED")
RegisterEvent(tcs.multiaim, "LEAVING_STATION")
if(GetCharacterID()) then
	tcs.multiaim.CreateLeadoffArrows()
	tcs.multiaim.UpdateLeadoffArrowVisibility()
	tcs.multiaim.loaded = true
end

tcs.ProvideConfig("MultiAim", nil, "Creates separate autoaim reticules for different weapon types")

RegisterUserCommand("multiaim", function(_, data)
									if(not data) then
										print("\127ffffffUsage:\
												\t/multiaim iconsize leadoff [x]: set the reticle size to x\
												\t/multiaim iconsize addon [x]: set the addon picture size to x\
												\t/multiaim visible leadoff [yes|no]: make the reticles visible or invisible\
												\t/multiaim visible addon [yes|no]: make the addon pictures visible or invisible")
									elseif(data[1] and data[1] == "iconsize") then
										if(data[2] and data[2] == "leadoff") then
											if(data[3]) then
												for i = 2, 6 do
													tcs.multiaim.leads[i].leadoff.size = data[3]
													iup.Refresh(tcs.multiaim.leads[i].icon)
												end
												gkini.WriteString("MultiAim", "LeadoffSize", data[3])
											end
										end
										if(data[2] and data[2] == "addon") then
											if(data[3]) then
												for i = 2, 6 do
													tcs.multiaim.leads[i].addon.size = data[3]
													iup.Refresh(tcs.multiaim.leads[i].icon)
												end
												gkini.WriteString("MultiAim", "AddonSize", data[3])
											end
										end
									elseif(data[1] and data[1] == "visible") then
										if(data[2] and data[2] == "leadoff") then
											if(data[3]) then
												for i = 2, 6 do
													tcs.multiaim.leads[i].leadoff.visible = string.upper(data[3])
												end
												gkini.WriteString("MultiAim", "LeadoffVisible", data[3])
											end
										end
										if(data[2] and data[2] == "addon") then
											if(data[3]) then
												for i = 2, 6 do
													tcs.multiaim.leads[i].addon.visible = string.upper(data[3])
												end
												gkini.WriteString("MultiAim", "AddonVisible", data[3])
											end
										end
									end
								end)
