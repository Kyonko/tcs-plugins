-- Puts current target info into the center of the screen, replacing the useless sector gunk.

tcs.central = {}

tcs.central.state = gkini.ReadInt("tcs", "central.state", 0)

local distanceindicator = tcs.GetRelative(HUD.distancetext, 1)

function tcs.central.update()
	local self = HUD
	local curtime = gkmisc.GetGameTime()
	local delta = gkmisc.DiffTime(self.prevtime, curtime)*0.001
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
	--Sets turret HP
	if parenthealth then
		parenthealth = math.max(parenthealth, 0)
		self.distancetext.title = string.format("Ship armor: %d%%", parenthealth)
		self.jumpindicator.distance3000m.visible = "NO"
		self.jumpindicator.distance_all.visible = "YES"
		self.jumpindicator.distancebar.value = 60*parenthealth
		self.jumpindicator.distancebar.altvalue = 0
	elseif health and tcs.central.state == 1 then 	--Change distance text to health value
		self.jumpindicator.distance3000m.visible = "NO"
		self.jumpindicator.distance_all.visible = "YES"
		self.jumpindicator.distancebar.value = 3000 + health*3000
		self.jumpindicator.distancebar.altvalue = 3000 - health*3000
		self.distancetext.title = string.format("%sm", comma_value(math.floor(distance or 0)))
		if guild_tag and guild_tag ~= "" then guild_tag = "["..guild_tag.."]" end
		self.locationtext.title = "\127"..tcs.GetFactionColor(factionid)..(guild_tag or "")..name
		
		self.sectoralignmenttext.title = shipname
		iup.Refresh(distanceindicator)
	else
		local dist = radar.GetNearestObjectDistance()
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
		self.distancetext.title = string.format("%dm", dist)
	end
	self:UpdateWeaponProgress(delta)
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
			FadeControl(self.blood_flash, 0.5, FlashIntensity, 0)
		end
	end
end

HUD.update = tcs.central.update
tcs.ProvideConfig("Central Info", nil, "Hijacks your distance meter to display target info.", function(_,s) 
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
