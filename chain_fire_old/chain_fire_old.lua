local name = "CFire"
--To support ongoing cfire development, don't overwrite tables
if not tcs.cfire then 
	tcs.cfire = {}
end

if not tcs.cfire.ui then
	tcs.cfire.ui = {}
end

tcs.cfire.gkpc = gkinterface.GKProcessCommand
tcs.cfire.ui.halpb = iup.stationbutton{title = "Help", action = function()
											StationHelpDialog:Open(
[[This module writes chainfire binds based in the information you input in the window.
												
Firstly, you'll need to set up your weapons groups in the station on your own. Pretty harsh, but eh.
												
If you wish to use primary fire for your chains, set up weapon groups x through y on primary fire. Likewise if you wish to use secondary fire, you should set up weapon groups x through y to use secondary fire.

Once that's all done, you can configure cfire to write your binds. The boxes under the groups determine which weapon groups you wish to cycle through. I cannot guarantee good results if you use a number outside of 1 through 6. Lower number goes in the first box, higher in the second. Do elsewise and things probably will break.
												
When finished with that, enter the delay you want. The built-in VO timer has a resolution of .01 seconds. Don't do anything smaller or stuff breaks. Likewise, if you input \"lawls\" into the Delay field, you're probably going to end up with broken binds and spilt milk.
												
Trigger selection is just a selection of which trigger you're going to use, primary, secondary, or tertiery. You need to have your weapon groups set up to use all the same trigger or again, stuff breaks. But it's your fault when stuff breaks, so onward!
												
Manual timing, if checked, indicated you don't want to cycle with a delay, instead you wish to cycle every time you press the fire trigger. I like this for rockets, press firetrigger and one rocket goes, press again and another, etc.
												
Now you're almost done! Just hit Write Alias and the script will generate your chainfire alias. It also prints out the command you need to bind, but you'll need to close the chainfire dialog by hitting close to see it. It's always +cfire1, +cfire2, or +cfire3 depending on which trigger you wanted to use(You can have up to three different chainfire setups.)
]])
											end}
tcs.cfire.ui.closeb = iup.stationbutton{title = "Close"}
tcs.cfire.ui.writeb = iup.stationbutton{title = "Write Alias"}
tcs.cfire.ui.manualtoggle = iup.stationtoggle{title = "Use Manual Timing", state = "OFF"}
tcs.cfire.ui.primary = iup.stationtoggle{title = "1st    ", state = "OFF"}
tcs.cfire.ui.secondary = iup.stationtoggle{title = "2nd    ", state = "OFF"}
tcs.cfire.ui.tertiary = iup.stationtoggle{title = "3rd", state = "ON", value = "ON"}
tcs.cfire.ui.cvarPri = false
tcs.cfire.ui.cvarSec = false
tcs.cfire.ui.cvarTer = true
tcs.cfire.ui.cvarManToggle = false

tcs.cfire.ui.title = iup.label {title = "Chainfire Alias Writer"}
tcs.cfire.ui.fgroup = iup.text{value="1", size="50x"}
tcs.cfire.ui.lgroup = iup.text{value="3", size="50x"}
tcs.cfire.ui.delay = iup.text{value=".01", size="50x"}

tcs.cfire.ui.titlebox = iup.hbox {
	iup.vbox {
		tcs.cfire.ui.title
	}
}

tcs.cfire.ui.params = iup.vbox {
	iup.hbox{
		iup.label{title = "     Groups"},
		iup.fill{},
		iup.label{title="Delay "};
		margin = "5x0"
	},
	iup.hbox {
		tcs.cfire.ui.fgroup,
		iup.label{ title = "~"},
		tcs.cfire.ui.lgroup,
		iup.fill{},
		tcs.cfire.ui.delay;
		margin = "5x0"
	},
	iup.radio{
		iup.hbox {
			iup.label{title = "Use Trigger: "},
			iup.fill{},
			tcs.cfire.ui.primary,
			tcs.cfire.ui.secondary,
			tcs.cfire.ui.tertiary;
			margin = "5x0"
		}
	}	
}

tcs.cfire.ui.mantoggle = iup.hbox {
	iup.fill{},
	tcs.cfire.ui.manualtoggle;
	margin = "5x0"
}

tcs.cfire.ui.controls = iup.hbox {
	tcs.cfire.ui.halpb,
	iup.fill{},
	tcs.cfire.ui.writeb,
	tcs.cfire.ui.closeb
}

local dlg = {
	tcs.cfire.ui.params,
	iup.fill{},
	tcs.cfire.ui.mantoggle,
	tcs.cfire.ui.controls,
	alignment="ACENTER",gap=5
}

tcs.cfire.maindlg = tcs.ConfigConstructor("Chainfire Alias Writer", dlg, {SIZE="300x175"})

function tcs.cfire.close()
	HideDialog(tcs.cfire.maindlg)
	tcs.cli_menu_adjust(name)
end

function tcs.cfire.ui.closeb:action()
	tcs.cfire.close()
end

function tcs.cfire.ui.primary:action(v)
	if(v == 1) then
		tcs.cfire.ui.cvarPri = true
	else
		tcs.cfire.ui.cvarPri = false
	end
end

function tcs.cfire.ui.secondary:action(v)
	if(v == 1) then
		tcs.cfire.ui.cvarSec = true
	else
		tcs.cfire.ui.cvarSec = false
	end
end

function tcs.cfire.ui.tertiary:action(v)
	if(v == 1) then
		tcs.cfire.ui.cvarTer = true
	else
		tcs.cfire.ui.cvarTer = false
	end
end

function tcs.cfire.ui.manualtoggle:action(v)
	if(v == 1) then
		tcs.cfire.ui.cvarManToggle = true
	else
		tcs.cfire.ui.cvarManToggle = false
	end
end

function tcs.cfire.ui.writeb:action()
	local nodelay = tcs.cfire.ui.cvarManToggle
	local pri = tcs.cfire.ui.cvarPri
	local sec = tcs.cfire.ui.cvarSec
	local ter = tcs.cfire.ui.cvarTer
	local fgroup = tonumber(iup.GetAttribute(tcs.cfire.ui.fgroup, "value"))
	local lgroup = tonumber(iup.GetAttribute(tcs.cfire.ui.lgroup, "value"))
	local delay = tonumber(iup.GetAttribute(tcs.cfire.ui.delay, "value"))
	local next = 0
	local i = 0
	local trigger = 0 
	local damnVO = 0
	
	--Horsies!
	-- Thanks to VO being weird, damnVO is to correct for +shoot1 being secondary trigger and +shoot2 being primary trigger. Gar
	if(pri == true) then
		trigger = 1
		damnVO = 2
	elseif(sec == true) then
		trigger = 2
		damnVO = 1
	else 
		trigger = 3
		damnVO = 3
	end

	--First, the gruntwork alias state machine.
	--Each set has its own state machine to run off of so things don't get tangled. That would be bad. We don't like tangles.
	i = fgroup
	tcs.cfire.gkpc("alias cfireswitch"..trigger.." \"cfiregrunt"..i.."_"..trigger.."\"")
	while(i <= lgroup) do
		next = i + 1
		if(i ~= lgroup) then
			tcs.cfire.gkpc("alias cfiregrunt"..i.."_"..trigger.." \"Weapon"..i.."; alias cfireswitch"..trigger.." cfiregrunt"..next.."_"..trigger.."\"")
		else 
			tcs.cfire.gkpc("alias cfiregrunt"..i.."_"..trigger.." \"Weapon"..i.."; alias cfireswitch"..trigger.." cfiregrunt"..fgroup.."_"..trigger.."\"")
		end
		i = i + 1
	end

	--Now on to control structures
	
	if(nodelay == true) then
		tcs.cfire.gkpc("alias +cfire"..trigger.." \"+Shoot"..damnVO)
		tcs.cfire.gkpc("alias -cfire"..trigger.." \"+Shoot"..damnVO.." 0; cfireswitch"..trigger.."\"")
		print("Now merely bind +cfire"..trigger.." to your preferred button and it will work. Made without delay.")
	else
		tcs.cfire.gkpc("alias +cfire"..trigger.." \"+Shoot"..damnVO.."; cfiremakeloop"..trigger.."; cfirelstart"..trigger.."\"")
		tcs.cfire.gkpc("alias cfirelstart"..trigger.." \"cfireloop"..trigger.."; alias cfirelstart"..trigger.." none\"")
		tcs.cfire.gkpc("alias cfireloop"..trigger.." none")
		tcs.cfire.gkpc("alias cfiremakeloop"..trigger.." \"alias cfireloop"..trigger.." \'cfireswitch"..trigger.."; wait "..delay.." cfireloop"..trigger.."\'\"")
		tcs.cfire.gkpc("alias -cfire"..trigger.." \"+Shoot"..damnVO.." 0 ; alias cfireloop"..trigger.." none; alias cfirelstart"..trigger.." \'cfireloop"..trigger.."; alias cfirelstart"..trigger.." none\'\"")
		print("Now bind +cfire"..trigger.." to something and it should work. Made with "..delay.."s delay.")
	end
end
local cli_cmd = {cmd ="cfire", interp = nil}
tcs.ProvideConfig(name, tcs.cfire.maindlg, "Chainfire Alias Writer", cli_cmd)