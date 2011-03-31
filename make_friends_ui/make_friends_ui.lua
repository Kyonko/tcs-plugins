tcs.mf.ui = {} --The help dialog
local mui = tcs.mf.ui --Binding for main UI
mui.halpmsg = "Welcome to Make Friends, the radar customization applet!\n\n\tThe main window lets you select what overall groups/factions appear red or green on your radar. If the toggle is colored red, it will appear red on your radar. Likewise if the toggle is colored green. \"Categories\" toggles and \"NPCs\" controls take precedence over \"Factions\" toggles- namely, if you have certain NPC's or your guildmates set as friendly/green, then you can't turn those NPCs or your guildmates red no matter what factions you configure to be hostile. \n\n\tA note about the \"Conquerable Assets\": MakeFriends doesn't yet have full support to figure out who has the right IFF settings in a conquerable sector, but it can figure out if the turrets hate you or not as long as the relevant key has a location formatted like 'Latos I-8' in the key name. Having MakeFriends treat the turrets \"As Player\" enables this logic. This logic does not affect station guards in conquerable sectors.\n\n\tThe Friends and Enemies lists windows allows you to specify people or guilds who are always green or always red on radar, respectively. The enemies list takes precedence over the friends list, so any person or guild on the enemies list is always red even if you have them put down in the friends list eighty times. To ignore your friends and enemies lists, for Nation War or some other team event, check the relevant toggles in the main window. Click on the \"Edit Lists\" button to access the edits for manual editing of these lists. Use the \"Edit People Lists\" button to manage individual players, and the \"Edit Guild Lists\" to manage guilds. Do not use quotes when entering players who have more than one word in their name, and on the guilds list, only use the acronym of a guild when adding entries.\n\n\tThe toggles on the bottom-left of the main window are used, respectively, to:\n\t\t- Pretend your enemy players list is empty\n\t\t- Pretend your enemy guilds list is empty\n\t\t- Pretend your friendly players list is empty\n\t\t- Pretend your friendly guilds list is empty\n\t\t- Take a player\'s faction standing into account when showing them on the radar\n\t\t- If you are hit by another player they will be red for the amount of time displayed\n\t\tin the box, and if you hit another player, your CURRENT TARGET will be red for\n\t\thowever many minutes are displayed in the box\n\n\tThe Save Presets button will prompt you for a name to save your current toggle settings as. WARNING: Save Presets button will overwrite presets without warning. \n\n\tEdit Presets allows you to load or delete presets, or load the \'current\' defaults. If you have no presets or have just loaded the default presets, any changes you make to the toggles in the main window will be reflected in the default preset once you hit \"OK\". It is suggested that you make the defaults a setting you usually fly around as, and use presets for special circumstances(such as events).\n\n\tLastly, hit \"OK\" to save everything and all that good stuff.\n\n\tFor more advanced users, you can also use the following commands to reset lists of people who have hit you and are thusly marked red.\n\t\t- /tcs makefriends reset player\n\t\t- /tcs makefriends reset npc\n\t\t- /tcs makefriends reset all\n\n\tThe commands are a bit slipshod, but do as they say on the tin. Good luck!\n\n\n\nCredits:\nWritten by Scuba Steve 9.0.\nPre-TCS version 1.3.1 modified by raybondo.\nAlertMachine interface created from modified whois code written by Eonis Jannar.\nHelpfile for Pre-TCS MF v1.5.0 updated by Miharu."

mui.mcontrols = {
	--Only place elements with 'title' as a basic element in this group. Too lazy to actually add in the edge cases. Oh well.
	--NPC = 		{"stationtoggle", title = "NPC\s", args = {fgcolor="255 0 0"}},
	guild = 	{"stationtoggle",{title = "Guild Members",fgcolor = "255 0 0"}},
	group = 	{"stationtoggle",{title = "Group Members",fgcolor="255 0 0"}},
	buddies = 	{"stationtoggle",{title = "Buddies",fgcolor="255 0 0"}},
	serco = 	{"stationtoggle", {title = "Serco Dominion",fgcolor="255 0 0" }},
	itani = 	{"stationtoggle", {title = "Itani Nation",fgcolor="255 0 0" }},
	uit = 		{"stationtoggle", {title = "Union of Independent Territories",fgcolor="255 0 0" }},
	aeolus = 	{"stationtoggle", {title = "Aeolus Trading Prefectorate",fgcolor="255 0 0" }},
	xangxi = 	{"stationtoggle", {title = "Xang Xi Automated Systems",fgcolor="255 0 0" }},
	biocom = 	{"stationtoggle", {title = "Biocom Industries",fgcolor="255 0 0" }},
	ineubis = 	{"stationtoggle", {title = "Ineubis Defense Research",fgcolor="255 0 0" }},
	valent = 	{"stationtoggle", {title = "Valent Robotics",fgcolor="255 0 0" }},
	axia = 		{"stationtoggle", {title = "Axia Technology Corp",fgcolor="255 0 0" }},
	corvus = 	{"stationtoggle", {title = "Corvus Prime",fgcolor="255 0 0" }},
	tunguska =	{"stationtoggle", {title = "Tunguska Heavy Mining Concern",fgcolor="255 0 0" }},
	orion = 	{"stationtoggle",{title = "Orion Heavy Manufacturing", fgcolor="255 0 0" }},
	unaligned=	{"stationtoggle", {title = "Unaligned", fgcolor="255 0 0" }},
	tpg = 		{"stationtoggle",{title = "TPG Corporation", fgcolor="255 0 0" }},
	
	hivestat = 	{"label", {title = "Hivebots", fgcolor="255 204 241"}},
	statgstat = {"label", {title = "Station Guards",fgcolor="255 204 241"}},
	sfstat = 	{"label", {title = "Strike Force", fgcolor="255 204 241"}},
	borderstat= {"label", {title = "Wormhole Turrets", fgcolor="255 204 241"}},
	conqstat = 	{"label", {title = "Conquerable Assets", fgcolor="255 204 241"}},
	normstat = 	{"label", {title = "Other NPCs", fgcolor="255 204 241"}},
	hive = 		{"stationsubsublist", {dropdown = "YES", [1] = "\127FFCCF1As Player", [2] = "\127ff0000Hostile", [3] = "\12700ff00Friendly", [4] = "\127ffffffUse Faction Standing Only"}},
	statg = 	{"stationsubsublist", {dropdown = "YES", [1] = "\127FFCCF1As Player", [2] = "\127ff0000Hostile", [3] = "\12700ff00Friendly", [4] = "\127ffffffUse Faction Standing Only"}},
	sf = 		{"stationsubsublist", {dropdown = "YES", [1] = "\127FFCCF1As Player", [2] = "\127ff0000Hostile", [3] = "\12700ff00Friendly", [4] = "\127ffffffUse Faction Standing Only"}},
	border =	{"stationsubsublist", {dropdown = "YES", [1] = "\127FFCCF1As Player", [2] = "\127ff0000Hostile", [3] = "\12700ff00Friendly", [4] = "\127ffffffUse Faction Standing Only"}},
	conq = 		{"stationsubsublist", {dropdown = "YES", [1] = "\127FFCCF1As Player", [2] = "\127ff0000Hostile", [3] = "\12700ff00Friendly", [4] = "\127ffffffUse Faction Standing Only"}},
	norm = 		{"stationsubsublist", {dropdown = "YES", [1] = "\127FFCCF1As Player", [2] = "\127ff0000Hostile", [3] = "\12700ff00Friendly", [4] = "\127ffffffUse Faction Standing Only"}},
	
	igfriend =	{"stationtoggle",{ title = "Ignore Friend Players List",fgcolor="255 255 255" }},
	igenemy = 	{"stationtoggle", {title = "Ignore Enemy Players List",fgcolor="255 255 255" }},
	igfriendguild = 	{"stationtoggle", {title = "Ignore Friend Guilds List",fgcolor="255 255 255" }},
	igenemyguild = 		{"stationtoggle", {title = "Ignore Enemy Guilds List",fgcolor="255 255 255" }},
	flaghostile = 		{"stationtoggle", {title = "Set hostiles red for ",fgcolor="255 255 255" }},
	considerstanding =	{"stationtoggle", {title = "Consider Faction Standings.", fgcolor = "255 255 255" }},
	groupstitle = 		{"label", {title="Categories"}},
	factionstitle = 	{"label", {title = "Factions"} },
	npcstitle =			{"label", {title = "NPCs"} },
	halpb = 			{"stationbutton", {title = "Help"}},
	makefriendsb = 		{"stationbutton", {title = "OK"} },
	closeb = 			{"stationbutton", {title = "Close"}},
	listsopenb = 		{"stationbutton", {title = "Edit Lists", expand = "HORIZONTAL" }},
	savepresetb = 		{"stationbutton", {title = "Save as Preset"}},
	presetsb = 			{"stationbutton", {title = "Edit Presets"}},
	fandeopenb = 		{"stationbutton", {title = "Edit People Lists", expand = "HORIZONTAL" }},
	guildopenb = 		{"stationbutton", {title = "Edit Guild Lists", expand = "HORIZONTAL" }}
}

tcs.BatchAddControls(mui.mcontrols, mui)

--TODO: Move this into batch table above and convert values not in batch tables below to batch tables
mui.flaghostiletext = iup.text { value = "", size = "50x" }
mui.titlepadding = iup.fill {}
mui.groupsspacer = iup.fill {}
mui.npcsspacer = iup.fill {}
mui.factionsspacer = iup.fill { size = "20"}

local elems = {
	mui.groupstitle,
	iup.hbox {
		iup.vbox{
			mui.guild,
			mui.buddies
		},
		mui.groupsspacer,
		iup.vbox{
			mui.group,
			--mui.NPC
		},
		iup.fill{},
	},
	mui.npcstitle,
	iup.hbox {
		iup.fill{size="17"},
		iup.vbox{
			mui.hivestat,
			mui.statgstat,
			mui.sfstat,
			mui.conqstat,
			mui.borderstat,
			mui.normstat
		},
		mui.npcsspacer,
		iup.vbox{
			mui.hive,
			mui.statg,
			mui.sf,
			mui.conq,
			mui.border,
			mui.norm
		},
		iup.fill{}
	},
	mui.factionstitle,
	iup.hbox {
		iup.vbox{
			mui.itani,
			mui.uit,
			mui.valent,
			mui.biocom,
			mui.corvus,
			mui.aeolus,
			mui.tunguska,
		},
		mui.factionsspacer,
		iup.vbox{
			mui.serco,
			mui.tpg,
			mui.axia,
			mui.orion,
			mui.xangxi,
			mui.ineubis,
			mui.unaligned,
		},
		iup.fill{}
	},
	iup.fill { size = "40" },
	iup.hbox{
		iup.vbox {
			mui.igenemy,
			mui.igenemyguild,
			mui.igfriend,
			mui.igfriendguild,
			mui.considerstanding,
			iup.hbox {
				mui.flaghostile,
				mui.flaghostiletext,
				iup.label { title = " mins."}
			}
		},
		iup.fill {},
		iup.vbox {
			iup.fill{},
			mui.savepresetb,
			mui.presetsb;
		}
	},
	iup.fill {},
	iup.hbox {
		mui.halpb,
		mui.fandeopenb,
		mui.guildopenb,
		mui.makefriendsb,
		mui.closeb
	};
	alignment = "ACENTER"
}

mui.dlg = tcs.ConfigConstructor("MakeFriends Config", elems, {defaultesc=tcs.mf.ui.closeb})

function mui.dlg:init()
	tcs.mf.GetFriends()
	iup.Map(mui.dlg)
	local closesavewidth = tcs.GetElementSize(mui.closeb) + tcs.GetElementSize(mui.makefriendsb)
	mui.savepresetb.size = closesavewidth .. "x"
	mui.presetsb.size = closesavewidth .. "x"
	mui.groupsspacer.size = tostring(tcs.GetElementSize(mui.uit) + tcs.GetElementSize(mui.factionsspacer) - tcs.GetElementSize(mui.guild))
	iup.Refresh(mui.dlg)
end

function tcs.mf.close()
	HideDialog(mui.presetsdlg)
	HideDialog(mui.fandedlg)
	HideDialog(mui.dlg)
	tcs.cli_menu_adjust(tcs.mf.name)
end

function mui.closeb:action()
	tcs.mf.close()
end

function mui.halpb:action()
	StationHelpDialog:Open(mui.halpmsg)
end


function mui.fandeopenb:action()
	mui.fandedlgopen()
end

function mui.guildopenb:action()
	mui.guildlistsdlgopen()
end

function mui.presetsb:action()
	mui.presetsdlgopen()
	iup.SetAttribute(mui.dlg, "ACTIVE", "NO")
end

function mui.makefriendsb:action()
	tcs.mf.factions[2] = tcs.ToggleStateToBool(iup.GetAttribute(mui.serco, "VALUE")) 
	tcs.mf.factions[1] = tcs.ToggleStateToBool(iup.GetAttribute(mui.itani, "VALUE")) 
	tcs.mf.factions[3] = tcs.ToggleStateToBool(iup.GetAttribute(mui.uit, "VALUE")) 
	tcs.mf.factions[11] = tcs.ToggleStateToBool(iup.GetAttribute(mui.aeolus, "VALUE")) 
	tcs.mf.factions[12] = tcs.ToggleStateToBool(iup.GetAttribute(mui.ineubis, "VALUE")) 
	tcs.mf.factions[6] = tcs.ToggleStateToBool(iup.GetAttribute(mui.valent, "VALUE")) 
	tcs.mf.factions[8] = tcs.ToggleStateToBool(iup.GetAttribute(mui.axia, "VALUE")) 
	tcs.mf.factions[5] = tcs.ToggleStateToBool(iup.GetAttribute(mui.biocom, "VALUE"))
	tcs.mf.factions[4] = tcs.ToggleStateToBool(iup.GetAttribute(mui.tpg, "VALUE")) 
	tcs.mf.factions[7] = tcs.ToggleStateToBool(iup.GetAttribute(mui.orion, "VALUE"))
	tcs.mf.factions[9] = tcs.ToggleStateToBool(iup.GetAttribute(mui.corvus, "VALUE")) 
	tcs.mf.factions[0] = tcs.ToggleStateToBool(iup.GetAttribute(mui.unaligned, "VALUE")) 
	tcs.mf.factions[10] = tcs.ToggleStateToBool(iup.GetAttribute(mui.tunguska, "VALUE"))
	tcs.mf.factions[13] = tcs.ToggleStateToBool(iup.GetAttribute(mui.xangxi, "VALUE")) 
	tcs.mf.FS["Group"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.group, "VALUE"))
	tcs.mf.FS["Guild"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.guild, "VALUE"))
	tcs.mf.FS["Buddy"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.buddies, "VALUE"))
	--tcs.mf.FS["NPC"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.NPC, "VALUE"))
	tcs.mf.FS["Hive"] = tonumber(iup.GetAttribute(mui.hive, "VALUE"))
	tcs.mf.FS["StatG"] = tonumber(iup.GetAttribute(mui.statg, "VALUE"))
	tcs.mf.FS["SF"] = tonumber(iup.GetAttribute(mui.sf, "VALUE")) 
	tcs.mf.FS["Border"] = tonumber(iup.GetAttribute(mui.border, "VALUE")) 
	tcs.mf.FS["Conq"] = tonumber(iup.GetAttribute(mui.conq, "VALUE")) 
	tcs.mf.FS["norm"] = tonumber(iup.GetAttribute(mui.norm, "VALUE"))
	tcs.mf.FS["igEnemy"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.igenemy, "VALUE"))
	tcs.mf.FS["igFriend"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.igfriend, "VALUE"))
	tcs.mf.FS["igEnemyGuild"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.igenemyguild, "VALUE"))
	tcs.mf.FS["igFriendGuild"] = tcs.ToggleStateToBool(iup.GetAttribute(mui.igfriendguild, "VALUE"))
	tcs.mf.FS["FlagHostile"] = tcs.ToggleStateToBool(mui.flaghostile.value)
	tcs.mf.LastAggro.timeout = mui.flaghostiletext.value * 60
	tcs.mf.FS["ConsiderStanding"] = tcs.ToggleStateToBool(mui.considerstanding.value)
	tcs.mf.invalidate_conq_status(nil, nil)
	tcs.mf.close()
	tcs.mf.SaveSettings(tcs.mf.curpreset)
end

--Guild lists dialog, go~!
mui.gcontrols = {
	guildlistscloseb =	{"stationbutton", {title =  "Close & Save",expand = "HORIZONTAL" }},
	whitetoblackb = 	{"stationbutton", {title =  ">" }},
	blacktowhiteb = 	{"stationbutton", {title =  "<" }},
	addwhite = 			{"stationbutton", {title =  "Add as Friendly Guild",expand = "HORIZONTAL" }},
	addblack = 			{"stationbutton", {title =  "Add as Enemy Guild",expand = "HORIZONTAL" }},

	removewhite = 	{"stationbutton", {title =  "Remove Friendlly Guild",expand = "HORIZONTAL"}},
	removeblack = 	{"stationbutton", {title =  "Remove Enemy Guild",expand = "HORIZONTAL"}}
}

tcs.BatchAddControls(mui.gcontrols, mui)

mui.blacklist = iup.pdasubsubsublist { value = 0, size = "x160", expand = "HORIZONTAL" }
mui.whitelist = iup.pdasubsubsublist { value = 0, size = "x160", expand = "HORIZONTAL" }
mui.whiteentry = iup.text { value = "", expand = "HORIZONTAL"}
mui.blackentry = iup.text { value = "", expand = "HORIZONTAL"}


mui.whitelistcomp = iup.vbox {
	iup.label { title = "Friendly Guilds"},
	mui.whitelist,
	mui.whiteentry,
	mui.addwhite,
	mui.removewhite;
	alignment = "ACENTER"
}
mui.blacklistcomp = iup.vbox {
	iup.label { title = "Enemy Guilds"},
	mui.blacklist,
	mui.blackentry,
	mui.addblack,
	mui.removeblack;
	alignment = "ACENTER"
}

mui.xferbuttons = iup.vbox {
	iup.fill{},
	mui.whitetoblackb,
	mui.blacktowhiteb,
	iup.fill{}
}

mui.guildlistsmain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox{
			iup.hbox {
				mui.whitelistcomp,
				mui.xferbuttons,
				mui.blacklistcomp
			},
			iup.fill{},
			iup.hbox {
				mui.guildlistscloseb;
			};
			alignment = "ACENTER"
		}
	}
}

mui.guildlistsdlg = iup.dialog {
	mui.guildlistsmain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	MODAL = "YES"
}

function mui.guildlistsdlgopen()
	for key, value in pairs(tcs.mf.friendguildlist) do
		tcs.PushListItem(mui.whitelist, value)
	end
	for key, value in pairs(tcs.mf.enemyguildlist) do
		tcs.PushListItem(mui.blacklist, value)
	end	
	ShowDialog(mui.guildlistsdlg)
end

function mui.guildlistscloseb:action()
	tcs.mf.enemyguildlist = {}
	tcs.mf.friendguildlist = {}
	local nam = ""
	local listcounter = tcs.GetListSize(mui.whitelist)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(mui.whitelist, 1)
		table.insert(tcs.mf.friendguildlist, nam)
		listcounter = listcounter - 1

	end
	listcounter = tcs.GetListSize(mui.blacklist)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(mui.blacklist, 1)
		table.insert(tcs.mf.enemyguildlist, nam)
		listcounter = listcounter - 1
	end
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "FriendGuilds", spickle(tcs.mf.friendguildlist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "EnemyGuilds", spickle(tcs.mf.enemyguildlist))
	
	tcs.mf.enemyguildmap=tcs.iListToMap(tcs.mf.enemyguildlist)
	tcs.mf.friendguildmap=tcs.iListToMap(tcs.mf.friendguildlist)
	
	HideDialog(mui.guildlistsdlg)
	mui.dlg.active = "YES"
end

function mui.addwhite:action()
	if(not strip_whitespace(mui.whiteentry.value)) then 
		mui.whiteentry.value = ""
		return 
	end
	tcs.PushListItem(mui.whitelist, mui.whiteentry.value)
	mui.whiteentry.value = ""
end

function mui.addblack:action()
	if(not strip_whitespace(mui.blackentry.value)) then
		mui.blackentry = ""
		return
	end
	tcs.PushListItem(mui.blacklist, mui.blackentry.value)
	mui.blackentry.value = ""
end

function mui.removewhite:action()
	tcs.RemoveSelectedListItem(mui.whitelist)
end

function mui.removeblack:action()
	tcs.RemoveSelectedListItem(mui.blacklist)
end

function mui.whitetoblackb:action()
	tcs.MoveSelectedListItem(mui.whitelist, mui.blacklist)
end

function mui.blacktowhiteb:action()
	tcs.MoveSelectedListItem(mui.blacklist, mui.whitelist)
end

--Lists of people. NSA is watching.
mui.pcontrols = {
	fandecloseb = {"stationbutton", {title =  "Close & Save",expand = "HORIZONTAL"}},

	leftbutton = {"stationbutton", {title =  "<"} },
	rightbutton = {"stationbutton", {title =  ">" }},

	addfriend = {"stationbutton", {title =  "Add as Friend",expand = "HORIZONTAL" }},
	removeselectedfriend = {"stationbutton", {title =  "Remove Selected Friend",expand = "HORIZONTAL" }},
	addenemy = {"stationbutton", {title =  "Add as Enemy",expand = "HORIZONTAL" }},
	removeselectedenemy = {"stationbutton", {title =  "Remove Selected Enemy",expand = "HORIZONTAL" }},
}

tcs.BatchAddControls(mui.pcontrols, mui)

mui.enemybox = iup.pdasubsubsublist { value = 0, size = "x350", expand = "HORIZONTAL" }
mui.friendlybox = iup.pdasubsubsublist { value = 0, size = "x350", expand = "HORIZONTAL" }
mui.friendentrybox = iup.text { value = "", expand = "HORIZONTAL"}
mui.enemyentrybox = iup.text {value = "", expand = "HORIZONTAL"}


mui.addremovefriend = iup.vbox {
	iup.label{title = "Friendlies"},
	mui.friendlybox,
	mui.friendentrybox,
	mui.addfriend,
	mui.removeselectedfriend;
	alignment = "ACENTER" 
}
mui.addremoveenemy = iup.vbox {
	iup.label{title = "Enemies"},
	mui.enemybox,
	mui.enemyentrybox,
	mui.addenemy,
	mui.removeselectedenemy;
	alignment = "ACENTER" 
}
mui.transferbuttons = iup.vbox {
	iup.fill{},
	mui.rightbutton,
	mui.leftbutton,
	iup.fill{}
}
mui.fandemid = iup.hbox {
	mui.addremovefriend,
	mui.transferbuttons,
	mui.addremoveenemy;
	alignment = "ACENTER"
}
mui.fandeentry = iup.vbox {
	mui.fandemid
}
	
		
mui.fandemain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox{
			mui.fandeentry,
			iup.fill{},
			iup.hbox {
				mui.fandecloseb;
				--size = "490x"
			};
			alignment = "ACENTER"
		}
	}
}

mui.fandedlg = iup.dialog {
	mui.fandemain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	MODAL = "YES"
}
mui.friendnum = 0
mui.enemynum = 0
function mui.friendentrybox:action(c)
	if(c == iup.K_TAB) then
		if(strip_whitespace(mui.friendentrybox.value) == nil) then
			mui.friendentrybox.value = GetLastPrivateSpeaker()
		end
		local name = TabCompleteName(iup.GetAttribute(mui.friendentrybox, "VALUE"))
		if(name ~= nil) then
			iup.SetAttribute(mui.friendentrybox, "VALUE", name)
		end
	end
end

function mui.fandedlg:k_any(c)
	if(c == iup.K_TAB) then
		return iup.IGNORE
	end
	return iup.DEFAULT
end

function mui.enemyentrybox:action(c)
	if(c == iup.K_TAB) then
		if(strip_whitespace(mui.enemyentrybox.value) == nil) then
			mui.enemyentrybox.value = GetLastPrivateSpeaker() or ""
		end
		local name = TabCompleteName(iup.GetAttribute(mui.enemyentrybox, "VALUE"))
		if(name ~= nil) then
			iup.SetAttribute(mui.enemyentrybox, "VALUE", name)
		end
	end
end


function mui.addfriend:action()
	local toadd = mui.friendentrybox.value
	if(strip_whitespace(toadd) == nil) then 
		mui.friendentrybox.value = ""
		return 
	end
	tcs.PushListItem(mui.friendlybox, toadd)
	mui.friendentrybox.value = ""
	
end
function mui.addenemy:action()

	local toadd = mui.enemyentrybox.value
	if(strip_whitespace(toadd) == nil) then
		mui.enemyentrybox.value = ""
		return 
	end
	tcs.PushListItem(mui.enemybox, toadd)
	mui.enemyentrybox.value = ""

end
function mui.leftbutton:action()
	tcs.MoveSelectedListItem(mui.enemybox, mui.friendlybox)

end
function mui.removeselectedenemy:action()
	tcs.RemoveSelectedListItem(mui.enemybox)
end
		
function mui.removeselectedfriend:action()
	tcs.RemoveSelectedListItem(mui.friendlybox)
end
function mui.rightbutton:action()
	tcs.MoveSelectedListItem(mui.friendlybox, mui.enemybox)
end
function mui.fandedlgopen()
	for key, value in pairs(tcs.mf.friendslist) do
		tcs.PushListItem(mui.friendlybox, value, mui.friendnum)
	end
	for key, value in pairs(tcs.mf.enemylist) do
		tcs.PushListItem(mui.enemybox, value, mui.enemynum)
	end	
	ShowDialog(mui.fandedlg)
end

function mui.fandeclose()
	tcs.mf.enemylist = {}
	tcs.mf.friendslist = {}
	local nam = ""
	local listcounter = tcs.GetListSize(mui.friendlybox)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(mui.friendlybox, 1)
		table.insert(tcs.mf.friendslist, nam)
		listcounter = listcounter - 1

	end
	listcounter = tcs.GetListSize(mui.enemybox)
	while(listcounter > 0) do
		nam = tcs.RemoveSelectedListItem(mui.enemybox, 1)
		table.insert(tcs.mf.enemylist, nam)
		listcounter = listcounter - 1
	end
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Friends", spickle(tcs.mf.friendslist))
	gkini.WriteString("MakeFriends-"..GetPlayerName(), "Enemies", spickle(tcs.mf.enemylist))
	
	tcs.mf.enemymap=tcs.iListToMap(tcs.mf.enemylist)
	tcs.mf.friendmap=tcs.iListToMap(tcs.mf.friendslist)

end

function mui.fandecloseb:action()
	mui.fandeclose()
	HideDialog(mui.fandedlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "YES")
end

--Presets! Everyone loves presets
--Also, don't care enough to convert this into a titled control batch right now, :effort:
--not a big chunk anyway
mui.presetscloseb = iup.stationbutton { title = "Close", expand = "HORIZONTAL" }
mui.presetsbox = iup.pdasubsubsublist { value = 1, size = "250x200", expand = "HORIZONTAL"}
mui.presetsentrybox = iup.text { value = "", expand = "HORIZONTAL"}
mui.loadselectedpreset = iup.stationbutton { title = "Load Selected Preset", expand = "HORIZONTAL" }
mui.removeselectedpreset = iup.stationbutton { title = "Remove Selected Preset", expand = "HORIZONTAL" }
mui.loaddefaultpreset = iup.stationbutton { title = "Load Default Preset", expand = "HORIZONTAL" }
mui.savepresetname = iup.text { value = "", expand = "HORIZONTAL" }
mui.savepresetokb = iup.stationbutton { title = "Save Preset" }
mui.savepresetnob = iup.stationbutton { title = "Cancel" }


mui.presetsmain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.hbox{
			iup.vbox{
				mui.presetsbox,
				alignment = "ACENTER"
			},
			iup.fill{},
			iup.vbox{
				mui.loadselectedpreset,
				mui.removeselectedpreset,
				iup.fill{},
				mui.loaddefaultpreset,
				mui.presetscloseb;
				alignment = "ACENTER"
			}	
		}
	}
}


mui.presetsdlg = iup.dialog {
	mui.presetsmain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	--size = "500x500",
	MODAL = "YES"
}

mui.savepresetmain = iup.pdarootframe {
	iup.pdasubframebg {
		iup.vbox{
			iup.label { title = "Enter New Preset Name:" },
			mui.savepresetname,
			iup.hbox {
				iup.fill{},
				mui.savepresetokb,
				mui.savepresetnob
			}
		}
	}
}


mui.savepresetdlg = iup.dialog {
	mui.savepresetmain;
	border = "NO",
	topmost = "YES",
	resize = "NO",
	maxbox = "NO",
	minbox = "NO",
	menubox = "NO",
	--size = "500x500",
	MODAL = "YES"
}

function mui.savepresetnob:action()
	iup.SetAttribute(mui.savepresetname, "VALUE", "")
	HideDialog(mui.savepresetdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "YES")
end
function mui.savepresetokb:action()
	local name = iup.GetAttribute(mui.savepresetname, "VALUE")
	if(name == "") then
		return
	end
	if(tcs.IsStringInTable(tcs.mf.presets, name) == false) then
		table.insert(tcs.mf.presets, name)
		tcs.mf.SavePresets()
	end
	tcs.mf.SaveSettings(name)
	tcs.mf.curpreset = name
	iup.SetAttribute(mui.savepresetname, "VALUE", "")
	gkini.WriteString("MakeFriends-"..GetPlayerName() or "", "CurrentPreset", name)
	HideDialog(mui.savepresetdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "YES")
end
	
function mui.savepresetb:action()
	iup.SetAttribute(mui.savepresetname, "VALUE", "")
	ShowDialog(mui.savepresetdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "NO")
end
function mui.presetsdlgopen()
	mui.presetsnum = 0
	for key, value in pairs(tcs.mf.presets) do
		mui.presetsnum = mui.presetsnum + 1
		iup.SetAttribute(mui.presetsbox, "VALUE", mui.presetsnum)
		iup.SetAttribute(mui.presetsbox, tostring(mui.presetsnum), value)
	end
	ShowDialog(mui.presetsdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "NO")
end

function mui.loadselectedpreset:action()
	local sel = iup.GetAttribute(mui.presetsbox, "VO_LISTSEL")
	if(sel == 0) then
		return
	end
	local selpreset = iup.GetAttribute(mui.presetsbox, tostring(sel))
	if(selpreset ~= nil) then
		tcs.mf.LoadSettings(selpreset)
	end
	tcs.mf.GetFriends()
	gkini.WriteString("MakeFriends-"..GetPlayerName() or "", "CurrentPreset", selpreset)
	HideDialog(mui.presetsdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "YES")
end

function mui.removeselectedpreset:action()
	if(iup.GetAttribute(mui.presetsbox, "VO_LISTSEL") ~= 0) then
		local selection = tostring(iup.GetAttribute(mui.presetsbox, "VO_LISTSEL"))
		local replacement = iup.GetAttribute(mui.presetsbox, tostring(mui.presetsnum))
		iup.SetAttribute(mui.presetsbox, selection, replacement)
		iup.SetAttribute(mui.presetsbox, tostring(mui.presetsnum), nil)
		mui.presetsnum = mui.presetsnum - 1
		iup.SetAttribute(mui.presetsbox, "VALUE", mui.presetsnum)
	end
end
function mui.presetscloseb:action()
	tcs.mf.presets = {}
	while(mui.presetsnum > 0) do
		table.insert(tcs.mf.presets, iup.GetAttribute(mui.presetsbox, tostring(mui.presetsnum)))
		iup.SetAttribute(mui.presetsbox, tostring(mui.presetsnum), nil)
		mui.presetsnum = mui.presetsnum - 1
		iup.SetAttribute(mui.presetsbox, "VALUE", mui.presetsnum)
	end
	tcs.mf.SavePresets()
	HideDialog(mui.presetsdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "YES")
end

function mui.loaddefaultpreset:action()
	tcs.mf.LoadSettings("Default")
	tcs.mf.GetFriends()
	HideDialog(mui.presetsdlg)
	iup.SetAttribute(mui.dlg, "ACTIVE", "YES")
end

-- Copypasta toggle color functions
local function fac_color(self, v)
	if(v == 1) then
		iup.SetAttribute(self, "FGCOLOR", "0 255 0")
	else
		iup.SetAttribute(self, "FGCOLOR", "255 0 0")
	end
end

mui.unaligned.action = fac_color
mui.serco.action = fac_color
mui.itani.action = fac_color
mui.uit.action = fac_color
mui.aeolus.action = fac_color
mui.ineubis.action = fac_color
mui.xangxi.action = fac_color
mui.corvus.action = fac_color
mui.tpg.action = fac_color
mui.axia.action = fac_color
mui.valent.action = fac_color
mui.orion.action = fac_color
mui.guild.action = fac_color
mui.group.action = fac_color
--mui.NPC.action = fac_color
mui.buddies.action = fac_color
mui.tunguska.action = fac_color
mui.biocom.action = fac_color

local function npc_color(self,_,v)
	local c = (v==1 and "255 204 241") or (v==2 and "255 0 0") or (v == 3 and "0 255 0") or "255 255 255"
	iup.SetAttribute(self, "FGCOLOR", c)
end
mui.hive.action = function(self,_, v) npc_color(mui.hivestat,_, v) end
mui.statg.action = function(self,_, v) npc_color(mui.statgstat,_, v) end
mui.border.action = function(self,_,v) npc_color(mui.borderstat,_,v) end
mui.sf.action = function(self,_, v) npc_color(mui.sfstat,_, v) end
mui.conq.action = function(self,_, v) npc_color(mui.conqstat,_, v) end
mui.norm.action = function(self,_, v) npc_color(mui.normstat,_, v) end
