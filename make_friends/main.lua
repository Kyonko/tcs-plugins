--TCS Plugins MakeFriends module

tcs.mf = {}
tcs.mf.LastAggro = {}
tcs.mf.state = gkini.ReadInt("MakeFriends", "Enabled", 0)
tcs.mf.echocolor = gkini.ReadString("MakeFriends", "color", "ff4300")
tcs.require("make_friends_ui")

-- This file contains everything specific to MakeFriends, that isn't very useful in any other situation
--Table init
tcs.mf.FS = { Guild = false, Group = false, NPC = false, Buddy = false,  StatG = false, SF = false, igEnemy = false, igFriend = false, igEnemyGuild = false, igFriendGuild = false, FlagHostile = false, ConsiderStanding = false}
tcs.mf.factions = {}
tcs.mf.factions[12] = false --"Ineubis Defense Research"
tcs.mf.factions[6] = false --"Valent Robotics"
tcs.mf.factions[99] = true --"Developers"
tcs.mf.factions[1] = false --"Itani Nation"
tcs.mf.factions[3] = false --"Union of Independent Territories"
tcs.mf.factions[7] = false --"Orion Heavy Manufacturing"
tcs.mf.factions[2] = false --"Serco Dominion"
tcs.mf.factions[8] = false --"Axia Technology Corp"
tcs.mf.factions[4] =  false--"TPG Corporation"
tcs.mf.factions[9] = false --"Corvus Prime"
tcs.mf.factions[0] = false --"Unaligned"
tcs.mf.factions[10] = false --"Tunguska Heavy Mining Concern"
tcs.mf.factions[5] = false --"BioCom Industries"
tcs.mf.factions[11] = false --"Aeolus Trading Prefectorate"
tcs.mf.factions[13] = false --"Xang Xi Automated Systems"
tcs.mf.friendslist = {}
tcs.mf.enemylist = {}
tcs.mf.friendguildlist = {}
tcs.mf.enemyguildlist = {}
tcs.mf.presets = {}

--LastAggro crap
tcs.mf.LastAggro.timeout = 300
--Functional functions
tcs.mf.GetFriendlyStatus_OLD = GetFriendlyStatus
function tcs.mf.GetFriendlyStatus(charid)
	if((tcs.mf.FS["FlagHostile"] == true) and tcs.mf.LastAggro[charid]) then
		if(tcs.mf.LastAggro[charid]["lasthit"] > (os.time() - tcs.mf.LastAggro.timeout)) then 
			return 0 
		end
	end
	if((tcs.mf.FS["igEnemy"] == false) and tcs.IsStringInTable(tcs.mf.enemylist, GetPlayerName(charid))) then
		return 0
	elseif((tcs.mf.FS["igFriend"] == false) and tcs.IsStringInTable(tcs.mf.friendslist, GetPlayerName(charid))) then
		return 3
	elseif((tcs.mf.FS["igEnemyGuild"] == false) and tcs.IsStringInTable(tcs.mf.enemyguildlist, GetGuildTag(charid))) then
		return 0
	elseif((tcs.mf.FS["igFriendGuild"] == false) and tcs.IsStringInTable(tcs.mf.friendguildlist, GetGuildTag(charid))) then
		return 3
	elseif((tcs.mf.FS["Guild"] and IsGuildMember(charid)) == true) then
		return 3
	elseif((tcs.mf.FS["Group"] and IsGroupMember(charid)) == true) then
		return 3
	elseif((tcs.mf.FS["Buddy"] and tcs.IsBuddy(charid)) == true) then
		return 3
	elseif(tcs.mf.FS["NPC"] and (tcs.StringAtStart(GetPlayerName(charid), "*") == true)) then
		if(tcs.mf.FS["StatG"] and ((tcs.StringAtStart(GetPlayerName(charid), "*Statio") == true)or (tcs.StringAtStart(GetPlayerName(charid), "*Marsha") == true))) then return 0 end
		if(tcs.mf.FS["SF"] and ((tcs.StringAtStart(GetPlayerName(charid), "*Stri") == true)or (tcs.StringAtStart(GetPlayerName(charid), "*Aerna Se") == true))) then return 0 end
		return 3
	else
		if(tcs.mf.factions[GetPlayerFaction(charid)] == true) then
			return 3
		end
		if(tcs.mf.FS["ConsiderStanding"] == true) then
			local theirfaction = GetPlayerFaction(charid) or 0
  			local myfaction = GetPlayerFaction() or 0
  			if (theirfaction == 0) or (myfaction == 0) then return 0 end

  			local val = 0
  			if (GetPlayerFactionStanding(myfaction, charid) or FactionStanding.Neutral) > FactionStanding.Hate then val = val + 1 end
  			if (GetPlayerFactionStanding(theirfaction) or FactionStanding.Neutral) > FactionStanding.Hate then val = val + 1 end
  			if (GetPlayerFactionStanding("sector", charid) or FactionStanding.Neutral) > FactionStanding.Hate then val = val + 1 end
  			return val
		end
		return 0
	end
end
if tcs.mf.state == 1 then 
	GetFriendlyStatus = tcs.mf.GetFriendlyStatus
end

tcs.ProvideConfig("MakeFriends", tcs.mf.ui.dlg, "Customizes how players are displayed on radar.", function(_,s)
																			if s == 1 then
																				GetFriendlyStatus = tcs.mf.GetFriendlyStatus
																				tcs.mf.state = 1
																				tcs.mf.state = gkini.WriteInt("MakeFriends", "Enabled", 1)
																			elseif s == 0 then
																				GetFriendlyStatus = tcs.mf.GetFriendlyStatus_OLD
																				tcs.mf.state = 1
																				tcs.mf.state = gkini.WriteInt("MakeFriends", "Enabled", 0)
																			elseif s == -1 then
																				return tcs.IntToToggleState(tcs.mf.state)
																			end
																		end)


function tcs.mf.LoadSettings(preset)
	preset = strip_whitespace(preset)
	tcs.mf.factions[2] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Serco", "OFF")) 
	tcs.mf.factions[1] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Itani", "OFF")) 
	tcs.mf.factions[3] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "UIT", "OFF")) 
	tcs.mf.factions[11] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Aeolus", "OFF")) 
	tcs.mf.factions[12] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Ineubis", "OFF")) 
	tcs.mf.factions[6] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Valent", "OFF")) 
	tcs.mf.factions[8] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Axia", "OFF")) 
	tcs.mf.factions[5] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Biocom", "OFF"))
	tcs.mf.factions[4] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "TPG", "OFF")) 
	tcs.mf.factions[7] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Orion", "OFF"))
	tcs.mf.factions[9] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Corvus", "OFF")) 
	tcs.mf.factions[0] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Unaligned", "OFF")) 
	tcs.mf.factions[10] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Tunguska", "OFF"))
	tcs.mf.factions[13] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "XangXi", "OFF")) 
	tcs.mf.FS["Group"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Group", "ON"))
	tcs.mf.FS["Guild"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Guild", "ON"))
	tcs.mf.FS["Buddy"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Buddies", "ON"))
	tcs.mf.FS["NPC"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "NPCs", "ON"))
	tcs.mf.FS["StatG"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "StatG", "OFF"))
	tcs.mf.FS["SF"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "SF", "OFF"))
	tcs.mf.FS["igEnemy"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igEnemy", "OFF"))
	tcs.mf.FS["igFriend"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igFriend", "OFF"))
	tcs.mf.FS["igEnemyGuild"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igEnemyGuild", "OFF"))
	tcs.mf.FS["igFriendGuild"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igFriendGuild", "OFF"))
	tcs.mf.FS["FlagHostile"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "FlagHostiles", "ON"))
 	tcs.mf.LastAggro.timeout = gkini.ReadInt("MakeFriends_"..preset, "HostileTimeout", 300)
	tcs.mf.FS["ConsiderStanding"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "ConsiderStanding", "OFF"))
end

--Let's go the easy way and make tcs.MF compatible with MakeFriends settings. So much easier for me.
function tcs.mf.SaveSettings(preset)
	if(preset == nil) then
		return
	end
	preset = strip_whitespace(preset)
	gkini.WriteString("MakeFriends_"..preset, "Serco", iup.GetAttribute(tcs.mf.ui.serco, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Itani", iup.GetAttribute(tcs.mf.ui.itani, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "UIT", iup.GetAttribute(tcs.mf.ui.uit, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Aeolus", iup.GetAttribute(tcs.mf.ui.aeolus, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Ineubis", iup.GetAttribute(tcs.mf.ui.ineubis, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Valent", iup.GetAttribute(tcs.mf.ui.valent, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Axia", iup.GetAttribute(tcs.mf.ui.axia, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Biocom", iup.GetAttribute(tcs.mf.ui.biocom, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "TPG", iup.GetAttribute(tcs.mf.ui.tpg, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Orion", iup.GetAttribute(tcs.mf.ui.orion, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "Corvus", iup.GetAttribute(tcs.mf.ui.corvus, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Unaligned", iup.GetAttribute(tcs.mf.ui.unaligned, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Tunguska", iup.GetAttribute(tcs.mf.ui.tunguska, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "XangXi", iup.GetAttribute(tcs.mf.ui.xangxi, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Group", iup.GetAttribute(tcs.mf.ui.group, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "Guild", iup.GetAttribute(tcs.mf.ui.guild, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "Buddies", iup.GetAttribute(tcs.mf.ui.buddies, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "NPCs", iup.GetAttribute(tcs.mf.ui.NPC, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "StatG", iup.GetAttribute(tcs.mf.ui.statg, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "SF", iup.GetAttribute(tcs.mf.ui.sf, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igEnemy", iup.GetAttribute(tcs.mf.ui.igenemy, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igFriend", iup.GetAttribute(tcs.mf.ui.igfriend, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igEnemyGuild", iup.GetAttribute(tcs.mf.ui.igenemyguild, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igFriendGuild", iup.GetAttribute(tcs.mf.ui.igfriendguild, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "FlagHostiles", iup.GetAttribute(tcs.mf.ui.flaghostile, "VALUE"))
	gkini.WriteInt("MakeFriends_"..preset, "HostileTimeout", iup.GetAttribute(tcs.mf.ui.flaghostiletext, "VALUE") * 60)
	gkini.WriteString("MakeFriends_"..preset, "ConsiderStanding", iup.GetAttribute(tcs.mf.ui.considerstanding, "VALUE"))
end

function tcs.mf.LoadLists()
		tcs.mf.friendslist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "Friends", ""))
		tcs.mf.enemylist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "Enemies", ""))
		tcs.mf.friendguildlist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "FriendGuilds", ""))
		tcs.mf.enemyguildlist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "EnemyGuilds", ""))
end
function tcs.mf.SaveLists()
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Friends", spickle(tcs.mf.friendslist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Enemies", spickle(tcs.mf.enemylist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "FriendGuilds", spickle(tcs.mf.friendguildlist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "EnemyGuilds", spickle(tcs.mf.enemyguildlist))
end	
function tcs.mf.LoadPresets()
	tcs.mf.presets = unspickle(gkini.ReadString("MakeFriends", "Presets", ""))
end
function tcs.mf.SavePresets()
	gkini.WriteString("MakeFriends", "Presets", spickle(tcs.mf.presets))
end

--Load settings in config.ini 
tcs.mf.OnCharacterSelect = {}
function tcs.mf.OnCharacterSelect:OnEvent()
	tcs.mf.LoadLists()
	tcs.mf.LoadPresets()
	tcs.mf.curpreset = gkini.ReadString("MakeFriends-"..GetPlayerName(), "CurrentPreset", "Default")
	tcs.mf.LoadSettings(tcs.mf.curpreset)
end
RegisterEvent(tcs.mf.OnCharacterSelect, "PLAYER_ENTERED_GAME")
if(GetPlayerName() ~= nil) then
	tcs.mf.LoadLists()
	tcs.mf.LoadPresets()
	tcs.mf.curpreset = gkini.ReadString("MakeFriends-"..GetPlayerName(), "CurrentPreset", "Default")
	tcs.mf.LoadSettings(tcs.mf.curpreset)
end


--Toggle color function.
function tcs.mf.GetFriends()
	if(tcs.mf.FS["StatG"] == true) then 
		iup.SetAttributes(tcs.mf.ui.statg, "VALUE=ON,FGCOLOR=\"255 0 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.statg, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["SF"] == true) then 
		iup.SetAttributes(tcs.mf.ui.sf, "VALUE=ON,FGCOLOR=\"255 0 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.sf, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["igEnemy"] == true) then 
		iup.SetAttributes(tcs.mf.ui.igenemy, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(tcs.mf.ui.igenemy, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["igFriend"] == true) then 
		iup.SetAttributes(tcs.mf.ui.igfriend, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(tcs.mf.ui.igfriend, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["igEnemyGuild"] == true) then 
		iup.SetAttributes(tcs.mf.ui.igenemyguild, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(tcs.mf.ui.igenemyguild, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["igFriendGuild"] == true) then 
		iup.SetAttributes(tcs.mf.ui.igfriendguild, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(tcs.mf.ui.igfriendguild, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["FlagHostile"] == true) then 
		iup.SetAttributes(tcs.mf.ui.flaghostile, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(tcs.mf.ui.flaghostile, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	if(tcs.mf.FS["ConsiderStanding"] == true) then 
		iup.SetAttributes(tcs.mf.ui.considerstanding, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(tcs.mf.ui.considerstanding, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
	tcs.mf.ui.flaghostiletext.value = tcs.mf.LastAggro.timeout / 60
	if(tcs.mf.factions[0] == true) then 
		iup.SetAttributes(tcs.mf.ui.unaligned, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.unaligned, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[1] == true) then
		iup.SetAttributes(tcs.mf.ui.itani, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.itani, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[2] == true) then
		iup.SetAttributes(tcs.mf.ui.serco, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.serco, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[3] == true) then
		iup.SetAttributes(tcs.mf.ui.uit, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.uit, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[4] == true) then
		iup.SetAttributes(tcs.mf.ui.tpg, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.tpg, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[5] == true) then
		iup.SetAttributes(tcs.mf.ui.biocom, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.biocom, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[6] == true) then
		iup.SetAttributes(tcs.mf.ui.valent, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.valent, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[7] == true) then
		iup.SetAttributes(tcs.mf.ui.orion, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.orion, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[8] == true) then
		iup.SetAttributes(tcs.mf.ui.axia, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.axia, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[9] == true) then
		iup.SetAttributes(tcs.mf.ui.corvus, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.corvus, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[10] == true) then
		iup.SetAttributes(tcs.mf.ui.tunguska, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.tunguska, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[11] == true) then
		iup.SetAttributes(tcs.mf.ui.aeolus, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.aeolus, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[12] == true) then
		iup.SetAttributes(tcs.mf.ui.ineubis, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.ineubis, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.factions[13] == true) then
		iup.SetAttributes(tcs.mf.ui.xangxi, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.xangxi, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.FS["Guild"] == true) then
		iup.SetAttributes(tcs.mf.ui.guild, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.guild, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.FS["Group"] == true) then
		iup.SetAttributes(tcs.mf.ui.group, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.group, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.FS["Buddy"] == true) then
		iup.SetAttributes(tcs.mf.ui.buddies, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.buddies, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
	if(tcs.mf.FS["NPC"] == true) then
		iup.SetAttributes(tcs.mf.ui.NPC, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(tcs.mf.ui.NPC, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
end

function tcs.mf.LastAggro:OnEvent(event, victim, aggressor)
	victim = victim or GetCharacterID() or 1
	aggressor = aggressor or GetCharacterIDByName(GetTargetInfo()) or 1
	if(victim == GetCharacterID()) then
		if(not tcs.mf.LastAggro[aggressor]) then
			tcs.mf.LastAggro[aggressor] = { lasthit = os.time() }
		else
			tcs.mf.LastAggro[aggressor]["lasthit"] = os.time()
		end
	end
	--Why is this commented? Investigate later.
	--[[if(aggressor == GetCharacterID()) then
		if(not tcs.mf.LastAggro[victim]) then
			tcs.mf.LastAggro[victim] = { lasthit = os.time() }
		else
			tcs.mf.LastAggro[victim]["lasthit"] = os.time()
		end
	end ]]

end
RegisterEvent(tcs.mf.LastAggro, "PLAYER_GOT_HIT")
RegisterEvent(tcs.mf.LastAggro, "PLAYER_HIT")

