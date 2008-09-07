tcs.mf.ui = {}  --The help dialog, nice and easy to find/edit 
tcs.mf.ui.halpmsg = "Welcome to Make Friends, the radar customization applet!\n\n\tThe main window lets you select what overall groups/factions appear red or green on your radar. If the toggle is colored red, it will appear red on your radar. Likewise if the toggle is colored green. \"Groups\" toggles take precedence over \"Factions\" toggles- namely, if you have NPC's set as friendly/green, then you can't turn any NPC's red no matter what factions you select below. However, there are toggles to force certain NPC's to be always hostile(strikeforces and station guards). \n\n\tThe Friends and Enemies lists windows allows you to specify people or guilds who are always green or always red on radar, respectively. The enemies list takes precedence over the friends list, so any person or guild on the enemies list is always red even if you have them put down in the friends list eighty times. To ignore your friends and enemies lists, for Nation War or some other team event, check the relevant toggles in the main window. Click on the \"Edit Lists\" button to access the edits for manual editing of these lists. Use the \"Edit People Lists\" button to manage individual players, and the \"Edit Guild Lists\" to manage guilds. Do not use quotes when entering players who have more than one word in their name, and on the guilds list, only use the acronym of a guild when adding entries.\n\n\tThe toggles on the bottom-left of the main window are used, respectively, to:\n\t\t- Set all station guards as hostile\n\t\t- Set all strike forces as hostile\n\t\t- Pretend your enemy players list is empty\n\t\t- Pretend your enemy guilds list is empty\n\t\t- Pretend your friendly players list is empty\n\t\t- Pretend your friendly guilds list is empty\n\t\t- Take a player\'s faction standing into account when showing them on the radar\n\t\t- If you are hit by another player they will be red for the amount of time displayed\n\t\tin the box, and if you hit another player, your CURRENT TARGET will be red for\n\t\thowever many minutes are displayed in the box\n\n\tThe Save Presets button will prompt you for a name to save your current toggle settings as. WARNING: Save Presets button will overwrite presets without warning. \n\n\tEdit Presets allows you to load or delete presets, or load the \'current\' defaults. If you have no presets or have just loaded the default presets, any changes you make to the toggles in the main window will be reflected in the default preset once you hit \"OK\". It is suggested that you make the defaults a setting you usually fly around as, and use presets for special circumstances(such as events).\n\n\tLastly, hit \"OK\" to save everything and all that good stuff.\n\n\n\nCredits:\nWritten by Scuba Steve 9.0.\nVersion 1.3.1 modified by raybondo.\nAlertMachine interface created from modified whois code written by Eonis Jannar.\nHelpfile for original MF v1.5.0 updated by Miharu."

--Main dialog box
tcs.mf.ui.NPC = iup.stationtoggle{ title = "NPC\'s", fgcolor = "255 0 0"}
tcs.mf.ui.guild = iup.stationtoggle{ title = "Guild Members", fgcolor = "255 0 0"}
tcs.mf.ui.group = iup.stationtoggle{ title = "Group Members", fgcolor = "255 0 0"}
tcs.mf.ui.buddies = iup.stationtoggle{ title = "Buddies", fgcolor = "255 0 0"}
tcs.mf.ui.serco = iup.stationtoggle{ title = "Serco Dominion", fgcolor = "255 0 0" }
tcs.mf.ui.itani = iup.stationtoggle{ title = "Itani Nation", fgcolor = "255 0 0" }
tcs.mf.ui.uit = iup.stationtoggle{ title = "Union of Independent Territories", fgcolor = "255 0 0" }
tcs.mf.ui.aeolus = iup.stationtoggle{ title = "Aeolus Trading Prefectorate", fgcolor = "255 0 0" }
tcs.mf.ui.xangxi = iup.stationtoggle{ title = "Xang Xi Automated Systems", fgcolor = "255 0 0" }
tcs.mf.ui.biocom = iup.stationtoggle{ title = "Biocom Industries", fgcolor = "255 0 0" }
tcs.mf.ui.ineubis = iup.stationtoggle{ title = "Ineubis Defense Research", fgcolor = "255 0 0" }
tcs.mf.ui.valent = iup.stationtoggle{ title = "Valent Robotics", fgcolor = "255 0 0" }
tcs.mf.ui.axia = iup.stationtoggle{ title = "Axia Technology Corp", fgcolor = "255 0 0" }
tcs.mf.ui.corvus = iup.stationtoggle{ title = "Corvus Prime", fgcolor = "255 0 0" }
tcs.mf.ui.tunguska = iup.stationtoggle{ title = "Tunguska Heavy Mining Concern", fgcolor = "255 0 0" }
tcs.mf.ui.orion = iup.stationtoggle{ title = "Orion Heavy Manufacturing", fgcolor = "255 0 0" }
tcs.mf.ui.unaligned = iup.stationtoggle{ title = "Unaligned", fgcolor = "255 0 0" }
tcs.mf.ui.tpg = iup.stationtoggle { title = "TPG Corporation", fgcolor = "255 0 0" }
tcs.mf.ui.statg = iup.stationtoggle { title = "Set Station Guards Hostile", fgcolor = "255 255 255" }
tcs.mf.ui.sf = iup.stationtoggle { title = "Set Strike Forces Hostile", fgcolor = "255 255 255" }
tcs.mf.ui.igfriend = iup.stationtoggle { title = "Ignore Friend Players List", fgcolor = "255 255 255" }
tcs.mf.ui.igenemy = iup.stationtoggle { title = "Ignore Enemy Players List", fgcolor = "255 255 255" }
tcs.mf.ui.igfriendguild = iup.stationtoggle { title = "Ignore Friend Guilds List", fgcolor = "255 255 255" }
tcs.mf.ui.igenemyguild = iup.stationtoggle { title = "Ignore Enemy Guilds List", fgcolor = "255 255 255" }
tcs.mf.ui.flaghostile = iup.stationtoggle { title = "Set hostiles red for ", fgcolor = "255 255 255" }
tcs.mf.ui.flaghostiletext = iup.text { value = "", size = "50x" }
tcs.mf.ui.considerstanding = iup.stationtoggle { title = "Consider Faction Standings.", fgcolor = "255 255 255" }

tcs.mf.ui.groupstitle = iup.label { title = "Groups" }
tcs.mf.ui.factionstitle = iup.label { title = "Factions" }
tcs.mf.ui.halpb = iup.stationbutton { title = "Help", action= function() StationHelpDialog:Open(tcs.mf.ui.halpmsg) end}
tcs.mf.ui.makefriendsb = iup.stationbutton { title = "OK" }
tcs.mf.ui.closeb = iup.stationbutton { title = "Close" }
tcs.mf.ui.listsopenb = iup.stationbutton { title = "Edit Lists", expand = "HORIZONTAL" }
tcs.mf.ui.savepresetb = iup.stationbutton { title = "Save as Preset"}
tcs.mf.ui.presetsb = iup.stationbutton { title = "Edit Presets"}
tcs.mf.ui.fandeopenb = iup.stationbutton { title = "Edit People Lists", expand = "HORIZONTAL" }
tcs.mf.ui.guildopenb = iup.stationbutton { title = "Edit Guild Lists", expand = "HORIZONTAL" }
tcs.mf.ui.titlepadding = iup.fill {}
tcs.mf.ui.groupsspacer = iup.fill {}
tcs.mf.ui.factionsspacer = iup.fill { size = "20"}

--[[tcs.mf.ui.mainbox = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox {]]
			--[[iup.hbox {
				tcs.mf.ui.titlepadding,
				tcs.mf.ui.title,
				iup.fill {},
				tcs.mf.ui.halpb,
			},]]
local elems = {
			tcs.mf.ui.groupstitle,
			iup.hbox {
				iup.vbox{
					tcs.mf.ui.guild,
					tcs.mf.ui.buddies
				},
				tcs.mf.ui.groupsspacer,
				iup.vbox{
					tcs.mf.ui.group,
					tcs.mf.ui.NPC
				},
				iup.fill{}
,
			},
			tcs.mf.ui.factionstitle,
			iup.hbox {
				iup.vbox{
					tcs.mf.ui.itani,
					tcs.mf.ui.uit,
					tcs.mf.ui.valent,
					tcs.mf.ui.biocom,
					tcs.mf.ui.corvus,
					tcs.mf.ui.aeolus,
					tcs.mf.ui.tunguska,
				},
				tcs.mf.ui.factionsspacer,
				iup.vbox{
					tcs.mf.ui.serco,
					tcs.mf.ui.tpg,
					tcs.mf.ui.axia,
					tcs.mf.ui.orion,
					tcs.mf.ui.xangxi,
					tcs.mf.ui.ineubis,
					tcs.mf.ui.unaligned,
				},
			},
			iup.fill { size = "40" },
			iup.hbox{
				iup.vbox {
					tcs.mf.ui.statg,
					tcs.mf.ui.sf,
					tcs.mf.ui.igenemy,
					tcs.mf.ui.igenemyguild,
					tcs.mf.ui.igfriend,
					tcs.mf.ui.igfriendguild,
					tcs.mf.ui.considerstanding,
					iup.hbox {
						tcs.mf.ui.flaghostile,
						tcs.mf.ui.flaghostiletext,
						iup.label { title = " mins."}
					}
				},
				iup.fill {},
				iup.vbox {
					iup.fill{},
					tcs.mf.ui.savepresetb,
					tcs.mf.ui.presetsb;
				}
			},
			iup.fill {},
			iup.hbox {
				tcs.mf.ui.halpb,
				tcs.mf.ui.fandeopenb,
				tcs.mf.ui.guildopenb,
				tcs.mf.ui.makefriendsb,
				tcs.mf.ui.closeb
			};
			alignment = "ACENTER"
		}
	--[[}
}]]
		
tcs.mf.ui.dlg = tcs.ConfigConstructor("MakeFriends Config", elems, {defaultesc=tcs.mf.ui.closeb})

function tcs.mf.ui.dlg:init()
	tcs.mf.GetFriends()
	iup.Map(tcs.mf.ui.dlg)
	local closesavewidth = tcs.GetElementSize(tcs.mf.ui.closeb) + tcs.GetElementSize(tcs.mf.ui.makefriendsb)
	tcs.mf.ui.savepresetb.size = closesavewidth .. "x"
	tcs.mf.ui.presetsb.size = closesavewidth .. "x"
	tcs.mf.ui.groupsspacer.size = tostring(tcs.GetElementSize(tcs.mf.ui.uit) + tcs.GetElementSize(tcs.mf.ui.factionsspacer) - tcs.GetElementSize(tcs.mf.ui.guild))
	iup.Refresh(tcs.mf.ui.dlg)
end

function tcs.mf.close()
	HideDialog(tcs.mf.ui.presetsdlg)
	HideDialog(tcs.mf.ui.fandedlg)
	HideDialog(tcs.mf.ui.dlg)
	ShowDialog(tcs.ui.confdlg)
end

function tcs.mf.ui.closeb:action()
	tcs.mf.close()
end


function tcs.mf.ui.fandeopenb:action()
	tcs.mf.ui.fandedlgopen()
end

function tcs.mf.ui.guildopenb:action()
	tcs.mf.ui.guildlistsdlgopen()
end

function tcs.mf.ui.presetsb:action()
	tcs.mf.ui.presetsdlgopen()
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "NO")
end

function tcs.mf.ui.makefriendsb:action()
	tcs.mf.factions[2] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.serco, "VALUE")) 
	tcs.mf.factions[1] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.itani, "VALUE")) 
	tcs.mf.factions[3] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.uit, "VALUE")) 
	tcs.mf.factions[11] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.aeolus, "VALUE")) 
	tcs.mf.factions[12] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.ineubis, "VALUE")) 
	tcs.mf.factions[6] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.valent, "VALUE")) 
	tcs.mf.factions[8] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.axia, "VALUE")) 
	tcs.mf.factions[5] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.biocom, "VALUE"))
	tcs.mf.factions[4] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.tpg, "VALUE")) 
	tcs.mf.factions[7] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.orion, "VALUE"))
	tcs.mf.factions[9] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.corvus, "VALUE")) 
	tcs.mf.factions[0] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.unaligned, "VALUE")) 
	tcs.mf.factions[10] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.tunguska, "VALUE"))
	tcs.mf.factions[13] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.xangxi, "VALUE")) 
	tcs.mf.FS["Group"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.group, "VALUE"))
	tcs.mf.FS["Guild"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.guild, "VALUE"))
	tcs.mf.FS["Buddy"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.buddies, "VALUE"))
	tcs.mf.FS["NPC"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.NPC, "VALUE"))
	tcs.mf.FS["StatG"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.statg, "VALUE"))
	tcs.mf.FS["SF"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.sf, "VALUE"))
	tcs.mf.FS["igEnemy"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.igenemy, "VALUE"))
	tcs.mf.FS["igFriend"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.igfriend, "VALUE"))
	tcs.mf.FS["igEnemyGuild"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.igenemyguild, "VALUE"))
	tcs.mf.FS["igFriendGuild"] = tcs.ToggleStateToBool(iup.GetAttribute(tcs.mf.ui.igfriendguild, "VALUE"))
	tcs.mf.FS["FlagHostile"] = tcs.ToggleStateToBool(tcs.mf.ui.flaghostile.value)
	tcs.mf.LastAggro.timeout = tcs.mf.ui.flaghostiletext.value * 60
	tcs.mf.FS["ConsiderStanding"] = tcs.ToggleStateToBool(tcs.mf.ui.considerstanding.value)
	tcs.mf.close()
	tcs.mf.SaveSettings(tcs.mf.curpreset)
end
--Guild Lists Dialog
tcs.mf.ui.guildlistscloseb = iup.stationbutton { title = "Close & Save", expand = "HORIZONTAL" }
tcs.mf.ui.blacklist = iup.pdasubsubsublist { value = 0, size = "x160", expand = "HORIZONTAL" }
tcs.mf.ui.whitelist = iup.pdasubsubsublist { value = 0, size = "x160", expand = "HORIZONTAL" }
tcs.mf.ui.whitetoblackb = iup.stationbutton { title = ">" }
tcs.mf.ui.blacktowhiteb = iup.stationbutton { title = "<" }
tcs.mf.ui.addwhite = iup.stationbutton { title = "Add as Friendly Guild", expand = "HORIZONTAL" }
tcs.mf.ui.addblack = iup.stationbutton { title = "Add as Enemy Guild", expand = "HORIZONTAL" }
tcs.mf.ui.whiteentry = iup.text { value = "", expand = "HORIZONTAL"}
tcs.mf.ui.blackentry = iup.text { value = "", expand = "HORIZONTAL"}
tcs.mf.ui.removewhite = iup.stationbutton { title = "Remove Friendlly Guild", expand = "HORIZONTAL"}
tcs.mf.ui.removeblack = iup.stationbutton { title = "Remove Enemy Guild", expand = "HORIZONTAL"}
tcs.mf.ui.whitelistcomp = iup.vbox {
	iup.label { title = "Friendly Guilds"},
	tcs.mf.ui.whitelist,
	tcs.mf.ui.whiteentry,
	tcs.mf.ui.addwhite,
	tcs.mf.ui.removewhite;
	alignment = "ACENTER"
}
tcs.mf.ui.blacklistcomp = iup.vbox {
	iup.label { title = "Enemy Guilds"},
	tcs.mf.ui.blacklist,
	tcs.mf.ui.blackentry,
	tcs.mf.ui.addblack,
	tcs.mf.ui.removeblack;
	alignment = "ACENTER"
}

tcs.mf.ui.xferbuttons = iup.vbox {
	iup.fill{},
	tcs.mf.ui.whitetoblackb,
	tcs.mf.ui.blacktowhiteb,
	iup.fill{}
}

tcs.mf.ui.guildlistsmain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox{
			iup.hbox {
				tcs.mf.ui.whitelistcomp,
				tcs.mf.ui.xferbuttons,
				tcs.mf.ui.blacklistcomp
			},
			iup.fill{},
			iup.hbox {
				tcs.mf.ui.guildlistscloseb;
			};
			alignment = "ACENTER"
		}
	}
}

tcs.mf.ui.guildlistsdlg = iup.dialog {
	tcs.mf.ui.guildlistsmain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	MODAL = "YES"
}

function tcs.mf.ui.guildlistsdlgopen()
	for key, value in pairs(tcs.mf.friendguildlist) do
		tcs.PushListItem(tcs.mf.ui.whitelist, value)
	end
	for key, value in pairs(tcs.mf.enemyguildlist) do
		tcs.PushListItem(tcs.mf.ui.blacklist, value)
	end	
	ShowDialog(tcs.mf.ui.guildlistsdlg)
end

function tcs.mf.ui.guildlistscloseb:action()
	tcs.mf.enemyguildlist = {}
	tcs.mf.friendguildlist = {}
	local nam = ""
	local listcounter = tcs.GetListSize(tcs.mf.ui.whitelist)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(tcs.mf.ui.whitelist, 1)
		table.insert(tcs.mf.friendguildlist, nam)
		listcounter = listcounter - 1

	end
	listcounter = tcs.GetListSize(tcs.mf.ui.blacklist)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(tcs.mf.ui.blacklist, 1)
		table.insert(tcs.mf.enemyguildlist, nam)
		listcounter = listcounter - 1
	end
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "FriendGuilds", spickle(tcs.mf.friendguildlist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "EnemyGuilds", spickle(tcs.mf.enemyguildlist))
	HideDialog(tcs.mf.ui.guildlistsdlg)
	tcs.mf.ui.dlg.active = "YES"
end

function tcs.mf.ui.addwhite:action()
	if(not strip_whitespace(tcs.mf.ui.whiteentry.value)) then 
		tcs.mf.ui.whiteentry.value = ""
		return 
	end
	tcs.PushListItem(tcs.mf.ui.whitelist, tcs.mf.ui.whiteentry.value)
	tcs.mf.ui.whiteentry.value = ""
end

function tcs.mf.ui.addblack:action()
	if(not strip_whitespace(tcs.mf.ui.blackentry.value)) then
		tcs.mf.ui.blackentry = ""
		return
	end
	tcs.PushListItem(tcs.mf.ui.blacklist, tcs.mf.ui.blackentry.value)
	tcs.mf.ui.blackentry.value = ""
end

function tcs.mf.ui.removewhite:action()
	tcs.RemoveSelectedListItem(tcs.mf.ui.whitelist)
end

function tcs.mf.ui.removeblack:action()
	tcs.RemoveSelectedListItem(tcs.mf.ui.blacklist)
end

function tcs.mf.ui.whitetoblackb:action()
	tcs.MoveSelectedListItem(tcs.mf.ui.whitelist, tcs.mf.ui.blacklist)
end

function tcs.mf.ui.blacktowhiteb:action()
	tcs.MoveSelectedListItem(tcs.mf.ui.blacklist, tcs.mf.ui.whitelist)
end
--People Lists Dialog
tcs.mf.ui.fandecloseb = iup.stationbutton{title = "Close & Save", expand = "HORIZONTAL"}
tcs.mf.ui.enemybox = iup.pdasubsubsublist { value = 0, size = "x350", expand = "HORIZONTAL" }
tcs.mf.ui.leftbutton = iup.stationbutton { title = "<" }
tcs.mf.ui.rightbutton = iup.stationbutton { title = ">" }
tcs.mf.ui.friendlybox = iup.pdasubsubsublist { value = 0, size = "x350", expand = "HORIZONTAL" }
tcs.mf.ui.friendentrybox = iup.text { value = "", expand = "HORIZONTAL"}
tcs.mf.ui.addfriend = iup.stationbutton { title = "Add as Friend", expand = "HORIZONTAL" }
tcs.mf.ui.removeselectedfriend = iup.stationbutton { title = "Remove Selected Friend", expand = "HORIZONTAL" }
tcs.mf.ui.enemyentrybox = iup.text {value = "", expand = "HORIZONTAL"}
tcs.mf.ui.addenemy = iup.stationbutton { title = "Add as Enemy", expand = "HORIZONTAL" }
tcs.mf.ui.removeselectedenemy = iup.stationbutton { title = "Remove Selected Enemy", expand = "HORIZONTAL" }
tcs.mf.ui.addremovefriend = iup.vbox {
	iup.label{title = "Friendlies"},
	tcs.mf.ui.friendlybox,
	tcs.mf.ui.friendentrybox,
	tcs.mf.ui.addfriend,
	tcs.mf.ui.removeselectedfriend;
	alignment = "ACENTER" 
}
tcs.mf.ui.addremoveenemy = iup.vbox {
	iup.label{title = "Enemies"},
	tcs.mf.ui.enemybox,
	tcs.mf.ui.enemyentrybox,
	tcs.mf.ui.addenemy,
	tcs.mf.ui.removeselectedenemy;
	alignment = "ACENTER" 
}
tcs.mf.ui.transferbuttons = iup.vbox {
	iup.fill{},
	tcs.mf.ui.rightbutton,
	tcs.mf.ui.leftbutton,
	iup.fill{}
}
tcs.mf.ui.fandemid = iup.hbox {
	tcs.mf.ui.addremovefriend,
	tcs.mf.ui.transferbuttons,
	tcs.mf.ui.addremoveenemy;
	alignment = "ACENTER"
}
tcs.mf.ui.fandeentry = iup.vbox {
	tcs.mf.ui.fandemid
}
	
		
tcs.mf.ui.fandemain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox{
			tcs.mf.ui.fandeentry,
			iup.fill{},
			iup.hbox {
				tcs.mf.ui.fandecloseb;
				--size = "490x"
			};
			alignment = "ACENTER"
		}
	}
}

tcs.mf.ui.fandedlg = iup.dialog {
	tcs.mf.ui.fandemain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	MODAL = "YES"
}
tcs.mf.ui.friendnum = 0
tcs.mf.ui.enemynum = 0
function tcs.mf.ui.friendentrybox:action(c)
	if(c == iup.K_TAB) then
		if(strip_whitespace(tcs.mf.ui.friendentrybox.value) == nil) then
			tcs.mf.ui.friendentrybox.value = GetLastPrivateSpeaker()
		end
		local name = TabCompleteName(iup.GetAttribute(tcs.mf.ui.friendentrybox, "VALUE"))
		if(name ~= nil) then
			iup.SetAttribute(tcs.mf.ui.friendentrybox, "VALUE", name)
		end
	end
end

function tcs.mf.ui.fandedlg:k_any(c)
	if(c == iup.K_TAB) then
		return iup.IGNORE
	end
	return iup.DEFAULT
end

function tcs.mf.ui.enemyentrybox:action(c)
	if(c == iup.K_TAB) then
		if(strip_whitespace(tcs.mf.ui.enemyentrybox.value) == nil) then
			tcs.mf.ui.enemyentrybox.value = GetLastPrivateSpeaker() or ""
		end
		local name = TabCompleteName(iup.GetAttribute(tcs.mf.ui.enemyentrybox, "VALUE"))
		if(name ~= nil) then
			iup.SetAttribute(tcs.mf.ui.enemyentrybox, "VALUE", name)
		end
	end
end


function tcs.mf.ui.addfriend:action()
	local toadd = tcs.mf.ui.friendentrybox.value
	if(strip_whitespace(toadd) == nil) then 
		tcs.mf.ui.friendentrybox.value = ""
		return 
	end
	tcs.PushListItem(tcs.mf.ui.friendlybox, toadd)
	tcs.mf.ui.friendentrybox.value = ""
	
end
function tcs.mf.ui.addenemy:action()

	local toadd = tcs.mf.ui.enemyentrybox.value
	if(strip_whitespace(toadd) == nil) then
		tcs.mf.ui.enemyentrybox.value = ""
		return 
	end
	tcs.PushListItem(tcs.mf.ui.enemybox, toadd)
	tcs.mf.ui.enemyentrybox.value = ""

end
function tcs.mf.ui.leftbutton:action()
	tcs.MoveSelectedListItem(tcs.mf.ui.enemybox, tcs.mf.ui.friendlybox)

end
function tcs.mf.ui.removeselectedenemy:action()
	tcs.RemoveSelectedListItem(tcs.mf.ui.enemybox)
end
		
function tcs.mf.ui.removeselectedfriend:action()
	tcs.RemoveSelectedListItem(tcs.mf.ui.friendlybox)
end
function tcs.mf.ui.rightbutton:action()
	tcs.MoveSelectedListItem(tcs.mf.ui.friendlybox, tcs.mf.ui.enemybox)
end
function tcs.mf.ui.fandedlgopen()
	for key, value in pairs(tcs.mf.friendslist) do
		tcs.PushListItem(tcs.mf.ui.friendlybox, value, tcs.mf.ui.friendnum)
	end
	for key, value in pairs(tcs.mf.enemylist) do
		tcs.PushListItem(tcs.mf.ui.enemybox, value, tcs.mf.ui.enemynum)
	end	
	ShowDialog(tcs.mf.ui.fandedlg)
end

function tcs.mf.ui.fandeclose()
	tcs.mf.enemylist = {}
	tcs.mf.friendslist = {}
	local nam = ""
	local listcounter = tcs.GetListSize(tcs.mf.ui.friendlybox)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(tcs.mf.ui.friendlybox, 1)
		table.insert(tcs.mf.friendslist, nam)
		listcounter = listcounter - 1

	end
	listcounter = tcs.GetListSize(tcs.mf.ui.enemybox)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(tcs.mf.ui.enemybox, 1)
		table.insert(tcs.mf.enemylist, nam)
		listcounter = listcounter - 1
	end
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Friends", spickle(tcs.mf.friendslist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Enemies", spickle(tcs.mf.enemylist))

end

function tcs.mf.ui.fandecloseb:action()
	tcs.mf.ui.fandeclose()
	HideDialog(tcs.mf.ui.fandedlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "YES")
end
--Presets dialog~
tcs.mf.ui.presetscloseb = iup.stationbutton { title = "Close", expand = "HORIZONTAL" }
tcs.mf.ui.presetsbox = iup.pdasubsubsublist { value = 1, size = "250x200", expand = "HORIZONTAL"}
tcs.mf.ui.presetsentrybox = iup.text { value = "", expand = "HORIZONTAL"}
tcs.mf.ui.loadselectedpreset = iup.stationbutton { title = "Load Selected Preset", expand = "HORIZONTAL" }
tcs.mf.ui.removeselectedpreset = iup.stationbutton { title = "Remove Selected Preset", expand = "HORIZONTAL" }
tcs.mf.ui.loaddefaultpreset = iup.stationbutton { title = "Load Default Preset", expand = "HORIZONTAL" }
tcs.mf.ui.savepresetname = iup.text { value = "", expand = "HORIZONTAL" }
tcs.mf.ui.savepresetokb = iup.stationbutton { title = "Save Preset" }
tcs.mf.ui.savepresetnob = iup.stationbutton { title = "Cancel" }


tcs.mf.ui.presetsmain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.hbox{
			iup.vbox{
				tcs.mf.ui.presetsbox,
				alignment = "ACENTER"
			},
			iup.fill{},
			iup.vbox{
				tcs.mf.ui.loadselectedpreset,
				tcs.mf.ui.removeselectedpreset,
				iup.fill{},
				tcs.mf.ui.loaddefaultpreset,
				tcs.mf.ui.presetscloseb;
				alignment = "ACENTER"
			}	
		}
	}
}


tcs.mf.ui.presetsdlg = iup.dialog {
	tcs.mf.ui.presetsmain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	--size = "500x500",
	MODAL = "YES"
}

tcs.mf.ui.savepresetmain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox{
			iup.label { title = "Enter New Preset Name:" },
			tcs.mf.ui.savepresetname,
			iup.hbox {
				iup.fill{},
				tcs.mf.ui.savepresetokb,
				tcs.mf.ui.savepresetnob
			}
		}
	}
}


tcs.mf.ui.savepresetdlg = iup.dialog {
	tcs.mf.ui.savepresetmain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	--size = "500x500",
	MODAL = "YES"
}

function tcs.mf.ui.savepresetnob:action()
	iup.SetAttribute(tcs.mf.ui.savepresetname, "VALUE", "")
	HideDialog(tcs.mf.ui.savepresetdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "YES")
end
function tcs.mf.ui.savepresetokb:action()
	local name = iup.GetAttribute(tcs.mf.ui.savepresetname, "VALUE")
	if(name == "") then
		return
	end
	if(tcs.IsStringInTable(tcs.mf.presets, name) == false) then
		table.insert(tcs.mf.presets, name)
		tcs.mf.SavePresets()
	end
	tcs.mf.SaveSettings(name)
	tcs.mf.curpreset = name
	iup.SetAttribute(tcs.mf.ui.savepresetname, "VALUE", "")
	gkini.WriteString("MakeFriends-"..GetPlayerName() or "", "CurrentPreset", name)
	HideDialog(tcs.mf.ui.savepresetdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "YES")
end
	
function tcs.mf.ui.savepresetb:action()
	iup.SetAttribute(tcs.mf.ui.savepresetname, "VALUE", "")
	ShowDialog(tcs.mf.ui.savepresetdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "NO")
end
function tcs.mf.ui.presetsdlgopen()
	tcs.mf.ui.presetsnum = 0
	for key, value in pairs(tcs.mf.presets) do
		tcs.mf.ui.presetsnum = tcs.mf.ui.presetsnum + 1
		iup.SetAttribute(tcs.mf.ui.presetsbox, "VALUE", tcs.mf.ui.presetsnum)
		iup.SetAttribute(tcs.mf.ui.presetsbox, tostring(tcs.mf.ui.presetsnum), value)
	end
	ShowDialog(tcs.mf.ui.presetsdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "NO")
end

function tcs.mf.ui.loadselectedpreset:action()
	local sel = iup.GetAttribute(tcs.mf.ui.presetsbox, "VO_LISTSEL")
	if(sel == 0) then
		return
	end
	local selpreset = iup.GetAttribute(tcs.mf.ui.presetsbox, tostring(sel))
	if(selpreset ~= nil) then
		tcs.mf.LoadSettings(selpreset)
	end
	tcs.mf.GetFriends()
	gkini.WriteString("MakeFriends-"..GetPlayerName() or "", "CurrentPreset", selpreset)
	HideDialog(tcs.mf.ui.presetsdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "YES")
end

function tcs.mf.ui.removeselectedpreset:action()
	if(iup.GetAttribute(tcs.mf.ui.presetsbox, "VO_LISTSEL") ~= 0) then
		local selection = tostring(iup.GetAttribute(tcs.mf.ui.presetsbox, "VO_LISTSEL"))
		local replacement = iup.GetAttribute(tcs.mf.ui.presetsbox, tostring(tcs.mf.ui.presetsnum))
		iup.SetAttribute(tcs.mf.ui.presetsbox, selection, replacement)
		iup.SetAttribute(tcs.mf.ui.presetsbox, tostring(tcs.mf.ui.presetsnum), nil)
		tcs.mf.ui.presetsnum = tcs.mf.ui.presetsnum - 1
		iup.SetAttribute(tcs.mf.ui.presetsbox, "VALUE", tcs.mf.ui.presetsnum)
	end
end
function tcs.mf.ui.presetscloseb:action()
	tcs.mf.presets = {}
	while(tcs.mf.ui.presetsnum > 0) do
		table.insert(tcs.mf.presets, iup.GetAttribute(tcs.mf.ui.presetsbox, tostring(tcs.mf.ui.presetsnum)))
		iup.SetAttribute(tcs.mf.ui.presetsbox, tostring(tcs.mf.ui.presetsnum), nil)
		tcs.mf.ui.presetsnum = tcs.mf.ui.presetsnum - 1
		iup.SetAttribute(tcs.mf.ui.presetsbox, "VALUE", tcs.mf.ui.presetsnum)
	end
	tcs.mf.SavePresets()
	HideDialog(tcs.mf.ui.presetsdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "YES")
end

function tcs.mf.ui.loaddefaultpreset:action()
	tcs.mf.LoadSettings("Default")
	tcs.mf.GetFriends()
	HideDialog(tcs.mf.ui.presetsdlg)
	iup.SetAttribute(tcs.mf.ui.dlg, "ACTIVE", "YES")
end

-- Copypasta toggle color functions
function tcs.mf.ui.unaligned:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.unaligned, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.unaligned, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.serco:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.serco, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.serco, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.itani:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.itani, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.itani, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.uit:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.uit, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.uit, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.aeolus:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.aeolus, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.aeolus, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.ineubis:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.ineubis, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.ineubis, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.xangxi:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.xangxi, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.xangxi, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.corvus:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.corvus, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.corvus, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.tpg:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.tpg, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.tpg, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.axia:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.axia, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.axia, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.valent:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.valent, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.valent, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.orion:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.orion, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.orion, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.guild:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.guild, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.guild, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.group:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.group, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.group, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.NPC:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.NPC, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.NPC, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.buddies:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.buddies, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.buddies, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.tunguska:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.tunguska, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.tunguska, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.biocom:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.biocom, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(tcs.mf.ui.biocom, "FGCOLOR", "255 0 0")
	end
end

function tcs.mf.ui.statg:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.statg, "FGCOLOR", "255 0 0")
	else
		iup.SetAttribute(tcs.mf.ui.statg, "FGCOLOR", "255 255 255")
	end
end

function tcs.mf.ui.sf:action(v)
	if(v == 1) then
		iup.SetAttribute(tcs.mf.ui.sf, "FGCOLOR", "255 0 0")
	else
		iup.SetAttribute(tcs.mf.ui.sf, "FGCOLOR", "255 255 255")
	end
end
