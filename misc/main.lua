--[[
The Misc module of TCS plugins. Oddball one-off things that aren't 
really useful enough to be solo plugins are placed in here. 
]]
tcs.misc = {}
tcs.misc.subs = {	ls={"ls.state", 1},
						pref={"pref.state",0},
}
--Local standing
tcs.misc.ls_state = gkini.ReadInt("tcs", tcs.misc.subs.ls[1], tcs.misc.subs.ls[2])

tcs.misc.local_standing = {}
function tcs.misc.local_standing:OnEvent(e)
	if not tcs.misc.hudstand then return end
	if GetSectorAlignment()  == 0 then tcs.misc.hudstand.title = "\127555555Unaligned" return end
	local standing = GetPlayerFactionStanding("sector", GetCharacterID())
	local fcolor = "\127"..tcs.RGBToHex(tcs.factionfriendlynesscolor(standing))
	tcs.misc.hudstand.title = fcolor..FactionMonitorStr[GetSectorMonitoredStatus()]
end

function tcs.misc.local_standing.state(_, v)
	if v == 1 then
		iup.Append(HUD.selfinfo, tcs.misc.hudstand_main)
		tcs.misc.hudstand_main:show()
		iup.Refresh(HUD.dlg)
		gkini.WriteInt("tcs", tcs.misc.subs.ls[1], 1)
	elseif v == 0 then
		iup.Detach(tcs.misc.hudstand_main)
		iup.Refresh(HUD.dlg)
		gkini.WriteInt("tcs", tcs.misc.subs.ls[1], 0)
	elseif v == -1 then
		return tcs.IntToToggleState(tcs.misc.ls_state)
	end
end


--[[----------------------------------------------------------------------PLUGIN UI STARTS HERE------------------------------------------------------------------------]]
--Deals with first-run things.
function tcs.misc:OnEvent(e)
	if e == "SHIP_SPAWNED" or e == "rHUDxscale" then
		tcs.misc.hudstand = iup.label { title = "", font=Font.H4*HUD_SCALE, epxand="HORIZONTAL", alignment="ACENTER"}
		tcs.misc.hudstand_main = iup.vbox{iup.hbox{tcs.misc.hudstand; alignment="ACENTER"}}
		iup.Append(HUD.selfinfo, tcs.misc.hudstand_main)
		tcs.misc.local_standing:OnEvent()
	end
	ProcessEvent("TCS_HUD_MISC_SETUP")
	UnregisterEvent(tcs.misc, "SHIP_SPAWNED")
end
if GetCharacterID() and not PlayerInStation() then
	tcs.misc.local_standing:OnEvent()
end


--[[-----------------------------------------Register Event Section-------------------------------------------]]
RegisterEvent(tcs.misc,"SHIP_SPAWNED")
tcs.RegisterHudScaleEvent(tcs.misc)
RegisterEvent(tcs.misc.local_standing,"SHIP_SPAWNED")
RegisterEvent(tcs.misc.local_standing,"CHAT_MSG_SECTORD_SECTOR")
RegisterEvent(tcs.misc.local_standing,"PLAYER_UPDATE_FACTIONSTANDINGS")
