--TCS Common Library. Used to be Ufuncs.
tcs.VERSION="1.1.3"


function tcs.BoolToToggleState(b)
	if b then return "ON" end
	return "OFF"
end

--Compare everything in a case insensitive manner. How rude!
function tcs.compare(a, b)
	if(type(a) == "number" and type(b) == "number") then
		return a < b
	end
	return string.lower(tostring(a)) < string.lower(tostring(b))
end

--Will create a generalized configuration window
--Title is the title of the window, elements are all the little dofangle and bohickies
--And maindlgops is a table describing the extra options to pass to the main dialog. Things like
-- .defaultesc and hotkeys
function tcs.ConfigConstructor(title, elements, maindlgops)
	local maindlg = iup.dialog{
		iup.stationhighopacityframe{
			iup.stationhighopacityframebg{
				iup.vbox {
					iup.hbox{iup.fill{},iup.label{title=title,font=Font.H3},iup.fill{}},
					unpack(elements)
				}
			}
		},
		menubox="NO",
		resize="NO",
		border="NO",
		unpack(maindlgops),
		bgcolor = "0 0 0 0 *"
	}
	return maindlg
end

function tcs.EscapeSpecialChars(str)
	if not str then return end
	return string.gsub(str, "(%c)", {	['\n'] = "\\n",
							['\t'] = "\\t",
							['\v']  = "\\v",
							['\b']  = "\\b",
							['\r']  = "\\r",
							['\f']  = "\\f",
							['\a']  = "\\a",
							['\\']  = "\\\\",
							['\?']  = "\\?",
							['\'']  = "\\\'",
							['\"']  = "\\\""}
							--function(s)
							--	return string.format("\%c", string.byte(s))
							)
end

function tcs.factionfriendlynesscolor(standing)
	if(standing == 0) then
		return "255 0 0"
	end
	return factionfriendlynesscolor(standing)
end

--Nabs the size of a iup element. Returns int width, int height
function tcs.GetElementSize(element)
	local width = string.gsub(element.size, "x%d+", "")
	local heighth = string.gsub(element.size, "%d+x", "")
	return tonumber(width), tonumber(heighth) 
end

function tcs.GetFactionColor(faction)
	return tcs.RGBToHex(FactionColor_RGB[faction])
end

--Accurately determines what the VALUE attribute of a list should be.
function tcs.GetListSize(list)
	local val = 0
	while(list[val + 1] ~= nil) do
		val = val + 1
	end
	return val
end

--Recursively nabs a parent. Negatives kidnap children.
--iuphand needs to be a valid iup handle
--num can be: 0/nil/false is the element itself, 1 is its parent, 2 is its parents parent, 3 is its parent's parent's parent, etc...
--If num is negative, it gets children(-1 is next child, -2 is next next child, etc.)

function tcs.GetRelative(iuphand, num)
	num = num or 0
	if(num == 0) then return iuphand end
	if(not iuphand) then return nil end
	if(num < 0) then return tcs.GetRelative(iup.GetNextChild(iuphand), num+1) end
	return tcs.GetRelative(iup.GetParent(iuphand), num-1)
end

--Retrieves the specified sibling of an iup handle.

function tcs.GetSibling(iuphand, num)
	num = num or 0
	if(num == 0) then return iuphand end
	if(not iuphand) then return nil end
	return tcs.GetSibling(iup.GetBrother(iuphand), num -1)
end

function tcs.IntToToggleState(i)
	if i == 1 then return "ON" end
	return "OFF"
end

--Checks if someone is your buddy
function tcs.IsBuddy(charid)
	if(GetBuddyInfo(charid) ~= nil) then
		return true
	end
	return false
end

--Finds an int in table
function tcs.IsIntInTable(intable, int)
	for key, value in pairs(intable) do
		if(int == value) then
			return key
		end
	end
	return false
end

--This function returns whether or not the sector is empty of other players. Takes no arguments.
--It keeps a current list of all non-NPC players in the sector under tcs.current_players

tcs.current_players = {}
tcs._curplayerscatch = {}
function tcs.IsSectorEmptyOfHumans()
	local flag = true
	for key in pairs(tcs.current_players) do
		if(not tcs.StringAtStart(GetPlayerName(key), "*")) then flag = false end
	end
	return flag
end

function tcs._curplayerscatch:OnEvent(event, data)
	if(event == "PLAYER_ENTERED_SECTOR") then
		if(data == GetCharacterID() or data == 0) then return end
		tcs.current_players[data] = true
	end
	if(event == "PLAYER_LEFT_SECTOR") then
		if(data == GetCharacterID()) then
			tcs.current_players = {}
		else
			tcs.current_players[data] = nil
		end
	end
end
RegisterEvent(tcs._curplayerscatch, "PLAYER_ENTERED_SECTOR")
RegisterEvent(tcs._curplayerscatch, "PLAYER_LEFT_SECTOR")
ForEachPlayer(function (charid)
				tcs._curplayerscatch:OnEvent("PLAYER_ENTERED_SECTOR", charid)
				end)

				
--Finds a string in table. Returns the index if it finds it, false otherwise.
function tcs.IsStringInTable(intable, fstring)
	for key, value in pairs(intable) do
		if(string.lower(fstring) == string.lower(value)) then
			return key
		end
	end
	return false
end

--Moves the selected item in the iup list source to the iup list dest
--If sel is specified, that is the item moved from source. If not, vo_listsel is used.
function tcs.MoveSelectedListItem(source, dest, sel)
	if(not sel) then
		sel = source.vo_listsel
	end
	local selitem = tcs.RemoveSelectedListItem(source, sel)
	tcs.PushListItem(dest, selitem)
end


function tcs.ProvideConfig(plugname, conf_if, shortdesc, state_func)
	tcs.PROVIDED[plugname] = { conf_if, shortdesc, state_func}
end

--Adds an item to the end of a iup list
function tcs.PushListItem(list, item)
	if(not list.value) then list.value = 0 end
	local newval = list.value + 1
	list[tostring(newval)] = item
	list.value = newval
end



--Removes the selected item from a list if sel is not specified
--Otherwise, it removes the item at the value of vo_listsel(currently selected item)
--If an item hasn't been selected, removes the last item in the list.
--Returns the value of the item removed
function tcs.RemoveSelectedListItem(list, sel)
	if(sel == nil) then
		sel = list.vo_listsel
	end
	if(sel ~= 0) then
		local val = tcs.GetListSize(list)
		if(not sel) then sel = val end
		local curval = list[tostring(sel)]
		while(tonumber(sel) < val) do
			list[sel] = list[sel + 1]
			sel = sel + 1

		end
		list[tostring(val)] = nil
		list.value = val - 1
		list.vo_listsel = sel - 1
		return curval
	end
end

function tcs.RGBToHex(rgb)
	local rgb2 = {}
	if (not rgb) then return "DDDDDD" end
	for component in string.gmatch(rgb, "%d+") do
		table.insert(rgb2, component)
	end 
   	local hex = string.format("%.2x%.2x%.2x", rgb2[1], rgb2[2], rgb2[3])
	return hex
end 



function tcs.StringAtStart(haystack, needle)
	if not haystack or not needle then return end
	return (string.sub(haystack, 1, string.len(needle)) == needle)
end

function tcs.ToggleStateToInt(state) 
	if state == "ON" then return 1 end
	return 0
end

--For the sake of not going insane while rewriting MF
function tcs.ToggleStateToBool(state)
	if state == "ON" then return true end
	return false
end

function tcs.UnescapeSpecialChars(str)
	if not str then return end
	return string.gsub(str, "\\.", {	["\\n"] = "\n",
							["\\t"] = "\t",
							["\\v"]  = "\v",
							["\\b"]  = "\\b",
							["\\r"]  = "\r",
							["\\f"]  = "\f",
							["\\a"]  = "\a",
							["\\\\"]  = "\\",
							["\\\?"]  = "\?",
							["\\\'"]  = "\'",
							["\\\""]  = "\""})
						
end

--DELETE ME
function tcs.test(plugin)
	printtable({loadfile("plugins/tcs-plugins/"..plugin.."/main.lua")})
end
