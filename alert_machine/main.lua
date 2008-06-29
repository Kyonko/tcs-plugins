--THIS IS THE ALERTMACHINE. IT IS A MACHINE THAT ALERTS.

tcs.alm = {}
tcs.alm.state = gkini.ReadInt("tcs", "alm.state", 1)
tcs.alm.usefactioncolors = gkini.ReadInt("tcs", "alm.usefactioncolors", 1)
tcs.alm.usestandingcolors = gkini.ReadInt("tcs", "alm.usestandingcolors", 1)
tcs.alm.colorplayername = gkini.ReadInt("tcs", "alm.colorplayername", 1)
tcs.alm.textcolor = gkini.ReadString("tcs", "alm.textcolor", "ba70d6")
tcs.alm.timeout = 2
tcs.alm.cache = {}
tcs.local_alignment = 1 --Number indicating which faction current space is aligned to

tcs.alm.format = {
	inrange = gkini.ReadString("tcs", "alm.inrange", "%tag%%char%: %ship% - %hp%%% health %dist%m away\n%standings%"),
	outrange = gkini.ReadString("tcs", "alm.outrange", "%tag%%char%: Out of range."),
	leftrange = gkini.ReadString("tcs", "alm.leftrange", "%tag%%char%: Left radar range."),
	enteredrange = gkini.ReadString("tcs", "alm.enteredrange", "%tag%%char%: Entered radar range."),
	left = gkini.ReadString("tcs", "alm.left", "%tag%%char%: Left the sector."),
	updatest = gkini.ReadString("tcs", "alm.updatest","%tag%%char%: New standings - %standings%"),
	updateguj = gkini.ReadString("tcs", "alm.updateguj","%tag%%char% has joined %tag%."),
	updategul	= gkini.ReadString("tcs", "alm.updategul","%char% has left their guild."),
	updatesh = gkini.ReadString("tcs", "alm.updatesh","%tag%%char: Has switched ships to the %ship%"),
	standing = gkini.ReadString("tcs", "alm.standing", "%faction%:%standing%")
}



--Formats and prints alerts according to settings and data given.
--[[
tcs.alm.cache[charid] = {
	player_name,
	player_faction,
	player_ship,
	guild_tag,
	itani_standing,
	serco_standing,
	uit_standing,
	local_standing,
	lastseen,
	entered,
	inrange,
}
	]]
	
--[[
new = {
	ship,
	standing,
	guild,
	range,
}
]]

--[[
General format stuff:
	inrange: 
		%tag%char: %ship - %hp%% hull %sp%% shield %distm away\n%standing
	
	outrange:
		%tag%char: Out of range.
		
	leftrange:
		%tag%char: Left radar range.
		
	left:
		%tag%char: Left the sector.
	
	update:
		%tag%char: %standingsmsg%guildmsg%shipmsg
]]
function tcs.alm.FormatStanding(charid) 
	local standing = ""
	local istand = tcs.alm.format.standing
	local sstand = tcs.alm.format.standing
	local ustand = tcs.alm.format.standing
	local lstand = tcs.alm.format.standing
	
	
	if tcs.alm.usefactioncolors == 1 then
		istand = string.gsub(istand, "%%faction%%", "\127"..tcs.GetFactionColor(1).."I\127"..tcs.alm.textcolor)
		sstand = string.gsub(sstand, "%%faction%%", "\127"..tcs.GetFactionColor(2).."S\127"..tcs.alm.textcolor)
		ustand = string.gsub(ustand, "%%faction%%", "\127"..tcs.GetFactionColor(3).."U\127"..tcs.alm.textcolor)
	else
		istand = string.gsub(istand, "%%faction%%", "I")
		sstand = string.gsub(sstand, "%%faction%%", "S")
		ustand = string.gsub(ustand, "%%faction%%", "U")
	end
	
	if tcs.alm.usestandingcolors == 1 then
		istand = string.gsub(istand, "%%standing%%", "\127"..tcs.RGBToHex(tcs.factionfriendlynesscolor(GetPlayerFactionStanding(1, charid)))..factionfriendlyness(GetPlayerFactionStanding(1, charid)).."\127"..tcs.alm.textcolor)
		sstand = string.gsub(sstand, "%%standing%%", "\127"..tcs.RGBToHex(tcs.factionfriendlynesscolor(GetPlayerFactionStanding(2, charid)))..factionfriendlyness(GetPlayerFactionStanding(2, charid)).."\127"..tcs.alm.textcolor)
		ustand = string.gsub(ustand, "%%standing%%", "\127"..tcs.RGBToHex(tcs.factionfriendlynesscolor(GetPlayerFactionStanding(3, charid)))..factionfriendlyness(GetPlayerFactionStanding(3, charid)).."\127"..tcs.alm.textcolor)
	else
		istand = string.gsub(istand, "%%standing%%",  factionfriendlyness(GetPlayerFactionStanding(1, charid)))
		sstand = string.gsub(sstand, "%%standing%%", factionfriendlyness(GetPlayerFactionStanding(2, charid)))
		ustand = string.gsub(ustand, "%%standing%%", factionfriendlyness(GetPlayerFactionStanding(3, charid)))
	end
	
	standing = istand.." "..sstand.." "..ustand
	
	if GetSectorMonitoredStatus() ~= 1 then
		if tcs.alm.usestandingcolors == 1 then
			lstand = string.gsub(lstand, "%%faction%%", "\127"..tcs.GetFactionColor(11).."L\127"..tcs.alm.textcolor)
		else
			lstand = string.gsub(lstand, "%%faction%%", "L")
		end
		if tcs.alm.usestandingcolors == 1 then
			lstand = string.gsub(lstand, "%%standing%%", "\127"..tcs.RGBToHex(tcs.factionfriendlynesscolor(GetPlayerFactionStanding("sector", charid)))..factionfriendlyness(GetPlayerFactionStanding("sector", charid)).."\127"..tcs.alm.textcolor)
		else
			lstand = string.gsub(lstand, "%%standing%%", factionfriendlyness(GetPlayerFactionStanding("sector", charid)))
		end
		standing = standing.." "..lstand
	end
	return standing
end
function tcs.alm.print(report_type, charid, new)
	local health, distance, shield
	if not tcs.alm.cache[charid] then return end
	if tcs.alm.state ~= 1 or tcs.StringAtStart(tcs.alm.cache[charid].player_name, "*") or charid == 0 or charid == GetCharacterID() then return end
	local output = ""
	
	if report_type == "left" then
		output = tcs.alm.format.left
	elseif report_type == "update" then
		--[[if new.guild then
			if tcs.alm.cache[charid].guild_tag then
				output = tcs.format.updateguj
			else
				output = tcs.format.updategul
			end
		end]]
		if tcs.alm.cache[charid].inrange then
			health = math.floor(GetPlayerHealth(charid) or 0)
			shield = nil
			distance = math.floor(GetPlayerDistance(charid) or 0)
			if not tcs.alm.cache[charid].entered then 
				output = tcs.alm.format.inrange
				tcs.alm.cache[charid].entered = true
				tcs.alm.cache[charid].notif = true
			elseif new.inrange then
				output = tcs.alm.format.enteredrange
			elseif new.ship then
				output = tcs.alm.format.updatesh
			elseif new.standing then 
				output = tcs.alm.format.updatest
			end
		else 
			if not tcs.alm.cache[charid].notif then
				output = tcs.alm.format.outrange
				tcs.alm.cache[charid].entered = false
				tcs.alm.cache[charid].notif = true
			elseif new.inrange then
				output = tcs.alm.format.leftrange
			end
		end
	end
--[[ Formatting bits
	%%  			-- %
	%char %			-- Character name
	%dist%			-- Distance
	%hp% 			-- Hull percentage
	%sp% 			-- Shield percentage
	%ship%			-- Current ship
	%tag% 			-- Guild tag
	%standing%		-- Standing block
	%I,S,U,L% 		-- Faction names
	%is,ss,us,ls% 		-- Standing level indicators. 
]]
	if output == "" then return end
	output = "\127"..tcs.alm.textcolor..output
	local standings = tcs.alm.FormatStanding(charid)
	local name = tcs.alm.cache[charid].player_name
	local ship = tcs.alm.cache[charid].player_ship
	local tag = tcs.alm.cache[charid].guild_tag
	local function format_output(s)
		if s == "%char%" then
			if tcs.alm.colorplayername == 1 then
				return "\127"..tcs.GetFactionColor(GetPlayerFaction(charid))..tcs.alm.cache[charid].player_name.."\127"..tcs.alm.textcolor
			else
				return tcs.alm.cache[charid].player_name
			end
		elseif s == "%dist%" then
			return distance
		elseif s == "%hp%" then
			return health
		elseif s == "%sp%" then
			return ""
		elseif s == "%ship%" then
			return tcs.alm.cache[charid].player_ship
			elseif s == "%tag%" then
			if tcs.alm.cache[charid].guild_tag ~= "" then
				if tcs.alm.colorplayername == 1 then
					return "\127"..tcs.GetFactionColor(GetPlayerFaction(charid)).."["..tcs.alm.cache[charid].guild_tag.."]".."\127"..tcs.alm.textcolor
				else
					return "["..tcs.alm.cache[charid].guild_tag.."]"
				end
			else
				return ""
			end
		elseif s == "%standings%" then
			return standings
		elseif s == "%%" then
			return "%"
		end
	end
	output = string.gsub(output, "(%%%w*%%)", format_output)
	print(output)
end

function tcs.alm:OnEvent(event, charid)
	if tcs.alm.state ~= 1 then return end
	
	if event == "PLAYER_ENTERED_SECTOR" then
		if charid == GetCharacterID() or charid == 0 then return end
		--Create an entry for the player in our cache
		tcs.alm.cache[charid] = {  player_name = GetPlayerName(charid), 
							entered = false, 
						}
	end
	
	if event == "PLAYER_LEFT_SECTOR" then
		if charid == GetCharacterID() then
			--Clear ALM bits
			tcs.alm.cache = {}
			tcs.alm.cacheTimer:Kill()
			return
		end
		if charid == 0 then return end
		--Report a character leaving
		tcs.alm.print("left",tcs.alm.cache[charid])
		tcs.alm.cache[charid] = nil
		
	end
	
	if event == "SHIP_SPAWNED" then
		--Set up the ALM timer
		if not tcs.alm.cacheTimer:IsActive() then
			tcs.alm.cacheTimer:SetTimeout(200, function() tcs.alm.cacheProcess(); tcs.alm.cacheTimer:SetTimeout(200) end)
		end
	end
	
	if event == "PLAYER_LOGGED_OUT" then
		--Kill ALM mechanisms
		tcs.alm.cacheTimer:Kill()
		tcs.alm.cache = {}
	end
end

--Updates the ALM cache
function tcs.alm.PlayerUpdate(charid)
	if not tcs.alm.cache[charid] then return end  --Why are we updating someone not in the cache?
	local player_ship = GetPrimaryShipNameOfPlayer(charid)	
	if not player_ship then return end
	local new = {}
	local player_name = GetPlayerName(charid)
	local player_faction = GetPlayerFaction(charid)

	local guild_tag = GetGuildTag(charid)
	local itani_standing = GetPlayerFactionStanding(1, charid)
	local serco_standing = GetPlayerFactionStanding(2, charid)
	local uit_standing = GetPlayerFactionStanding(3, charid)
	local local_standing = GetPlayerFactionStanding("sector", charid)
	local inrange = true
	
	if tcs.StringAtStart(tcs.alm.cache[charid].player_name, "(readi") == true then tcs.alm.cache[charid].player_name = player_name; return end
	
	if GetPlayerHealth(charid) == -1 then inrange = false end
	if player_ship ~= tcs.alm.cache[charid].player_ship then
		tcs.alm.cache[charid].player_ship = player_ship
		new.ship = true
	end
	
	if guild_tag ~= tcs.alm.cache[charid].guild_tag then
		tcs.alm.cache[charid].guild_tag = guild_tag
		new.guild = true
	end
	
	if inrange ~= tcs.alm.cache[charid].inrange then
		tcs.alm.cache[charid].inrange = inrange
		new.range = true
	end
	
	if itani_standing ~= tcs.alm.cache[charid].itani_standing or serco_standing ~= tcs.alm.cache[charid].serco_standing or uit_standing ~= tcs.alm.cache[charid].uit_standing or local_standing ~= tcs.alm.cache[charid].local_standing then
		if factionfriendlyness(GetPlayerFactionStanding(1, charid)) == "Unknown" then return end
		tcs.alm.cache[charid].itani_standing = itani_standing
		tcs.alm.cache[charid].serco_standing = serco_standing
		tcs.alm.cache[charid].uit_standing = uit_standing
		tcs.alm.cache[charid].local_standing = local_standing
		new.standing = true
	end
	
	--Do nothing if there is nothing to update
	if tcs.alm.cache[charid].entered and not new.standing and not new.range and not new.guild and not new.ship then return end
	tcs.alm.print("update", charid, new)
	return
end
		
function tcs.alm.cacheProcess()
	if tcs.alm.state ~= 1 then return end
	for key, value in pairs(tcs.alm.cache) do 
		tcs.alm.PlayerUpdate(key)
	end
end

tcs.alm.cacheTimer = Timer()
tcs.alm.cacheTimer:SetTimeout(200, function() tcs.alm.cacheProcess(); tcs.alm.cacheTimer:SetTimeout(200) end)


RegisterEvent(tcs.alm, "PLAYER_ENTERED_SECTOR")
RegisterEvent(tcs.alm, "PLAYER_LEFT_SECTOR")
RegisterEvent(tcs.alm, "SHIP_SPAWNED")
RegisterEvent(tcs.alm, "PLAYER_LOGGED_OUT")

tcs.alm.test = {}
function tcs.alm.test:OnEvent(v1, v2, v3, v4, v5, v6, v7)
	printtable({v1, v2, v3, v4, v5, v6})
end
--[[
RegisterEvent(tcs.alm.test, "PLAYER_ENTERED_SECTOR")
RegisterEvent(tcs.alm.test, "PLAYER_LEFT_SECTOR")
RegisterEvent(tcs.alm.test, "UPDATE_CHARINFO")]]