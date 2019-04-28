return {
	
	[[
	+TRELLO SUPPORT FOR ADMINS / BANS
	=ULX style permissions + user powers
	=Organise mainmodule fully
	=Filter command prints based on arg type
	
	-- ARGUMENTS --
	
	+Min and Max functions
	=Rewrite arg finding to use functions to find singular objects, end in comma count as list
	
	-- COMMANDS --
	
	+Config command config/configname/value - datastore
	+Add configs to commands
	+Shortcuts ( Shortcut/name:cmds/etc )
	+SetPrefix, SetArgSplit, SetCmdSplit - Allows you to change from kill/etc|m/hi to any char ( line 603 mainmodule ) + save via datastore
	+Nickname/Player/String - Save via datastore
	+Fly/Noclip
	+Admin chat
	+Arm / DefaultTools
	+Banish / ToSpawn
	+Unstuck
	+Warn command
		Config; Warn limit before kick / ban
		Config; Warn degrade time 
	+Load/map ( map = model in serverstorage/replicatedstorage containing parts ) ( loads it into the workspace, only one map at a time )
	+Unload/map ( unloads current map from the workspace ( deletes it ) )
	+setlives/nil or number
	=Paginate changelog/versions
	=Make ban work with players not online so you can ban via string
	=Use new command options
	=Logs per player - cmdlogs/, chatlogs/, plrlogs/
	=Message - Create a proper gui
	=Following need Plr default self and Bool toggle
		Sit
		Freeze
		LockServer
		Lock + iteratively
		Invisible / Cloak iteratively and save old
		fix/plr ( Arms / legs / camera )
]],

	{ Version = "0.62.0", SetupVersion = "1.3.5", Timestamp = 1556451560, Contributors = { "Partixel" }, Additions = { [[Added End and Stop to Negative Prefixes and Start to Positive Prefixes]] }, Changes = { [[Fixed a bug that caused PlayerScripts to delete on the first death]], [[Spectate command now uses ToggleAlias]], [[Fixed Spectate FreeCam showing name tag for self]] } },

	{ Version = "0.61.1", SetupVersion = "1.3.5", Timestamp = 1554918629, Contributors = { "Partixel" }, Changes = { [[Time argument can now handle complex strings like "2d 5h"]] } },

	{ Version = "0.61.0", SetupVersion = "1.3.5", Timestamp = 1553020572, Contributors = { "Partixel" }, Additions = { [[Added the "pingof/players" command]] }, Changes = { [[The "ping" command now uses a RemoteFunction instead of a RemoteEvent to save on some networking + memory usage]], [[Fixed the "spectate" command when you are the only person in the game]] } },

	{ Version = "0.60.2", SetupVersion = "1.3.5", Timestamp = 1552859244, Contributors = { "Partixel" }, Changes = { [["Commands" command now works via "cmds/page" or "cmds/cmdname/page" instead of "cmds/page/cmdname"]], [[Fixed spectate commands freecam]] } },
	
	{ Version = "0.60.1", SetupVersion = "1.3.5", Timestamp = 1552852494, Contributors = { "Partixel" }, Changes = { [[Players that can access the server logs in the F9 console now get owner userpower as they can run code from the console anyway]], [[Optimised the process that sets players userpower as they join]] } },
	
	{ Version = "0.60.0", SetupVersion = "1.3.5", Timestamp = 1552822978, Contributors = { "Partixel" }, Additions = { [[Pass the previously parsed arguments to arguments to allow things like targetting players with admin power less then the first argument]], [[Add an event for when a CommandModule loads]], [[Use the event to lazy wait for Util in some places that were causing errors]] }, Changes = { [[Create the CommandRan event at runtime]] } },
	
	{ Version = "0.59.4", SetupVersion = "1.3.5", Timestamp = 1551190993, Contributors = { "Partixel" }, Changes = { [[Fixed errors in commands clients causing the main admins client thread to break]] } },
	
	{ Version = "0.59.3", SetupVersion = "1.3.5", Timestamp = 1550510935, Contributors = { "Partixel" }, Changes = { [[Fixed a bug that caused toggle aliases to not work unless they specified a position for the prefix]] } },
	
	{ Version = "0.59.2", SetupVersion = "1.3.5", Timestamp = 1550343570, Contributors = { "Partixel" }, Changes = { [[Fixed an error causing players to get sent two messages when permanent user powers were loaded from datastore]] } },
	
	{ Version = "0.59.1", SetupVersion = "1.3.5", Timestamp = 1550335748, Contributors = { "Partixel" }, Changes = { [[Using the new string.split function instead of the lua version]] } },
	
	{ Version = "0.59.0", SetupVersion = "1.3.5", Timestamp = 1549641991, Contributors = { "Partixel" }, Additions = { [[Added ReservedFor and ReserveSlots config optiosn that allows you to kick anyone that doesnt match the passed string ( uses plr targeting ) from the server once there's only ReserveSlots or 1 spaces left in the server]] } },
	
	{ Version = "0.58.1", SetupVersion = "1.3.5", Timestamp = 1549490845, Contributors = { "Partixel" }, Changes = { [[Fixed VH_Client being recreated every time the player spawns]] } },
	
	{ Version = "0.58.0", SetupVersion = "1.3.5", Timestamp = 1549187483, Contributors = { "Partixel" }, Additions = { [[Added "/shrug", "/tableflip" and "/unflip" ¯\\_(ツ)_/¯]] } },
	
	{ Version = "0.57.0", SetupVersion = "1.3.5", Timestamp = 1548697989, Contributors = { "Partixel" }, Additions = { [[Toggle arguments can now specify the position of the prefix in the alias, e.g. "forceunofficial/" instead of "unforceofficial/"]] } },
	
	{ Version = "0.56.4", SetupVersion = "1.3.5", Timestamp = 1548592169, Contributors = { "Partixel" }, Changes = { [[Updated to the latest version of the StringCalculator module again]] } },
	
	{ Version = "0.56.3", SetupVersion = "1.3.5", Timestamp = 1548527285, Contributors = { "Partixel" }, Changes = { [[Updated to the latest version of the StringCalculator module]] } },
	
	{ Version = "0.56.2", SetupVersion = "1.3.5", Timestamp = 1544139780, Contributors = { "Partixel" }, Changes = { [[Changed some busy waits to lazy waits, slight optimisation]] } },
	
	{ Version = "0.56.1", SetupVersion = "1.3.5", Timestamp = 1543880666, Contributors = { "Partixel" }, Changes = { [[Calc module now uses an external module]] } },
	
	{ Version = "0.56.0", SetupVersion = "1.3.5", Timestamp = 1543880666, Contributors = { "Partixel" }, Additions = { [[Added "calc/number" command to calculate out expressins]] }, Changes = { [[Several optimisations overall]], [[Bug fixes to the calc module]] } },
	
	{ Version = "0.55.5", SetupVersion = "1.3.5", Timestamp = 1538429036, Contributors = { "Partixel" }, Changes = { [[Updated the ToString function to handle \[\[ and \]\] in strings more eloquently]], [[Fixed accurate play solo issues]] } },
	
	{ Version = "0.55.4", SetupVersion = "1.3.5", Timestamp = 1534539373, Contributors = { "Partixel" }, Changes = { [[Fixed irrelevant information showing when using the help command]] } },
	
	{ Version = "0.55.3", SetupVersion = "1.3.5", Timestamp = 1534012661, Contributors = { "Partixel" }, Changes = { [[Fixed some R15 issues]] } },
	
	{ Version = "0.55.2", SetupVersion = "1.3.5", Timestamp = 1533328365, Contributors = { "Partixel" }, Changes = { [[Fixed "permuserpower/" not informing the target of their power change]], [[Fixed "update/" appearing twice in chat when ran]], [[Fixed ^Group=Rank not targetting only that rank]] } },
	
	{ Version = "0.55.1", SetupVersion = "1.3.5", Timestamp = 1532295423, Contributors = { "Partixel" }, Changes = { [[Fixed "stats/" and "resetstats/" commands running but with a chat warning]] } },
	
	{ Version = "0.55.0", SetupVersion = "1.3.5", Timestamp = 1530133444, Contributors = { "Partixel" }, Additions = { [[Added blind/ command]] } },
	
	{ Version = "0.54.1", SetupVersion = "1.3.5", Timestamp = 1529864454, Contributors = { "Partixel" }, Changes = { [[Removed a debug print]], [[Fixed the message returned by cmds/ command]], [[Fixed the bind/ command]], [[Fixed the loop/ command]] } },
	
	{ Version = "0.54.0", SetupVersion = "1.3.5", Timestamp = 1529861434, Contributors = { "Partixel" }, Additions = { [[Added '(un)lockteam/player/bool' commamnd]] }, Changes = { [[Required Command Modules now work by Name instead of the ObjectValues Value]], [[Removed a debug print from ping]] } },
	
	{ Version = "0.53.1", SetupVersion = "1.3.5", Timestamp = 1528840601, Contributors = { "Partixel" }, Changes = { [[Fixed/optimised CmdStacks slightly]], [[Fixed logs/ command]], [[Fixed EmergencyFunctions error]], [[Update to the latest version of my ToString function]] } },
	
	{ Version = "0.53.0", SetupVersion = "1.3.4", Timestamp = 1526940258, Contributors = { "Partixel" }, Additions = { [[Added an option for toggleable argtypes to specify the current ToggleValue]] }, Changes = { [[Optimised memory usage slightly]] } },
	
	{ Version = "0.52.3", SetupVersion = "1.3.4", Timestamp = 1526938948, Contributors = { "Partixel" }, Changes = { [[Fixed alias provided arguments not allowing argument skip-over when parsing arguments]] } },
	
	{ Version = "0.52.2", SetupVersion = "1.3.4", Timestamp = 1523913820, Contributors = { "Partixel" }, Changes = { [[Updated to teleport players in groups using the new TeleportPartyAsync function]] } },
	
	{ Version = "0.52.1", SetupVersion = "1.3.4", Timestamp = 1522167665, Contributors = { "Partixel" }, Additions = { [[Added a command that lets myself run commands as console as long as I can run said command for testing purposes]] }, Changes = { [[Fixed anyone being able to run certain commands due to ", !$console" in the CanRun instead of "&!$console"]], [[Console now counts as a debugger]] } },
	
	{ Version = "0.52.0", SetupVersion = "1.3.4", Timestamp = 1522098053, Contributors = { "Partixel" }, Additions = { [[Command Modules with Client scripts must now use ModuleScripts named Client then returns a function with the same arguments as the command module ( Main, ModFolder, VH_Events )]], [[Command Modules client scripts now are ran with VH_Client, their corresponding module folder and VH_Events folder passed to them for ease of use. This is a large change as old localscript based Clients won't work.]], [[Clients now have a Events table that automatically gets cleared on destruction]], [[Moved clientsided VH_Admin to a new "VH_Client" localscript that handles destruction, filtering and requiring Clients]], [[Added 'fakeupdate/' command when in playsolo that uses a clone of VH_Admin. This allows testing updates using the latest unpublished version.]] }, Changes = { [[Fixed capitalisation on Connect/Disconnect throughout]], [[Fixed several commands not reversing their actions on destruction of the admin]], [[Removed multiple events that didn't need to be in VH_Admin.Events to reduce memory]], [[Fixed several things not being disconnected on destruction/update]], [[Fixed Command Modules not working after an update if they had events/client]], [[Command Modules events are now cloned and the original destroyed to disconnect all connections on update/destruction so you don't have to add events to (VH_Admin/VH_Client).Events]] } },
	
	{ Version = "0.51.1", SetupVersion = "1.3.4", Timestamp = 1521884880, Contributors = { "Partixel" }, Additions = { [[When you fail to run a command only you will now be able to see what you said]] }, Changes = { [[Fixed certain phrases triggering the command detection and an error, e.g. "/skills/"]] } },
	
	{ Version = "0.51.0", SetupVersion = "1.3.4", Timestamp = 1521489600, Contributors = { "Partixel" }, Additions = { [[CommandAliases - These are like commands but instead of running a Callback they run all commands passed to them. For an example check the Main.RespawnTeam command]], [['help/' command shows which commands a CommandAlias runs]], [['cmds/(num)/(string)' includes any CommandAliases that run a matching command and any commands that a CommandAlias runs, e.g. 'cmds/1/teamrespawn' will include the teamrespawn CommandAlias, the team command and the respawn command. 'cmds/1/team' will include the team command, the teamrespawn CommandAlias and the respawn command because the CommandAlias runs it.]] }, Changes = { [[Rewrote how commands are parsed and ran so that commands are parsed and checked that they can be ran first and then ran]], [[Commands can now be repeated straight away instead of only after they've ran]], [[Fixed not help not showing all aliases in certain circumstances]], [[Fixed string arg options not applying if it was the last argument]], [[Fixed 'commands/' command erroring if it couldn't find any matching commands]] } },
	
	{ Version = "0.50.2", SetupVersion = "1.3.4", Timestamp = 1521400336, Contributors = { "Partixel" }, Changes = { [[Fixes targetting with comma seperated targets]] } },
	
	{ Version = "0.50.1", SetupVersion = "1.3.4", Timestamp = 1521296464, Contributors = { "Partixel" }, Changes = { [[Command Module Folders/Client scripts are now prefixed with VH_]], [[Command Modules are now passed their mod folder and VH_Events folder on the server ( return function ( Main, ModFolder, VH_Events ) )]], [[Renmaed VH_Core, VH_Fun, VH_Main and VH_Util to Core, Fun, Main and Util]], [[Fixed a critical bug that caused Command Modules to laod more then once. This caused several errors and wasted time and memory.]] } },
	
	{ Version = "0.50.0", SetupVersion = "1.3.4", Timestamp = 1521147385, Contributors = { "Partixel" }, Additions = { [[Changelog now has the date and time the changes were published!]] }, Changes = { [[Many bug fixes]], [[Bans no longer match partial names]], [[Fixed console running filtered commands]], [[Fixed several other bugs when running commands as console]] }, Removals = { [[Removed NoConsole and Debug from Command Options - Use CanRun = "$debugger" or CanRun = "!$console" in the future]] } },
	
	{ Version = "0.49.0", SetupVersion = "1.3.4", Contributors = { "Partixel" }, Changes = { [[Group ranks can now be targetted using operators ike =, >, <. e.g. 'kill/^1234=10' kills anyone at rank 10 in 1234, 'kill/^1234<10' kills anyone less then or equal to rank 10. Same works for user power targetting, e.g. 'kill/$<admin' and distance targetting e.g. 'kill/*part=10']], [[Console can now repeat commands]], [[Targetting user powers is now '$']] }, Removals = { [[Removed '-' negation from list targetting as it can be done with '!' and '&' ( e.g. 'kill/-me' is the same as 'kill/!me' and 'kill/^1234-me' is the same as 'kill/^1234&!me']] } },
	
	{ Version = "0.48.0", SetupVersion = "1.3.4", Contributors = { "Partixel" }, Additions = { [[You can now use '&' when targetting in commands, e.g. 'kill/part&!me' will kill everyone named part as long as they aren't the player running the command]], [[Can now target debuggers via '=debug'/'=debuggers', e.g 'kill/debuggers']] }, Changes = { [[Updated the 'help/target' command]], [[Removed a large portion of duplicate code from TargetLib.MatchesPlr and unified code]], [[Commands should now use a Player Target for Power and should rename Power to CanRun, for example "CanRun = '=admin'" for admins or higher, "CanRun = 'partixel'" for anyone with partixel in the name, "CanRun = '^1234'" for anyone in the group 1234. This change allows commands to specifically target who can run it, such as a group. Supports all normal targeting syntax such as '!' for inverting a match, '&' for matching multiple arguments.]], [[Large refactor away from 'Power'/'AdminPower' to 'UserPower' - May be breaking, ensure to search for instances of 'Power' such as 'GetPower' which is now 'GetUserPower']] } },
	
	{ Version = "0.47.0", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Additions = { [[Added balanceteams/plrs/teams]] } },
	
	{ Version = "0.46.1", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Fixed destroy/ command]] } },
	
	{ Version = "0.46.0", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Repeat command now repeats the whole stack]] } },
	
	{ Version = "0.45.0", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Additions = { [[Add a filter system]], [[Properly filter messages/hints/broadcast]], [[Filter bans and kicks]], [[Seperated out how erroring commands is handled]] }, Changes = { [[Fixed unbind/all]] } },
	
	{ Version = "0.44.3", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Wildcards no longer match if an argument in the base table matches the wildcard]] } },
	
	{ Version = "0.44.2", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Optimised group matching in arguments]] } },
	
	{ Version = "0.44.1", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Merged permpowers/ and powers/]], [[Merged permbans/ and bans/]], [[Internal change to how permanent bans are set]] } },
	
	{ Version = "0.44.0", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Additions = { [[Added permbans/ to see permanent bans]] }, Changes = { [[You can now run permpowers/ via permadmins/, permmods/, etc]], [[You can now run powers/ as mods/, admins/, etc]], [[Players no longer notified when PermPowers loaded from datastore with no change to their rank]] } },
	
	{ Version = "0.43.0", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Additions = { [[Added permpowers/ command to see all powers set via permpower/ command]] }, Changes = { [[Players now kicked when permbanned from another server]], [[PermPower no longer overrides owner/console powers]], [[PermPower can now force user or clear permpower]] } },
	
	{ Version = "0.42.5", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Fixed mute command not applying saved mutes]], [[Fixed incorrect commands still displaying in normal chat]] } },
	
	{ Version = "0.42.4", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[V-Handle now recognises all channels including private ones]], [[When muted, commands will still show when ran]] } },
	
	{ Version = "0.42.3", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Fixed channels/]], [[mute/ now permanently mutes in that server]] } },
	
	{ Version = "0.42.2", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Fixed permban/]] } },
	
	{ Version = "0.42.1", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Fixed testcmds/ command]], [[Fixed permtake/ command]], [[Fixed changelog/ command]], [[Fixed NoConsole commands]], [[Fixed incorrect arguments counting as ran]], [[Fixed functional Aliases not being runnable via scripts]], [[Fixed several error messages of commands]], [[Fixed default argtype]], [[Fixed setpower/ and permpower/ incorrect errors with WildChar]], [[Fixed Default for ArgTypes not being sent the Argument if it exists ( WildChar only )]] } },
	
	{ Version = "0.42.0", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Additions = { [[Players that have access to TeamCreate now get debugger powers]] } },
	
	{ Version = "0.41.14", SetupVersion = "1.3.3", Contributors = { "Partixel" }, Changes = { [[Fixed emergency update]] } },
	
	{ Version = "0.41.13", SetupVersion = "1.3.2", Contributors = { "Partixel" }, Changes = { [[Fixed an issue with the setup model]] } },
	
	{ Version = "0.41.12", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed running as Console]], [[Fixed an error message when updating]] } },
	
	{ Version = "0.41.11", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed auto updating]] } },
	
	{ Version = "0.41.10", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed invincible/ command]], [[rs/ now runs resetstats/ instead of respawn/]] } },
	
	{ Version = "0.41.9", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed group rank matching]], [[Fixed resetstats/]], [[stats/ now matches stats without full names]] } },
	
	{ Version = "0.41.8", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Correctly runs command ran messages as the player (Should filter now)]], [[Prefixes are now required per command, e.g, ":m hi|:m bye"]] } },
	
	{ Version = "0.41.7", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed command ran messages, now they are accurate]], [[Optimised the message processor]], [[When a command errors when being ran it still displays in chat]] } },
	
	{ Version = "0.41.6", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Optimisations using GetDescendants( )]], [[Improved invisibility handling of decals, parts, etc]] } },
	
	{ Version = "0.41.5", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed targetting exact names]] } },
	
	{ Version = "0.41.4", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed targetting multiple objs with the same name]] } },
	
	{ Version = "0.41.3", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed help command]] } },
	
	{ Version = "0.41.2", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed changes to Alias / Commands not updating caches]] } },
	
	{ Version = "0.41.1", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Bug fixes in function arguments and default options]] } },
	
	{ Version = "0.41.0", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Restructured how arguments work]] } },
	
	{ Version = "0.40.1", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Updated VH_Core and VH_Fun to use the new argument options]] } },
	
	{ Version = "0.40.0", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Additions = { [[Added TargetLib.AliasTypes ( Toggle, Positive, Negative ) - Called like so: Main.TargetLib.AliasTypes.Toggle( 2, "ff", "forcefield" )]] } },
	
	{ Version = "0.39.0", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Additions = { [[Aliases can now be used to toggle certain commands such as "unff/me", "ff/me" - To use toggle behaviour do "tff/me"]] }, Changes = { [[Slightly improved performance]] } },
	
	{ Version = "0.38.4", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Aliases must now be unique]] } },
	
	{ Version = "0.38.3", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Time arg now works with calc]] } },
	
	{ Version = "0.38.2", SetupVersion = "1.3.1", Contributors = { "Partixel" }, Changes = { [[Fixed a few issues with the Calc module, should work 100%, improved the ToString function]] } },
	
	{ Version = "0.38.1", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Changes = { [[TargetLib arg toggles save between updates]] } },
	
	{ Version = "0.38.0", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Additions = { [[Added function aliases, allows dynamic aliases like setpower allows itself to be called by any power name]], [[ArgType/Default now have the alias as an argument, allows situational arguments such as if setpower is ran as admin/ it defaults to admin power]] } },
	
	{ Version = "0.37.4", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Additions = { [[Re-added version/ command]] } },
	
	{ Version = "0.37.3", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Changes = { [[Modules no longer infinitely wait for erroring required modules]], [[Errored command modules are now fully cleaned up]] } },
	
	{ Version = "0.37.2", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Changes = { [[Fixed error with Calc module]], [[ToString util function much improved]], [[Now pcalls requiring of modules]], [[No access directly to VH_ExternalCmds, must use _G.VH_AddExternalCmd( Func ) and _G.VH_RemoveExternalCmd( Key )]] } },
	
	{ Version = "0.37.1", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Additions = { [[Command modules can now require other command modules before themselves]] } },
	
	{ Version = "0.37.0", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Additions = { [[Invincible command]], [[ForceField command]] } },
	
	{ Version = "0.36.4", SetupVersion = "1.3.0", Contributors = { "Partixel" }, Additions = { [[Emergency commands now include update/]] } },
	
	{ Version = "0.36.3", SetupVersion = "1.2.1", Contributors = { "Partixel" }, Additions = { [[Made a plugin to automatically update the config, say 'help/setup' for info]] } },
	
	{ Version = "0.36.2", SetupVersion = "1.2.0", Contributors = { "Partixel" }, Additions = { [[Added updateconfig/ command, say help/setup for information]] } },
	
	{ Version = "0.36.1", SetupVersion = "1.1.0", Contributors = { "Partixel" }, Additions = { [[updateconfig/]], [[3 types of messages, Info, Warning, Error. When passed in place of the Color argument to SendMessage it formats the text to fit that type of message]], [[Config.CommandOptions]], [[Admin tells you if a new version of the setup is available to moderators+]] }, Changes = { [[New Changelog format]], [[Changelog command now accepts version number]], [[Using Enum.Font.Code for chat text]] } },
	
	{ Version = "0.36.0", SetupVersion = "1.1.0", Contributors = { "Partixel" }, Additions = { [[help/setup information]] }, Changes = { [[Debuggers are now told if the setup is out of date]], [[Tell mods if the setup model is out of date when the admin is first required]] } },
	
	{ Version = "0.35.3", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Custom math functions for numbers - Clamp( Num, Low, High ), Round( Num, DecimalPoints ), Truncate( Num, DecimalPoints ), Approach( Num, Target, Increment )]] }, Changes = { [[Correctly handle brackets using balanced matching "%b()", no longer incorrectly matches "(1+2)+3)" instead of "(1+2)"]], [[Handle multiple argument functions, "a(x,y)=x/y;a(1,2)" equals 0.5, "max(1,2)" equals 2]], [[Checks local variables and functions before math library]], [[Fixed several infinite loops]] } },
	
	{ Version = "0.35.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Correctly split on escape characters]] } },
	
	{ Version = "0.35.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed two minus's not making a positive, e.g. 1--1]], [[Fixed decimals with no number before it not working, e.g. .1]] } },
	
	{ Version = "0.35.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Equation solver can now handle variables, "a=1;5+a" equals 6]], [[Equation solver can now handle functions, "a()=x/2;a(1)" equals 0.5]], [[Equation solver can now access math variables, "1+pi" equals 4.141592...]], [[Equation solver can now access math functions, "log(10)" equals 2.302585...]], [[You can now escape argument / command splitters using an escape character (%) - Needed for escaping / in maths, e.g. "1+5%/2"]] } },
	
	{ Version = "0.34.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Updated equation solver for numbers to better handle brackets]] } },
	
	{ Version = "0.34.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Client side command related data is saved between updates]], [[Spectate now allows cycling through players with left + right mouse and when switching to freecam it no longer moves you to the targets head]] } },
	
	{ Version = "0.34.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Main.Changelog so you don't have to use Main.script.Changelog]] }, Changes = { [[Admin is now stored entirely server side so exploiters have no access to the main module or config, only to the events]], [[Events within command modules are moved to a folder in ReplicatedStorage with the same name as the command module]], [[Fixed issues in VH_Core where it was looking for Main.script.Util which no longer exists]], [[Cleanup of VH_Command_Processor handled correctly now]], [[Fixed the possibility of a command module erroring when required breaking the entire admin]] } },
	
	{ Version = "0.33.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added emergency commands if an update fails]] }, Changes = { [[Moved Util to VH_Util commad module with a seperate local script for client stuff]], [[Fixed a possible exploit with the VH_Core module loading]], [[Fixed update error]], [[Fixed binds being reset on death]] } },
	
	{ Version = "0.32.6", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed help command giving incorrect powers]] } },
	
	{ Version = "0.32.5", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Destroy now destroys all VH related objects unless the first argument is true]], [[Renamed all VH[A-Z] to VH_[A-Z] ]] } },
	
	{ Version = "0.32.4", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Decreased memory usage slightly]], [[Increased max time between updates to 1800]] } },
	
	{ Version = "0.32.3", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Removals = { [[Removed team chat module as it is now officially supported]] }, Changes = { [[Improved the addition of external commands, now it is done through _G.VH_AddExternalCommands( Func )]] } },
	
	{ Version = "0.32.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed auto-update error]], [[AnnounceJoin no longer is sent to the player that joined]] } },
	
	{ Version = "0.32.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added todo/ and TODO list inside the Changelog module]] }, Changes = { [[Fixed temp data being lost when admin is updated, it now saves between updates]], [[Fixed cmds/]], [[Checks multiple asset ids for updates]] } },
	
	{ Version = "0.32.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added Config.AnnounceJoin]], [[Added a system to announce joining / leaving of players]] } },
	
	{ Version = "0.31.3", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed commands running without / or : if you said just the command name]] } },
	
	{ Version = "0.31.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Removals = { [[Removed test commands]] }, Changes = { [[Fixed ban commands]] } },
	
	{ Version = "0.31.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Correctly displayed how the command is ran again]] } },
	
	{ Version = "0.31.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[When a string argument is the last argument in a command it concats remaining args; ':print hi there' instead of ':print "hi there"']], [[Lists now work when the arg splitter is a space; ':kill me, code']] }, Changes = { [[Fixed argtest/ not working correctly when the arg splitter is a space]], [[Correctly displayed how the command is ran]] } },
	
	{ Version = "0.30.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Command.Config -- Table of default values for configs related to the command]] }, Removals = { [[Removed references to current / latest version ( No longer works )]] }, Changes = { [[Optimised command error checking]], [[Organised mainmodule some more]], [[Changed back to requiring lowercase powers ( Faster )]], [[Help/cmd shows config keys for the command]], [[Optimised update checking]], [[Update checking uses assetids]], [[Fixed an error when not using the new chat]] } },
	
	{ Version = "0.29.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed bug with help]] } },
	
	{ Version = "0.29.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Optimised debugger checking]], [[Caches command aliases more efficiently using metaevents]], [[Caches power names using metaevents]], [[Partially organised the MainModule]], [[Command.Power is now a string in the case of powers being added after a command is made]], [[Command.Power can be nil for UserSettings]], [[AdminPowers changed to use any case]] } },
	
	{ Version = "0.28.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Bans can now have a reason]], [[Bans command now shows reasons]] } },
	
	{ Version = "0.27.7", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed GC'ing of stuff, only script, Main and TargetLib doesn't gc]] } },
	
	{ Version = "0.27.6", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Corrected pluralisation for certain names]] } },
	
	{ Version = "0.27.5", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Setpower and Permpower no longer works with Owner]], [[Fixed power targetting with numbers]] } },
	
	{ Version = "0.27.4", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed banlist/ so it shows config bans]] } },
	
	{ Version = "0.27.3", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed broadcast/string]] } },
	
	{ Version = "0.27.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed auto updates]] } },
	
	{ Version = "0.27.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed update/]] } },
	
	{ Version = "0.27.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Commands must now be registered as either a command module that returns a function ( Main ) or within an event connected to ReplicatedStorage.AddCommands:Connect( function ( Main ) end )]] } },
	
	{ Version = "0.26.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Update checking uses even less networking now]] } },
	
	{ Version = "0.26.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed a bug with blank args]] } },
	
	{ Version = "0.26.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Update checking now uses significantly less networking if the latest version hasnt changed]], [[Added ^GroupId=Rank]] } },
	
	{ Version = "0.25.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Changed pp/ to getpp/ to avoid conflict with permpower/]] } },
	
	{ Version = "0.25.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed update/ for people that own my modules, can't do better at the moment ( @ROBLOX )]] } },
	
	{ Version = "0.25.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[UpTime command]], [[Return command]] } },
	
	{ Version = "0.24.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed an ordering issue with arguments]] } },
	
	{ Version = "0.24.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[All arguments can now accept a default ( Valid object or a function that returns a valid object )]], [[TargetLib now has a few Defaults ( Self = The calling player, SelfTable = Calling player as a table, SelfId = calling players id, Toggle = If the boolean is nil it toggles the commands state based on last toggle starting at true )]] }, Removals = { [[Removed several commands that Dan created because he is an idiot ( Will re-add )]] }, Changes = { [[The chat log when running a command is now instant, not when the command ends]], [[Many commands now use Default and Toggle]] } },
	
	{ Version = "0.23.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Number argument can now take calculations]] } },
	
	{ Version = "0.22.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added unit tests to commands when they are added]], [[Cache command alias and usage when they are added ( Faster first use )]] }, Changes = { [[Sped up loading times significantly ( 1.8 -> 0.007 seconds )]] } },
	
	{ Version = "0.21.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed take/ command]], [[Moved Message/Hint creation to Util for easy overiding]] } },
	
	{ Version = "0.21.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Removals = { [[Removed ServerEventHandler]] }, Changes = { [[Moved Events]] } },
	
	{ Version = "0.20.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added VH_Command_Modules folder for custom command modules]], [[Seperated core commands required for admin usage into a seperate module]], [[Added the ability for command modules to have client side code that is auto handled]] }, Changes = { [[Renamed Events folder and moved to ReplicatedStorage]], [[Changed connect to Connect]], [[Updated the Destroy function to fully cleanup the admin]], [[Fixed the update command]] } },
	
	{ Version = "0.19.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Arguments now have options such as Min, Max and Default]], [[Support for the new chat and features for the new chat]], [[Added NoConsole option to commands]], [[Added 'Channels' command to view all channels]] }, Changes = { [[Chat related commands moved to the new chat module]], [[Mute and Unmute work]] } },
	
	{ Version = "0.18.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Update away from Instance.new( Obj, Par ) in accordance with Zeus @ RBXDEV]] } },
	
	{ Version = "0.17.4", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Alias for cmdlogs "logs/"]] } },
	
	{ Version = "0.17.3", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed a spectate bug]], [[Fixed incorrect arguments being counted as nil]] } },
	
	{ Version = "0.17.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Spectate now allows you to switch between freecam / spec via space and cycle through players via left mouse]] } },
	
	{ Version = "0.17.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Spectate command now centers your camera at SpectatePos part in workspace if it exists]] } },
	
	{ Version = "0.17.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Lock command]], [[Unlock command]] } },
	
	{ Version = "0.16.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed team targetting]] } },
	
	{ Version = "0.16.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[PlayerPoints command]], [[SetPlayerPoints command]], [[AddPlayerPoints command]], [[BuildTools command]], [[Spectate now allows you to free cam if no target is specified]], [[Power targetting]] }, Changes = { [[Performance improvements]], [[Updated help with new targetting]], [[Networking improvements for some commands ( Changelog, etc )]] } },
	
	{ Version = "0.15.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[TeamRespawn command]] } },
	
	{ Version = "0.14.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[ResetStats command]], [[Lots of aliases for commands]] }, Changes = { [[Fixed a bug with user power level]] } },
	
	{ Version = "0.13.0", SetupVersion = "1.0.0", Contributors = { "Nawmis" }, Additions = { [[Gravity command]] } },
	
	{ Version = "0.12.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[TargetLib now uses the new Team:GetPlayers( ) and Player.Team for team related handling]] } },
	
	{ Version = "0.12.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Can now use ":" to run commands]] } },
	
	{ Version = "0.11.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Commands can now specify whether or not they can be repeated using the "repeat" command ( used for the "testcmds" and "repeat" commands )]] }, Changes = { [[Fixed console being unable to run "repeat" command]] } },
	
	{ Version = "0.11.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[TargetLib no longer requires "%" to be before a teams name if its not being used to target players ( e.g. "team/me/bright red" )]], [[Fixed multiple issues with commands when ran on the server side]], [[Change the Plr object for when the server runs a command to { UserId = "Console" }]], [[Other minor bug fixes with the util and how debug logs work]] } },
	
	{ Version = "0.10.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Seperated server side event handling into a seperate module to make life easier]], [[Changed the ping message]] } },
	
	{ Version = "0.9.2", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed Asset args not working with universal target symbol ( "*" )]] } },
	
	{ Version = "0.9.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Improved the UsernameFromID function to handle play solo players and guests]] } },
	
	{ Version = "0.9.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Use Players:GetNameFromUserIdAsync and Players:GetPlayerByUserID]], [[Fixed the missing ability to target a player via userid]], [[Fixed a few bugs with commands + targetting]], [[Instead of saving users with a power equal to "user" it now saves it as nil to be more efficient]] } },
	
	{ Version = "0.8.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed a bug with spectate FF]] } },
	
	{ Version = "0.7.4", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Cache the latest version available for 1 minute]] } },
	
	{ Version = "0.7.3", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Config bans can now specify a reason]] }, Changes = { [[Fixed 'logs' command]] } },
	
	{ Version = "0.7.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added an easier way to register Asset ArgTypes]] }, Changes = { [[Changed how Assets are verified]] } },
	
	{ Version = "0.7.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Improved responses when an argument is wrong for a command]], [[Added 'sound/soundid/plrs' command]], [[Added 'stopsounds' command]], [[Added SoundId ArgType]] } },
	
	{ Version = "0.6.1", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Changes = { [[Fixed a bug with h/ being overriden by help command alias]] } },
	
	{ Version = "0.6.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added the ability to negate objects from targetting '-obj', e.g. kill/all,-me]] } },
	
	{ Version = "0.5.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added 'permgive/plrs/tools' command]], [[Added 'permtake/plrs/tools' command]] }, Changes = { [[Rewritten some of the tool finding code]], [[Fixed arg names of multiples]] } },
	
	{ Version = "0.4.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added 'take/plrs/tools' command]] }, Changes = { [[TargetLib.FindTools can now find tools within specified objects]] } },
	
	{ Version = "0.3.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added 'give/plrs/tools' command]], [[Added Tools and Tool argtypes]] }, Changes = { [[Rewritten a lot of the targetting code]] } },
	
	{ Version = "0.2.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added 'watch/plr' command]], [[Added 'unwatch' command]], [[Added spectate client code]] } },
	
	{ Version = "0.1.0", SetupVersion = "1.0.0", Contributors = { "Partixel" }, Additions = { [[Added changelog]], [[Added 'changelog' command]] } }
	
}