--TCS Plugins MakeFriends module

tcs.mf = {}
tcs.mf.name = "MakeFriends"
local mf = tcs.mf
mf.enemymap = {}
mf.friendmap = {}
mf.enemyguildmap = {}
mf.friendguildmap = {}

mf.LastAggro = {}
mf.state = gkini.ReadInt("MakeFriends", "Enabled", 0)
mf.echocolor = gkini.ReadString("MakeFriends", "color", "ff4300")
tcs.require("make_friends_ui")

-- This file contains everything specific to MakeFriends, that isn't very useful in any other situation
--Table init
mf.FS = { Guild = false, Group = false, NPC = false, Buddy = false,  StatG = false, SF = false, igEnemy = false, igFriend = false, igEnemyGuild = false, igFriendGuild = false, FlagHostile = false, ConsiderStanding = false}
local FS = mf.FS

mf.factions = {}
mf.factions[12] = false --"Ineubis Defense Research"
mf.factions[6] = false --"Valent Robotics"
mf.factions[99] = true --"Developers"
mf.factions[1] = false --"Itani Nation"
mf.factions[3] = false --"Union of Independent Territories"
mf.factions[7] = false --"Orion Heavy Manufacturing"
mf.factions[2] = false --"Serco Dominion"
mf.factions[8] = false --"Axia Technology Corp"
mf.factions[4] =  false--"TPG Corporation"
mf.factions[9] = false --"Corvus Prime"
mf.factions[0] = false --"Unaligned"
mf.factions[10] = false --"Tunguska Heavy Mining Concern"
mf.factions[5] = false --"BioCom Industries"
mf.factions[11] = false --"Aeolus Trading Prefectorate"
mf.factions[13] = false --"Xang Xi Automated Systems"
mf.friendslist = {}
mf.enemylist = {}
mf.friendguildlist = {}
mf.enemyguildlist = {}
mf.presets = {}

--LastAggro crap
mf.LastAggro.timeout = 300
--Functional functions
mf.GetFriendlyStatus_OLD = GetFriendlyStatus
local tSaS = tcs.StringAtStart
function mf.GetFriendlyStatus(charid)
	local name = string.lower(GetPlayerName(charid))
	local NPC = tSaS(name, "*")
	local guild_tag = string.lower(GetGuildTag(charid))
	if((FS["FlagHostile"] == true) and mf.LastAggro[charid]) then
		if(mf.LastAggro[charid]["lasthit"] > (os.time() - mf.LastAggro.timeout)) then 
			return 0 
		end
	end
	if((not FS["igEnemy"]) and mf.enemymap[name]) then
		return 0
	elseif((not FS["igFriend"]) and mf.friendmap[name]) then
		return 3
	elseif((not FS["igEnemyGuild"]) and mf.enemyguildmap[guild_tag]) then
		return 0
	elseif((not FS["igFriendGuild"]) and mf.friendguildmap[guild_tag]) then
		return 3
	elseif(FS["Guild"] and IsGuildMember(charid)) then
		return 3
	elseif(FS["Group"] and IsGroupMember(charid)) then
		return 3
	elseif(FS["Buddy"] and tcs.IsBuddy(charid)) then
		return 3

		--IMPLEMENT HIVE LOGIC, YO
	--elseif(NPC and HIVE_CHECK()) then 
	--	return (FS["Hive"] and 3) or 0

	elseif(NPC and (FS["StatG"] ~= -1) and tSaS(name, "*statio") or tSaS(name, "*marsha")) then 
		return (FS["StatG"] and 3) or 0 
	elseif(NPC and (FS["SF"] ~= -1) and tSaS(name, "*stri") or tSaS(name, "*aerna se")) then 
		return (FS["SF"] and 3) or 0 

	--Check if player chose to force Conquerable assets here to red or green
	elseif(NPC and (FS["Conq"] ~= -1) and tSaS(name, "*conqu") and FS["Conq_like_npc"]) then 
		return (FS["Conq"] and 3) or 0 

	--Okay, must be something else if we haven't caught it yet
	elseif(NPC and (FS["norm"] ~= 1)) 
		return (FS["norm"] and 3) or 0
	else
		if(NPC and tSaS(name, "*conqu")) then
			--Check key for conquerable station friendly status here
			--return CONQ_FRIENDLY_STATUS
		end
		if(mf.factions[GetPlayerFaction(charid)]) then
			return 3
		end
		if(FS["ConsiderStanding"]) then
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
if mf.state == 1 then 
	GetFriendlyStatus = mf.GetFriendlyStatus
end



function mf.LoadSettings(preset)
	preset = strip_whitespace(preset)
	mf.factions[2] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Serco", "OFF")) 
	mf.factions[1] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Itani", "OFF")) 
	mf.factions[3] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "UIT", "OFF")) 
	mf.factions[11] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Aeolus", "OFF")) 
	mf.factions[12] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Ineubis", "OFF")) 
	mf.factions[6] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Valent", "OFF")) 
	mf.factions[8] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Axia", "OFF")) 
	mf.factions[5] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Biocom", "OFF"))
	mf.factions[4] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "TPG", "OFF")) 
	mf.factions[7] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Orion", "OFF"))
	mf.factions[9] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Corvus", "OFF")) 
	mf.factions[0] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Unaligned", "OFF")) 
	mf.factions[10] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Tunguska", "OFF"))
	mf.factions[13] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "XangXi", "OFF")) 
	FS["Group"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Group", "ON"))
	FS["Guild"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Guild", "ON"))
	FS["Buddy"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "Buddies", "ON"))
	FS["NPC"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "NPCs", "ON"))
	FS["StatG"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "StatG", "OFF"))
	FS["SF"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "SF", "OFF"))
	FS["igEnemy"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igEnemy", "OFF"))
	FS["igFriend"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igFriend", "OFF"))
	FS["igEnemyGuild"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igEnemyGuild", "OFF"))
	FS["igFriendGuild"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "igFriendGuild", "OFF"))
	FS["FlagHostile"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "FlagHostiles", "ON"))
 	mf.LastAggro.timeout = gkini.ReadInt("MakeFriends_"..preset, "HostileTimeout", 300)
	FS["ConsiderStanding"] = tcs.ToggleStateToBool(gkini.ReadString("MakeFriends_"..preset, "ConsiderStanding", "OFF"))
end

--Let's go the easy way and make mf compatible with MakeFriends settings. So much easier for me.
function mf.SaveSettings(preset)
	if(preset == nil) then
		return
	end
	preset = strip_whitespace(preset)
	gkini.WriteString("MakeFriends_"..preset, "Serco", iup.GetAttribute(mf.ui.serco, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Itani", iup.GetAttribute(mf.ui.itani, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "UIT", iup.GetAttribute(mf.ui.uit, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Aeolus", iup.GetAttribute(mf.ui.aeolus, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Ineubis", iup.GetAttribute(mf.ui.ineubis, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Valent", iup.GetAttribute(mf.ui.valent, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Axia", iup.GetAttribute(mf.ui.axia, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Biocom", iup.GetAttribute(mf.ui.biocom, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "TPG", iup.GetAttribute(mf.ui.tpg, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Orion", iup.GetAttribute(mf.ui.orion, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "Corvus", iup.GetAttribute(mf.ui.corvus, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Unaligned", iup.GetAttribute(mf.ui.unaligned, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Tunguska", iup.GetAttribute(mf.ui.tunguska, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "XangXi", iup.GetAttribute(mf.ui.xangxi, "VALUE")) 
	gkini.WriteString("MakeFriends_"..preset, "Group", iup.GetAttribute(mf.ui.group, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "Guild", iup.GetAttribute(mf.ui.guild, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "Buddies", iup.GetAttribute(mf.ui.buddies, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "NPCs", iup.GetAttribute(mf.ui.NPC, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "StatG", iup.GetAttribute(mf.ui.statg, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "SF", iup.GetAttribute(mf.ui.sf, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igEnemy", iup.GetAttribute(mf.ui.igenemy, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igFriend", iup.GetAttribute(mf.ui.igfriend, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igEnemyGuild", iup.GetAttribute(mf.ui.igenemyguild, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "igFriendGuild", iup.GetAttribute(mf.ui.igfriendguild, "VALUE"))
	gkini.WriteString("MakeFriends_"..preset, "FlagHostiles", iup.GetAttribute(mf.ui.flaghostile, "VALUE"))
	gkini.WriteInt("MakeFriends_"..preset, "HostileTimeout", iup.GetAttribute(mf.ui.flaghostiletext, "VALUE") * 60)
	gkini.WriteString("MakeFriends_"..preset, "ConsiderStanding", iup.GetAttribute(mf.ui.considerstanding, "VALUE"))
end

function mf.LoadLists()
		mf.friendslist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "Friends", ""))
		mf.enemylist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "Enemies", ""))
		mf.friendguildlist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "FriendGuilds", ""))
		mf.enemyguildlist = unspickle(gkini.ReadString("MakeFriends-"..GetPlayerName(), "EnemyGuilds", ""))
		mf.enemyguildmap=tcs.iListToMap(mf.enemyguildlist)
		mf.friendguildmap=tcs.iListToMap(mf.friendguildlist)
		mf.enemymap=tcs.iListToMap(mf.enemylist)
		mf.friendmap=tcs.iListToMap(mf.friendslist)
end

function mf.SaveLists()
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Friends", spickle(mf.friendslist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Enemies", spickle(mf.enemylist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "FriendGuilds", spickle(mf.friendguildlist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "EnemyGuilds", spickle(mf.enemyguildlist))
end	
function mf.LoadPresets()
	mf.presets = unspickle(gkini.ReadString("MakeFriends", "Presets", ""))
end
function mf.SavePresets()
	gkini.WriteString("MakeFriends", "Presets", spickle(mf.presets))
end

--Load settings in config.ini 
mf.OnCharacterSelect = {}
function mf.OnCharacterSelect:OnEvent()
	mf.LoadLists()
	mf.LoadPresets()
	mf.curpreset = gkini.ReadString("MakeFriends-"..GetPlayerName(), "CurrentPreset", "Default")
	mf.LoadSettings(mf.curpreset)
end
RegisterEvent(mf.OnCharacterSelect, "PLAYER_ENTERED_GAME")
if(GetPlayerName() ~= nil) then
	mf.LoadLists()
	mf.LoadPresets()
	mf.curpreset = gkini.ReadString("MakeFriends-"..GetPlayerName(), "CurrentPreset", "Default")
	mf.LoadSettings(mf.curpreset)
end


--Toggle color function.
local function npc_defs (fs_def, ui_elm) 
	if (fs_def) then 
		iup.SetAttributes(ui_elm, "VALUE=ON,FGCOLOR=\"255 0 0\"")
	else
		iup.SetAttributes(ui_elm, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end
end

local function norm_defs(fs_def, ui_elm)
	if(fs_def) then 
		iup.SetAttributes(ui_elm, "VALUE=ON,FGCOLOR=\"255 255 255\"")
	else
		iup.SetAttributes(ui_elm, "VALUE=OFF,FGCOLOR=\"255 255 255\"")
	end		
end

local function fac_defs(fs_def, ui_elm)
	if(fs_def) then
		iup.SetAttributes(ui_elm, "VALUE=ON,FGCOLOR=\"0 255 0\"")
	else
		iup.SetAttributes(ui_elm, "VALUE=OFF,FGCOLOR=\"255 0 0\"")
	end
end

function mf.GetFriends()
	npc_defs(FS["StatG"], mf.ui.statg)
	npc_defs(FS["SF"], mf.ui.sf)
	
	norm_defs(FS["igEnemy"], mf.ui.igenemy)
	norm_defs(FS["igFriend"], mf.ui.igfriend)
	norm_defs(FS["igEnemyGuild"], mf.ui.igenemyguild)
	norm_defs(FS["igFriendGuild"], mf.ui.igfriendguild)
	norm_defs(FS["FlagHostile"], mf.ui.flaghostile)
	norm_defs(FS["ConsiderStanding"], mf.ui.considerstanding)

	mf.ui.flaghostiletext.value = mf.LastAggro.timeout / 60
	
	fac_defs(mf.factions[0], mf.ui.unaligned)
	fac_defs(mf.factions[1], mf.ui.itani)
	fac_defs(mf.factions[2], mf.ui.serco)
	fac_defs(mf.factions[3], mf.ui.uit)
	fac_defs(mf.factions[4], mf.ui.tpg)
	fac_defs(mf.factions[5], mf.ui.biocom)
	fac_defs(mf.factions[6], mf.ui.valent)
	fac_defs(mf.factions[7], mf.ui.orion)
	fac_defs(mf.factions[8], mf.ui.axia)
	fac_defs(mf.factions[9], mf.ui.corvus)
	fac_defs(mf.factions[10], mf.ui.tunguska)
	fac_defs(mf.factions[11], mf.ui.aeolus)
	fac_defs(mf.factions[12], mf.ui.ineubis)
	fac_defs(mf.factions[13], mf.ui.xangxi)
	
	fac_defs(FS["Guild"], mf.ui.guild)
	fac_defs(FS["Group"], mf.ui.group)
	fac_defs(FS["Buddy"], mf.ui.buddies)
	fac_defs(FS["NPC"], mf.ui.NPC)
end

function mf.LastAggro:OnEvent(event, victim, aggressor)
	victim = victim or GetCharacterID() or 1
	aggressor = aggressor or GetCharacterIDByName(GetTargetInfo()) or 1
	if(victim == GetCharacterID()) then
		if(not mf.LastAggro[aggressor]) then
			mf.LastAggro[aggressor] = { name = GetPlayerName(aggressor),lasthit = os.time() }
		else
			mf.LastAggro[aggressor]["lasthit"] = os.time()
		end
	end
end
RegisterEvent(mf.LastAggro, "PLAYER_GOT_HIT")
RegisterEvent(mf.LastAggro, "PLAYER_HIT")

function mf.LastAggro.Reset(kind)
	--just like parrotorcarrot!
	local player_or_npc = ((kind=="player" and 1) or (kind=="npc" and 2) or 3)
	for agg, last in pairs(mf.LastAggro) do
		if(type(last) == "table" and last.lasthit and last.name) then
			if(player_or_npc == 1 and not tSaS(last.name, "*")) then
				--Players only!
				mf.LastAggro[agg] = nil
			elseif(player_or_npc == 2 and tSaS(last.name, "*")) then
				mf.LastAggro[agg] = nil
			elseif(player_or_npc == 3) then
				mf.LastAggro[agg] = nil
			end
		end
	end
	--Done!
end

local function la_cli(input, args)
	if not input then input = table.concat(args or {"all"}, " ") end
	input = string.lower(input)
	mf.LastAggro.Reset(input)
	input = (input == "player" and "player") or (input == "npc" and "npc") or "entire"
	print("\t\127ffffffYour "..input.." list for MF:LastAggro has been reset.")
end

RegisterUserCommand("mfLA_reset_player", la_cli, "player")
RegisterUserCommand("mfLA_reset_npc", la_cli, "npc")
RegisterUserCommand("mfLA_reset_all", la_cli, "all")
RegisterUserCommand("mfLA_reset", la_cli)

	
local cli_cmd = {cmd ="makefriends", interp = 	function(input) 
													--Sanitize to make sense and work with la_cli
													if(input[1] == "reset") then
														la_cli(input[2])
													end
												end}

tcs.ProvideConfig(tcs.mf.name, mf.ui.dlg, "Customizes how players are displayed on radar.", cli_cmd, function(_,s)
																			if s == 1 then
																				GetFriendlyStatus = mf.GetFriendlyStatus
																				mf.state = 1
																				mf.state = gkini.WriteInt("MakeFriends", "Enabled", 1)
																			elseif s == 0 then
																				GetFriendlyStatus = mf.GetFriendlyStatus_OLD
																				mf.state = 1
																				mf.state = gkini.WriteInt("MakeFriends", "Enabled", 0)
																			elseif s == -1 then
																				return tcs.IntToToggleState(mf.state)
																			end
																		end)