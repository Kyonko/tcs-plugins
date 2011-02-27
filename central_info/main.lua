-- Puts current target info into the center of the screen, replacing the useless sector gunk.

tcs.central = {}

tcs.central.state = gkini.ReadInt("tcs", "central.state", 0)
tcs.central.nfz_indicator = gkini.ReadInt("Vendetta", "HUDnfzindicator", 1)==1

tcs.central.nfzmode = false
local function setup_hud()
	tcs.central.doppler = iup.label { title = "______", fgcolor ="127 127 127", alignment="ACENTER", expand="HORIZONTAL", font=Font.H4*HUD_SCALE }

	local distanceindicator = tcs.GetRelative(HUD.distancetext, 1)

	local c = iup.GetNextChild(distanceindicator)
	local jumpindicator = iup.GetBrother(HUD.distancetext)
	local t_c
	while c do
		t_c = iup.GetNextChild(distanceindicator, c)
		iup.Detach(c)
		c = t_c
	end
	if Game.GetNFZMode() then tcs.central.nfzmode = true end
	
	iup.Append(distanceindicator, HUD.nfzindicator)
	iup.Append(distanceindicator, iup.fill{size="30"})
	iup.Append(distanceindicator, HUD.nfzindicator)
	iup.Append(distanceindicator, HUD.distancetext)
	iup.Append(distanceindicator, tcs.central.doppler)
	iup.Append(distanceindicator, jumpindicator)
	iup.Append(distanceindicator, iup.fill{size="30"})
	iup.Append(distanceindicator, HUD.locationtext)
	iup.Append(distanceindicator, iup.fill{size="30"})
	iup.Append(distanceindicator, HUD.sectoralignmenttext)
	distanceindicator:show()
	iup.Refresh(distanceindicator)
end

--NFZ jazz ripped from VO if code
function tcs.central.ChangeNFZMode()
	if not HUD.IsVisible then return end
	if Game.GetNFZMode() then
		tcs.central.nfzmode = true
	else
		tcs.central.nfzmode = false
	end
end

function tcs.central.nfz (e) 
	if (e == "ENTER_ZONE_NFZ") or (e == "LEAVE_ZONE_NFZ") then
		if tcs.central.nfz_indicator then
			local nfz_alert_mode = Game.GetNFZMode()
			gksound.GKPlaySound(nfz_alert_mode and "nfz.warning.enter" or "nfz.warning.leave");
		end
		tcs.central.ChangeNFZMode()
	end
end	
RegisterEvent(tcs.central.nfz, "ENTER_ZONE_NFZ")
RegisterEvent(tcs.central.nfz, "LEAVE_ZONE_NFZ")
	

tcs.central.speed_history = {}
--Wipe speed history table whenever we change targets

function tcs.central.speed_history:TARGET_CHANGED()
	for i=1, #tcs.central.speed_history do
		tcs.central.speed_history[i] = nil
	end
end
RegisterEvent(tcs.central.speed_history, "TARGET_CHANGED")


local function blur_speed(speed)
	--Make proper queue support later, I guess
	local sum = 0
	local s_len = #tcs.central.speed_history
	for i = 1, s_len  do 
		sum = sum + tcs.central.speed_history[i]
	end
	--Just a linear smooth for now
	if(s_len > 5) then
		table.remove(tcs.central.speed_history)
	end
	table.insert(tcs.central.speed_history, 1, speed)
	
	return (sum > 0 and (speed+sum)/(s_len + 1)) or speed
end
	
	
local function calculate_doppler_shift(dist_delta, time_delta)
	--100m/s = .1m/ms
	--500m/s = .5m/ms
	--When dist_delta is positive, red shift. Blue shift if negative
	if time_delta == 0 then return tcs.central.doppler.fgcolor end
	
	local speed = math.abs(dist_delta)/time_delta
	speed = blur_speed(speed)
	if speed > 500 then speed = 500 end
	
	if speed == 0 then return "127 127 127" end
	
	local color_delta
	if speed <= 120 then 
		color_delta = math.floor(speed*82/100)
	else
		color_delta = math.floor(speed*44/100 + 83)
	end
	if(color_delta > 127) then color_delta = 127 end
	if dist_delta > 0 then
		return 128+color_delta.." "..127-color_delta.." "..127-color_delta
	end
	return 127-color_delta.." "..127-color_delta.." "..127+color_delta
end

if not FlashIntensity then
	declare("FlashIntensity", gkini.ReadInt("Vendetta", "flashintensity", 100)/100)
end

local last_dist_delta
local prevdist = -1
local dist_delta


function tcs.central.update()
	local distanceindicator = tcs.GetRelative(HUD.distancetext, 1)
	tcs.central.doppler.visible = "NO"
	local self = HUD
	self.nfzindicator.visible = (tcs.central.nfzmode and "YES") or "NO"
	local curtime = gkmisc.GetGameTime()
	local time_delta = gkmisc.DiffTime(self.prevtime, curtime)*0.001
	local dist_delta
	self.prevtime = curtime
	self:setspeed(GetActiveShipSpeed() or 0)
	local e1,e2 = GetActiveShipEnergy()
	self:setenergy(e1 or 0 ,e2 or 0)
	local name, health, distance, factionid, guild_tag, shipname, shieldstrength = GetTargetInfo()
	
	self:SetTargetDistance(distance)
	local parenthealth = GetParentHealth()
	--Need to set out location and alignment text, because when you have a target it plays with it.
	self.locationtext.title = ShortLocationStr(GetCurrentSectorid())
	self.sectoralignmenttext.title = (FactionName[GetSectorAlignment()] or "").."  "..(FactionMonitorStr[GetSectorMonitoredStatus()] or "")
	local minjumpdist = GetMinJumpDistance()
	local dist = radar.GetNearestObjectDistance()
	if dist > minjumpdist then dist = minjumpdist end
	--print(delta)
	--
	--Sets turret HP
	
	if name and tcs.central.state == 1 then
		if prevdist == -1 then prevdist = distance else
			dist_delta = distance - prevdist + (last_dist_delta or dist_delta or (distance - prevdist))/2
			prevdist = distance
		end
		last_dist_delta = dist_delta
		--print(dist_delta)
		if dist_delta then 
			tcs.central.doppler.visible = "YES"
			tcs.central.doppler.fgcolor = calculate_doppler_shift(dist_delta, time_delta) 
		end
	end
	
	
	if health and tcs.central.state == 1 then 	--Change distance text to health value
		self.nfzindicator.visible="NO"
		
		local targetdist = string.format("%sm", comma_value(math.floor(distance or 0)))
		self.jumpindicator.distancebar.value = minjumpdist+dist
		self.jumpindicator.distancebar.altvalue = minjumpdist-dist

		if guild_tag and guild_tag ~= "" then guild_tag = "["..guild_tag.."]" end
		self.locationtext.title = "\127"..tcs.GetFactionColor(factionid)..(guild_tag or "")..name
		
		self.sectoralignmenttext.title = shipname..tcs.CalcPercentagesText_dull(health, shieldstrength)

		self.distancetext.title = "\127"..tcs.CalcStagedDistColor(math.floor(distance or 0))..targetdist
		
		
		if dist < 0 or dist >= minjumpdist then
			dist = minjumpdist
			self.jumpindicator.distancebar.value = 6000
			self.jumpindicator.distancebar.altvalue = 0
			if ((self.destarrow == 3) or (self.destarrow == 2)) and not self.continuecoursemsgprinted then
				self.jumpindicator.distance3000m.visible = "YES"
				self.jumpindicator.distance_all.visible = "NO"
				self.notify_text.title = "Press the Activate key to continue on your plotted course."
				FadeControl(self.notify_text, 3, 3, 0)
				self.continuecoursemsgprinted = true
			end
		end
		if tcs.central.nfzmode then
			self.distancetext.title = "\127d42020[\127OE99CA"..self.distancetext.title.."\127d42020]"
		end
	else
		--past_dist = -1
		if dist < 0 or dist >= minjumpdist then
			dist = minjumpdist
			self.jumpindicator.distancebar.value = 6000
			self.jumpindicator.distancebar.altvalue = 0
			if ((self.destarrow == 3) or (self.destarrow == 2)) and not self.continuecoursemsgprinted then
				self.jumpindicator.distance3000m.visible = "YES"
				self.jumpindicator.distance_all.visible = "NO"
				self.notify_text.title = "Press the Activate key to continue on your plotted course."
				FadeControl(self.notify_text, 3, 3, 0)
				self.continuecoursemsgprinted = true
			end
		else
			self.jumpindicator.distance3000m.visible = "NO"
			self.jumpindicator.distance_all.visible = "YES"
			self.jumpindicator.distancebar.value = minjumpdist+dist
			self.jumpindicator.distancebar.altvalue = minjumpdist-dist
			self.continuecoursemsgprinted = false
		end
		
		if tcs.central.state == 1 and tcs.central.nfzmode then
			HUD.nfzindicator.visible = "OFF"
			self.distancetext.title = string.format("\127d42020[\127OE99CA%dm\127d42020]", dist)
		else
			self.distancetext.title = string.format("%dm", dist)
		end
		
		if parenthealth then
			parenthealth = math.max(parenthealth, 0)
			self.distancetext.title = string.format("Ship armor: %d%%", parenthealth)
		end
		--Toss in our cooler NFZ indicator
		
		
	end
	
	--Adjust for sitting in a turret!
	if parenthealth then
		--past_dist = -1
		parenthealth = math.max(parenthealth, 0)
		
		self.jumpindicator.distance3000m.visible = "NO"
		self.jumpindicator.distance_all.visible = "YES"
		self.jumpindicator.distancebar.value = 60*parenthealth
		self.jumpindicator.distancebar.altvalue = 0
	end
	
	iup.Refresh(distanceindicator)
	self:UpdateWeaponProgress(time_delta)
	self.updatetimer:SetTimeout(50)
	
	if self.nummissiontimers > 0 then
		self:UpdateMissionTimers(GetMissionTimers())
	end
	
	if self.PLAYER_GOT_HIT_args then
		local arg1, attackercharid, arg3, arg4 = self.PLAYER_GOT_HIT_args[1], self.PLAYER_GOT_HIT_args[2], self.PLAYER_GOT_HIT_args[3], self.PLAYER_GOT_HIT_args[4]
		self.PLAYER_GOT_HIT_args = nil
		local attackername = GetPlayerName(attackercharid)
		if attackername then
			local color
			if arg4 then
				color = "255 0 0"  -- being damaged = red
			else
				color = "0 255 0"  -- being healed = green
			end
			if attackercharid ~= GetCharacterID() then -- don't show self
				self.hitby_text.fgcolor = color 
				self.hitby_text.title = attackername
				FadeControl(self.hitby_text, 5, 4, 0)
			end
			self.blood_flash.bgcolor = color.." 0 +"
			self.blood_flash.visible = "YES"
			FadeControl(self.blood_flash, 0.5, FlashIntensity or 1, 0)
		end
	end
end
tcs.central.e = {}
function tcs.central.e:OnEvent(e)
	HUD.update = tcs.central.update
	setup_hud()
	ProcessEvent("TCS_HUD_CENTRALINFO_SETUP")
	UnregisterEvent(tcs.central.e, "SHIP_SPAWNED")
end
RegisterEvent(tcs.central.e,"SHIP_SPAWNED")
tcs.RegisterHudScaleEvent(tcs.central.e)

if GetCharacterID() and not PlayerInStation() then
	tcs.central.e:OnEvent(e)
end

local cli_cmd = {cmd ="", interp = nil} -- todo
tcs.ProvideConfig("Central Info", nil, "Places target info front and center, replacing useless sector junk.", function(_,s) 
																	if s == 1 then
																		tcs.central.state = 1
																		gkini.WriteInt("tcs", "central.state", 1)
																	elseif s == 0 then
																		tcs.central.state = 0
																		gkini.WriteInt("tcs", "central.state", 0)
																	elseif s == -1 then
																		return tcs.IntToToggleState(tcs.central.state)
																	end
																end)