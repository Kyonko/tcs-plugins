
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

function tcs.GetFactionColor(faction)
	return tcs.RGBToHex(FactionColor_RGB[faction])
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

function tcs.ProvideConfig(plugname, conf_if, shortdesc, state_func)
	tcs.PROVIDED[plugname] = { conf_if, shortdesc, state_func}
end

--Colorful functions. 
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
