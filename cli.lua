 tcs.magic1= "*              /\\\\,%,_\n*              \\\\%%%/,\\\\\n*            _.-\\\"%%|//%\n*          .\\'  .-\\\"       /%%%\n*      _.-\\'_.-\\\" 0)     \\\\%%%\n*     /.\\\\.\\'               \\\\%%%\n*     \\\\ /      _,         %%%\n*      `\\\"---\\\"~`\\\\   _,*\\'\\\\%%\\'       _,--\\\"\\\"\\\"\\\"-,%%,\n*                  )*^         `\\\"\\\"~~`           \\\\%%%,\n*               _/                                  \\\\%%%\n*         _.-` /                                   |%%,___\n*     _.-\\\"   /      ,                ,           ,|%%   .`\\\\\n*    /\\\\     /      /                  `\\\\          \\\\%\\'   \\\\ /\n*    \\\\ \\\\ _,/      /`~-._              _,`\\\\        \\\\`\\\"\\\"~~`\n*     `\\\"` /-.,_ /\\'      `~\\\"----\\\"~         `\\\\     \\\\\n*         \\\\___,\\'                                  \\\\.-\\\"`/\n*                                                     `--\\'\n*                                 \"A Pony\""
 
local function print_help()
	print("\127ffffffUsage:\n\tType /tcs to open the main TCS dialog. Otherwise, typing /tcs <module> will open the configuration dialog for that module or run that module's commands. See module documentation for commands.\n\tLoaded modules:")
	for plug, conftable in pairs(tcs.PROVIDED) do
		if conftable.cli_cmd.cmd then print("\127ffffff\t\t"..conftable.cli_cmd.cmd) end
	end
end
function tcs.cli(_, input)
	--Handle base case where we don't have input.
	if not input then 
		HideDialog(HUD)
		HideAllDialogs()
		tcs.used_cli = true
		ShowDialog(tcs.ui.confdlg, iup.CENTER, iup.CENTER)
		tcs.SizeAdjustment(tcs.ui.configbs)
		tcs.ui.version.title = tcs.VERSION
		iup.Refresh(tcs.ui.confdlg)
		return
	elseif string.lower(input[1]) == "help" then 
		print_help()
		return
	elseif string.lower(input[1]) == "ponies" then
	--This looks terrible ingame, I hope people read the source
		StationHelpDialog:Open(tcs.magic1)--[[
/************************************************************\
*              /\\,%,_                                       *
*              \\%%%/,\\                                     *
*            _.-\"%%|//%                                     *
*          .\'  .-\"  /%%%                                   *
*      _.-\'_.-\" 0)   \\%%%                                 *
*     /.\\.\'           \\%%%                                *
*     \\ /      _,      %%%                                  *
*      `\"---\"~`\\   _,*\'\\%%\'   _,--\"\"\"\"-,%%,        *
*               )*^     `\"\"~~`          \\%%%,             *
*             _/                         \\%%%               *
*         _.-`/                           |%%,___            *
*     _.-\"   /      ,           ,        ,|%%   .`\\        *
*    /\\     /      /             `\\       \\%\'   \\ /     *
*    \\ \\ _,/      /`~-._         _,`\\      \\`\"\"~~`     *
*     `\"` /-.,_ /\'      `~\"----\"~    `\\     \\          *
*         \\___,\'                       \\.-\"`/            *
*                                       `--\'                *
*                          "A Pony"                          *
\************************************************************/]]
		return
	end
	
	for plug, conftable in pairs(tcs.PROVIDED) do
		if input[1] == string.lower(conftable.cli_cmd.cmd or "") then
			if not input[2] then 
				tcs.PROVIDED[plug].cli = true
				HideDialog(HUD)
				HideAllDialogs()
				ShowDialog(conftable.dlg, iup.CENTER, iup.CENTER)
			else
				local cname = table.remove(input, 1)
				if tcs.COMMAND[cname] then tcs.COMMAND[cname](input) end
			end
		end
	end
end

RegisterUserCommand("tcs", tcs.cli)
