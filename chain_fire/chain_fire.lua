local name = "CFire"

tcs.cfire = {}
local cf = tcs.cfire
local gkpc = gkinterface.GKProcessCommand
local ERROR = tcs.ERROR
local INFO = tcs.INFO
local cli_cmd = {cmd = "cfire", interp = nil}

--[[----------CVARS----------]]--
--cvar = {savename, current, default}
cf.cvars = {
	auto_delay = {"cfire_auto_delay",true,true},
	delay	   = {"cfire_delay",.07,.07},
}
local cvars = cf.cvars

cd.MIN_DELAY = .02

cf.cfires = {}
local cfires = cf.cfires

	
cf.auto_delay = gkini.ReadInt("tcs", "cfire_auto_delay", 1)==1

--Two is primary, One is secondary, Three is tertiary in VO. We're going to name things sane here
local pshoot1 = function() gkpc("+shoot2") end
local mshoot1 = function() gkpc("+shoot2 0") end
local pshoot2 = function() gkpc("+shoot1") end
local mshoot2 = function() gkpc("+shoot1 0") end
local pshoot3 = function() gkpc("+shoot3") end
local mshoot3 = function() gkpc("+shoot3 0") end
--This function updates cfire cvars based on current settings and weapons ports
function cf.UpdateChains() 
	local delay = cvars.auto_delay[2] and cf.CalcAutoDelay() or cvars.delay[2]
	

end

function cf.ToggleSingleSalvo(cfire)
	cfire = tonumber(cfire)
	if not cfire or not cfires[cfire] then 
		ERROR("Invalid input. Please enter the ID of a valid cfire setting.")
		return 
	end
	if(not cfires[cfire]
	cfires[cfire].single = not cfires[cfire].single
	--Reset from single to not-single
	cfires[cfire]:off()
	cfires[cfire]:on()
	if 		cfires[cfire].single and cfires[cfire].sqwak_single then INFO("CFire"..cfire.." set to single salvo.") 	return end
	if  not	cfires[cfire].single and cfires[cfire].sqwak_single then INFO("CFire"..cfire.." set to chain fire.") 	return end
end

function cf.WriteCFires(cfire, chain) 
	--Call with cfires[cfire]:<on|off>
	local cfiret = cfires[cfire]
	
	function cfiret:incr_fire()
		--Kill last chain, process current chain, and then increment
		self.chain[self.chain_num-1].off()
		if self.chain_num > #self.chain then
			self.chain_num = 1
		end
		self.chain[self.chain_num].on()
		self.chain_num = self.chain_num + 1
	end
	
	function cfiret:on()
		if not self.single then
			self:incr_fire()
			if not self.manual then 
				self.timer.SetTimeout(self.delay, function()
					pcall(function()
						self:incr_fire()
					end)
					--User defined/first-up or slowest common/arithmetic mean 
					self.timer.SetTimeout(self.chain[self.chain_num-1].delay or self.delay)
				end			
			end
		else
			--Turn everything on if single-salvo!
			for dex, chain in ipairs(self.chain) do
				chain.on()
			end
		end
	end
		
	function cfiret:off()
		--Kill our cfire timer and turn everything in the chains off
		self.timer.Kill()
		for dex, chain in ipairs(self.chain) do
			chain.off()
		end
	end
		
	cfiret.chain_num = 1
	cfiret.chain = chain
	--Base commands vanish, so nobody gets to bind. Instead, we'll alias them to human-readable commands
	RegisterUserCommand(("__cfire__%d__base__on"):format(cfire), function() cfires[cfire]:on() end)
	RegisterUserCommand(("__cfire__%d__base__off"):format(cfire), function() cfires[cfire]:off() end)
	RegisterUserCommand(("__cfire__%d__base__salvo__toggle"):format(cfire), function() cf.ToggleSingleSalvo(cfire) end)
	gkpc(("alias +cfire%d __cfire__%d__base__on"):format(cfire, cfire))
	gkpc(("alias -cfire%d __cfire__%d__base__off"):format(cfire, cfire))
	gkpc(("alias cfire%d_salvo_toggle __cfire__%d__base__salvo__toggle"):format(cfire, cfire))
	
end

function cf.WriteChains()
--dear god what the fuck
end

function cf.InitCfires()
	cf.LoadCfires()
	for dex, cfire in pairs(cfires) do
		cfire.timer = Timer()
	end
end
--Configures ship ports as necessary
function cf.UpdatePorts()

end

function cf.CalcAutoDelay()
	local delay = 0
	local port_num = GetActiveShipNumAddonPorts() -1 --dealing with engine via subtraction, yay!
	local ports = {}
	local ports_same = -1
	local slowest_port
	for i=2, port_num do
		port_type = GetActiveShipPortInfo(i).type
		if(port_type == 0 or port_type == 1) then
			ports[i] = cf.ParseWeaponDelay(portid)
			if(ports_same == -1) then
				ports_same = true
				slowest_port = ports[i]
			elseif ports[i] ~= slowest_port then 
				ports_same = false 
				if ports[i] < slowest_port then slowest_port = ports[i] end
			end
		end
		i = i+1
	end
	
	--If not different, just send this back
	if ports_same then return ports[1] end
	--If told to use arithmetic mean, do so
	if cf.use_mean then
		for dex, port_delay in ipairs(ports) do
			delay = delay + port_delay
		end
		return delay/#ports
	end
	--Else use slowest_port
	return slowest_port
end

function cf.ParseWeaponDelay(portid)
	--Does as above. Returns minimum delay if not found
	local _, _, _, _, _, desc1, desc2 = GetInventoryItemInfo(GetActiveShipItemIDAtPort(portid))
	local delay = tonumber(tcs.desc1:match("Delay: -([%d%.]+)s") or tcs.desc2:match("Delay: -([%d%.]+)s"))
	return delay or cf.MIN_DELAY
end

--Reads and loads cvars in a standardish way
--Maybe convert all plugins to using this someday?
--Cvars format:
-- <plugtable>.cvars = { cvar = {"savename",<current_value>,<default_value>}, ... }
-- Function takes care of decision to use Int/String when Read/Write
function tcs.SavePluginSettings(cvars)
	for cvar, data in pairs(cvars) do
		--Need to check if integer to use WriteInt
		if(type(data[3]) == "number" and data[3]%1==0) then
			gkini.WriteInt("tcs", data[1], tonumber(data[2]))
		elseif(type(data[3]) == "boolean") then
			gkini.WriteInt("tcs", data[1], data[2] and 1 or 0)
		else
			gkini.WriteString("tcs", data[1], tostring(data[2]))
		end
	end
end

function tcs.LoadPluginSettings(cvars)
	for cvar, data in pairs(cvars) do 
		if(type(data[3]) == "number" and data[3]%1==0) then
			data[2] = gkini.ReadInt("tcs", data[1], data[3])
		elseif(type(data[3]) == "boolean") then
			data[2] = gkini.ReadInt("tcs", data[1], data[3] and 1 or 0)==1
		else
			data[2] = gkini.ReadString("tcs", data[1], tostring(data[3]))
		end
	end
end
			
		