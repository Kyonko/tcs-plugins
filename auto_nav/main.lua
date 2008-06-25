--tcs.autonav module. Original tcs.autonav code, Scuba Steve. 
--Colorization improvements and simplification goes to Mad Miner Moda

tcs.autonav = {}
tcs.autonav.bold = '\127FFFFFF'
tcs.autonav.follow = gkini.ReadInt('tcs','autonav.follow', 0)
tcs.autonav.verbose = gkini.ReadInt("tcs", "autonav.verbose", 1)


function tcs.autonav:OnEvent(event, data)
	if (event == "CHAT_MSG_SECTORD_SECTOR") and (tcs.autonav.follow == 1) then
		local name = GetTargetInfo()
		if not name then return end
		local msg = data['msg']
		
		if msg:match(name) then
			tcs.autonav.system, tcs.autonav.sector = msg:match("jumped to (.*) System, Sector (.*)")
			if tcs.autonav.system then
				tcs.autonav.system = SystemNames[SystemNames[(tcs.autonav.system:match('(.+) ') or tcs.autonav.system):lower()]]
				if tcs.autonav.system then
					NavRoute.clear()
					NavRoute.add(tcs.autonav.system..' '..tcs.autonav.sector)
					if tcs.autonav.verbose then
						print (tcs.autonav.bold..'Following: '..name..'. Jump when ready.')
					end
				end
			end
		end
	end
end

RegisterEvent(tcs.autonav, "CHAT_MSG_SECTORD_SECTOR")
local verbt = iup.stationtoggle{action=function(_,v)
									if v == 1 then
										tcs.autonav.verbose = 1
										gkini.WriteInt("tcs", "autonav.verbose", 1)
									elseif v == 0 then
										tcs.autonav.verbose = 0
										gkini.WriteInt("tcs", "autonav.verbose", 0)
									end
									return
								end}

function tcs.autonav.state(_,v)
	if v == 1 then
		tcs.autonav.follow = 1
		gkini.WriteInt("tcs", "autonav.follow", 1)
	elseif v == 0 then
		tcs.autonav.follow = 0
		gkini.WriteInt("tcs", "autonav.follow", 0)
	elseif v == -1 then
		return tcs.IntToToggleState(tcs.autonav.follow)
	end
	return
end
local closeb = iup.stationbutton{title="Close",action=function() 
											tcs.autonav.conf:hide()
											ShowDialog(tcs.ui.confdlg,iup.CENTER, iup.CENTER)
										end}
local elem = {
			iup.hbox{verbt, iup.fill{3}, iup.label{title="Notify when route is mapped"}},
			iup.hbox{iup.fill{},closeb}
		}

tcs.autonav.conf = tcs.ConfigConstructor("TCS AutoNav Config", elem, {defaultesc = closeb})
function tcs.autonav.conf:init()
	verbt.value = tcs.IntToToggleState(tcs.autonav.verbose)
	return
end
tcs.ProvideConfig("Autonav", tcs.autonav.conf,"Plots a course to follow your target when they jump/warp.",tcs.autonav.state)