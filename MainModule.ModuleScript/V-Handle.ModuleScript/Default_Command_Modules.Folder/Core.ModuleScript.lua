return function ( Main, Client, VH_Events )
	
	local Players, TextService, Heartbeat = game:GetService( "Players" ), game:GetService( "TextService" ), game:GetService( "RunService" ).Heartbeat
	
	Main.Commands.UpTime = {
		
		Alias = { "uptime", "serverage" },
		
		Description = "Prints how long the server has been up for",
		
		Category = "Core",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Silent then return true, "Server has been up for " .. string.format( "%.2d:%.2d:%.2d:%.2d", workspace.DistributedGameTime / ( 60 * 60 * 24 ), workspace.DistributedGameTime / ( 60 * 60 ) % 24, workspace.DistributedGameTime / 60 % 60, workspace.DistributedGameTime % 60 ) end
			
			Main.Util.SendMessage( Plr, "Server has been up for " .. string.format( "%.2d:%.2d:%.2d:%.2d", workspace.DistributedGameTime / ( 60 * 60 * 24 ), workspace.DistributedGameTime / ( 60 * 60 ) % 24, workspace.DistributedGameTime / 60 % 60, workspace.DistributedGameTime % 60 ), "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Destroy = {
		
		Alias = { "destroy" },
		
		Description = "Destroys the admin",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$owner, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Main.Destroy( )
			
			return true
			
		end
		
	}
	
	Main.Commands.UpdateConfig = {
		
		Alias = { "updateconfig" },
		
		Description = "Prints your config updated to the latest version",
		
		Category = "Core",
		
		CanRun = "$owner, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if not game:GetService( "RunService" ):IsStudio( ) then return false, "Must be run from PlaySolo" end
			
			for a = 1, 500 do
				
				print( string.rep( " ", a % 2) )
				
			end
			
			print( Main.Util.CreateConfigString( Main.Config, Main.Changelog[ 2 ].SetupVersion ) .. "\n\n---------------------\n\nNext insert the 'V-Handle Setup' ( https://www.roblox.com/library/543870970/V-Handle-Setup ) model and paste the above text from 'local Config =' to 'return Config' into the new VH_Config\nFinally replace your V-Handle setup model in the ServerScriptService with this new one" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Update = {
		
		Alias = { "update" },
		
		Description = "Updates the module to the latest version",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$superadmin, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local NewMain = Main.GetLatest( )
			
			if not NewMain or type( NewMain ) == "string" then return false, NewMain end
			
			Main.Destroy( true )
			
			if pcall( function ( ) require( NewMain ) end ) and _G.VH_Admin then return true end
			
			require( game:GetService("ServerScriptService"):WaitForChild("V-Handle Setup"):WaitForChild("Setup"):WaitForChild( "OnFail" ) )
			
			return true
			
		end
		
	}
	
	Main.Commands.Reload = {
		
		Alias = { "reload" },
		
		Description = "Reloads the modules using a clone of itself (Useful when debugging updates with an unpublished version of the admin)",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$owner, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Clone = Main.Clone
			
			Main.Clone = nil
			
			Main.Destroy( true )
			
			if pcall( function ( ) require( Clone ) end ) and _G.VH_Admin then return true end
			
			require( game:GetService( "ServerStorage" ):WaitForChild( "EmergencyFunctions" ) )
			
			return true
			
		end
		
	}
	
	Main.Commands.Version = {
		
		Alias = { "version" },
		
		Description = "Prints the current version of the admin",
		
		Category = "Core",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Silent then return true, "V-Handle Version - " .. Main.Changelog[ 2 ].Version .. "\nSetup Version - " .. Main.Changelog[ 2 ].SetupVersion .. ( Main.Changelog[ 2 ].Timestamp and "\nLast Updated - " .. Main.Util.FormatTime( Main.Changelog[ 2 ].Timestamp ) or "" ) end
			
			Main.Util.SendMessage( Plr, "V-Handle Version - " .. Main.Changelog[ 2 ].Version .. "\nSetup Version - " .. Main.Changelog[ 2 ].SetupVersion .. ( Main.Changelog[ 2 ].Timestamp and "\nLast Updated - " .. Main.Util.FormatTime( Main.Changelog[ 2 ].Timestamp ) or "" ), "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.ChangeLog = {
		
		Alias = { "changelog", "changes" },
		
		Description = "Prints the latest changes to the admin",
		
		Category = "Core",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Name = "version_or_'versions'" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Changelog
			
			if Args[ 1 ] then
				
				if Args[ 1 ]:sub( 1, 1 ) == Main.TargetLib.ValidChar then Args[ 1 ] = "1" end
				
				if Args[ 1 ]:lower( ) == "versions" then
					
					local Versions = { }
					
					for a = 2, 11 do
						
						Versions[ #Versions + 1 ] = Main.Changelog[ a ].Version .. ( Main.Changelog[ a ].Timestamp and " - " .. Main.Util.FormatTime( Main.Changelog[ a ].Timestamp ) or "" )
						
					end
					
					if Silent then return true, "V-Handle Versions:\n" .. table.concat( Versions, "\n" ) end
					
					Main.Util.SendMessage( Plr, "V-Handle Versions:\n" .. table.concat( Versions, "\n" ), "Info" )
					
					return true
					
				end
				
				local Pattern = "%f[%d]" .. Args[ 1 ] .. "%f[%D]"
				
				for a = 2, #Main.Changelog do
					
					if Main.Changelog[ a ].Version == Args[ 1 ] then
						
						Changelog = Main.Changelog[ a ]
						
						break
						
					else
						
						if Main.Changelog[ a ].Version:find( Pattern ) then
							
							Changelog = Main.Changelog[ a ]
							
						end
						
					end
					
				end
				
			else
				
				Changelog = Main.Changelog[ 2 ]
				
			end
			
			if not Changelog then return false, "Invalid version" end
			
			if Silent then return true, "Version - " .. Changelog.Version .. "\nSetupVersion - " .. Changelog.SetupVersion .. ( Changelog.Timestamp and "\nLast Updated - " .. Main.Util.FormatTime( Changelog.Timestamp ) or "" ) .. "\nContributors - " .. table.concat( Changelog.Contributors, ", " ) .. ( Changelog.Additions and "\nAdditions:\n" .. table.concat( Changelog.Additions, "\n" ) or "" ) .. ( Changelog.Removals and "\nRemovals:\n" .. table.concat( Changelog.Removals, "\n" ) or "" ) .. ( Changelog.Changes and "\nChanges:\n" .. table.concat( Changelog.Changes, "\n" ) or "" ) end
			
			Main.Util.SendMessage( Plr, "Version - " .. Changelog.Version .. "\nSetupVersion - " .. Changelog.SetupVersion .. ( Changelog.Timestamp and "\nLast Updated - " .. Main.Util.FormatTime( Changelog.Timestamp ) or "" ) .. "\nContributors - " .. table.concat( Changelog.Contributors, ", " ) .. ( Changelog.Additions and "\nAdditions:\n" .. table.concat( Changelog.Additions, "\n" ) or "" ) .. ( Changelog.Removals and "\nRemovals:\n" .. table.concat( Changelog.Removals, "\n" ) or "" ) .. ( Changelog.Changes and "\nChanges:\n" .. table.concat( Changelog.Changes, "\n" ) or "" ), "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.TODO = {
		
		Alias = { "todo" },
		
		Description = "Prints the latest TODO list for the admin",
		
		Category = "Core",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Latest = Main.Changelog[ 1 ]
			
			if Silent then return true, "V-Handle TODO\n" .. Latest end
			
			Main.Util.SendMessage( Plr, "V-Handle TODO\n" .. Latest, "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Console = {
		
		Alias = { "console" },
		
		Description = "Runs the proceeding commands as the console",
		
		Category = "Core",
		
		CanRun = "16015142",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if #NextCmds == 0 then return false, "No commands to run" end
			
			local Console = setmetatable( { UserId = "Console", Name = "Console", Origin = Plr }, { __tostring = Main.ConsoleToString } )
			
			Main.RunCmdStacks( Console, NextCmds, Silent )
			
			for a = #NextCmds, 1, -1 do
				
				NextCmds[ a ] = nil
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.UserPower = {
		
		Alias = { "power", "userpower" },
		
		Description = "Tells you your current user power",
		
		Category = "Core",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.UserId, Default = Main.TargetLib.Defaults.SelfId } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local UserPower = Main.GetUserPower( Args[ 1 ] )
			
			local String = Main.Util.Pluralise( Main.Util.UsernameFromID( Args[ 1 ] ) ) .. " user power is " .. Main.UserPowerName( UserPower ) .. ( Main.IsDebugger( Args[ 1 ] ) and " and they are a debugger!" or "" )
			
			if Silent then return true, String end
			
			Main.Util.SendMessage( Plr, String, "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.SetUserPower = {
		
		Alias = { "setpower", "sp", "setuserpower", "sup", { function ( self, Alias ) return Main.UserPower[ Alias ] ~= nil, { nil, Main.UserPower[ Alias ] } end, "user" } },
		
		Description = "Sets the specified players user power for the current server",
		
		Category = "Core",
		
		CanRun = "$supermod",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.PowerNumber, Required = true, Default = function ( self, Strings, Plr, Last, Alias )
			
			if Strings[ 1 ] == Main.TargetLib.ValidChar then return Main.UserPower.admin end
			
			return Main.UserPower[ Alias ]
			
		end } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local UserPower = Main.GetUserPower( Plr.UserId )
			
			local Plrs, TargetPower = Args[ 1 ], Args[ 2 ]
			
			if TargetPower >= UserPower then return false, "Cannot target specified user power" end
			
			if TargetPower == Main.UserPower.owner or TargetPower == Main.UserPower.console then return false, "Cannot target specified user power" end
			
			local TargetPowerName = Main.UserPowerName( TargetPower )
			
			local Invalid = { }
			
			for a = 1, #Plrs do
				
				local PlrsPower = Main.GetUserPower( Plrs[ a ].UserId )
				
				if PlrsPower < UserPower and PlrsPower ~= TargetPower and Plr ~= Plrs[ a ] then
					
					Main.UserPowersStore.Local[tostring(Plrs[ a ].UserId)] = TargetPowerName
					
					Main.SetUserPower( Plrs[ a ].UserId, TargetPower )
					
					if not Silent then
						
						Main.Util.SendMessage( Plrs[ a ], "Your new user power is '" .. TargetPowerName .. "'!", "Info" )
						
					end
					
				else
					
					Invalid[ #Invalid + 1 ] = Plrs[ a ]
					
				end
				
			end
			
			if #Invalid == 0 then
				
				return true
				
			else
				
				local String = ""
				
				for a = 1, #Invalid do
					
					String = String .. Invalid[ a ].Name .. " can't be targeted by this command"
					
					if a ~= #Invalid then String = String .. "\n" end
					
				end
				
				return false, String
				
			end
			
		end
		
	}
	
	Main.Commands.PermUserPower = {
		
		Alias = { "permpower", "pp", "permuserpower", "pup", { function ( self, Alias, Plr )
			
			if Alias:sub( 1, 4 ) == "perm" then
				
				return Main.UserPower[ Alias:sub( 5 ) ] ~= nil, { nil, Main.UserPower[ Alias:sub( 5 ) ] }
				
			end
			
			if Alias:sub( 1, 4 ) == "p" then
				
				return Main.UserPower[ Alias:sub( 2 ) ] ~= nil, { nil, Main.UserPower[ Alias:sub( 2 ) ] }
				
			end
			
		end, "permuser" } },
		
		Description = "Sets the specified player user power permanently for all servers",
		
		Category = "Core",
		
		CanRun = "$superadmin",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.UserId, Required = true }, { Func = Main.TargetLib.ArgTypes.PowerNumber, Default = function ( self, Strings, Plr, Last, Alias )
			
			if Strings[ 1 ] == nil then return end
			
			if Strings[ 1 ] == Main.TargetLib.ValidChar then return Main.UserPower.admin end
			
			return Main.UserPower[ Alias:sub( 5 ) ] or Main.UserPower[ Alias:sub( 2 ) ]
			
		end } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local UserPower = Main.GetUserPower( Plr.UserId )
			
			local Ids, TargetPower = { Args[ 1 ] }, Args[ 2 ]

			local TargetPowerName = Main.UserPowerName( TargetPower )
			
			if TargetPower and TargetPower >= UserPower then return false, "Cannot set to " .. TargetPowerName .. " because it is above your user power" end
			
			if TargetPower == Main.UserPower.owner or TargetPower == Main.UserPower.console then return false, "Cannot set to " .. TargetPowerName .. " because it is restricted" end
			
			local Invalid = { }
			
			for a = 1, #Ids do
				
				local PlrsPower = Main.GetUserPower(Ids[a])
				
				if PlrsPower < UserPower and PlrsPower ~= TargetPower and Plr.UserId ~= Ids[ a ] then
					
					Main.UserPowersStore.Local[tostring(Ids[a])] = nil
					if game.PrivateServerId ~= "" then
						Main.UserPowersStore.VIPDataStore[tostring(Ids[a])] = TargetPower and TargetPowerName or nil
					else
						Main.UserPowersStore.DataStore[tostring(Ids[a])] = TargetPower and TargetPowerName or nil
					end
					
					Main.SetUserPower( Ids[ a ], TargetPower )
					
					Main.DataStore:UpdateAsync(game.PrivateServerId ~= "" and (game.PrivateServerId .. "VIPUserPowers") or "UserPowers", function(Value)
						Value = Value or {}
						Value[tostring(Ids[a])] = TargetPower and TargetPowerName or nil
						return Value
					end)
					
					local TPlr = Players:GetPlayerByUserId(Ids[a])
					
					if TPlr and not Silent then
						
						Main.Util.SendMessage( TPlr, "Your new user power is '" .. TargetPowerName .. "'!", "Info" )
						
					end
					
				else
					
					Invalid[ #Invalid + 1 ] = Ids[ a ]
					
				end
				
			end
			
			if #Invalid == 0 then
				
				return true
				
			else
				
				local String = ""
				
				for a = 1, #Invalid do
					
					String = String .. Main.Util.UsernameFromID( Invalid[ a ] ) .. " can't be targeted by this command"
					
					if a ~= #Invalid then String = String .. "\n" end
					
				end
				
				return false, String
				
			end
			
		end
		
	}
	
	Main.Commands.Kick = {
		
		Alias = { "kick" },
		
		Description = "Kicks the specified player",
		
		Category = "Core",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Player, Required = true }, Main.TargetLib.ArgTypes.String },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local UserPower = Main.GetUserPower( Plr.UserId )
			
			local FilterResult = Args[ 2 ] and TextService:FilterStringAsync( Args[ 2 ], Plr.UserId )
			
			if Main.GetUserPower( Args[ 1 ].UserId ) <= UserPower and Plr ~= Args[ 1 ] then
				
				if Main.Config.AnnounceLeft then
					
					Main.AnnouncedLeft[ Args[ 1 ] ] = " has been kicked" .. ( Args[ 2 ] and ( " for " .. FilterResult:GetChatForUserAsync( Args[ 1 ].UserId ) ) or "" )
					
				end
				
				Args[ 1 ]:Kick( Args[ 2 ] and FilterResult:GetChatForUserAsync( Args[ 1 ].UserId ) or "You have been kicked by " .. Plr.Name )
				
			else
				
				return false, Args[ 1 ].Name .. " can't be targeted by this command"
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Ban = {
		
		Alias = { "ban" },
		
		Description = "Bans the specified player(s) from the current server",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.UserId, Required = true }, Main.TargetLib.ArgTypes.String, Main.TargetLib.ArgTypes.Time },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local UserPower = Main.GetUserPower( Plr.UserId )
			
			local FilterResult = Args[ 2 ] and TextService:FilterStringAsync( Args[ 2 ], Plr.UserId )
			
			local Time = true
			
			if Args[ 3 ] then Time = os.time( ) + Args[ 3 ] end
			
			if Main.GetUserPower( Args[ 1 ] ) <= UserPower and Plr.UserId ~= Args[ 1 ] then
				
				Main.BanStore.Local[tostring(Args[1])] = {Time = Time, Reason = Args[ 2 ], Banner = Plr.UserId, Username = Main.Util.UsernameFromID( Args[ 1 ] )}
				
				local Banned = Players:GetPlayerByUserId( Args[ 1 ] )
				
				if Banned then
					
					if Main.Config.AnnounceLeft then
						
						Main.AnnouncedLeft[ Banned ] = " has been banned" .. ( Args[ 2 ] and ( " for " .. FilterResult:GetNonChatStringForBroadcastAsync() ) or "" )
						
					end
					
					Banned:Kick( "You have been banned by " .. Plr.Name .. ( Args[ 2 ] and ( " for " .. FilterResult:GetChatForUserAsync( Args[ 1 ] ) ) or "" ) .. (type(Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(Time)) or "") )
					
				end
				
			else
				
				return false, Main.Util.UsernameFromID( Args[ 1 ] ) .. " can't be targeted by this command"
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.PermBan = {
		
		Alias = { "permban" },
		
		Description = "Bans the specified player from all servers",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$superadmin",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.UserId, Required = true }, Main.TargetLib.ArgTypes.String, Main.TargetLib.ArgTypes.Time },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local UserPower = Main.GetUserPower( Plr.UserId )
			
			local FilterResult = Args[ 2 ] and TextService:FilterStringAsync( Args[ 2 ], Plr.UserId )
			
			local Time = true
			
			if Args[ 3 ] then Time = os.time( ) + Args[ 3 ] end
			
			if Main.GetUserPower( Args[ 1 ] ) <= UserPower and Plr.UserId ~= Args[ 1 ] then
				
				Main.BanStore.Local[tostring(Args[1])] = nil
				if game.PrivateServerId ~= "" then
					Main.BanStore.VIPDataStore[tostring(Args[1])] = { Time = Time, Banner = Plr.UserId, Reason = Args[ 2 ], Perm = true, Username = Main.Util.UsernameFromID( Args[ 1 ] ) }
				else
					Main.BanStore.DataStore[tostring(Args[1])] = { Time = Time, Banner = Plr.UserId, Reason = Args[ 2 ], Perm = true, Username = Main.Util.UsernameFromID( Args[ 1 ] ) }
				end
				
				Main.DataStore:UpdateAsync(game.PrivateServerId ~= "" and (game.PrivateServerId .. "VIPBans") or "Bans", function(Value)
					Value = Value or {}
					Value[tostring(Args[1])] = { Time = Time, Banner = Plr.UserId, Reason = Args[ 2 ], Perm = true, Username = Main.Util.UsernameFromID( Args[ 1 ] ) }
					return Value
				end)
				
				local Banned = Players:GetPlayerByUserId( Args[ 1 ] )
				
				if Banned then
					
					if Main.Config.AnnounceLeft then
						
						Main.AnnouncedLeft[ Banned ] = " has been banned" .. ( Args[ 2 ] and ( " for " .. FilterResult:GetNonChatStringForBroadcastAsync() ) or "" )
						
					end
					
					Banned:Kick( "You have been banned by " .. Plr.Name .. ( Args[ 2 ] and ( " for " .. FilterResult:GetChatForUserAsync( Args[ 1 ] ) ) or "" ) .. (type(Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(Time)) or ""))
					
				end
				
			else
				
				return false, Main.Util.UsernameFromID( Args[ 1 ] ) .. " can't be targeted by this command"
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.UnBan = {
		
		Alias = { "unban" },
		
		Description = "Unbans the specified player(s)",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = function ( self, Strings, Plr )
			
			local String = table.remove( Strings, 1 )
			
			if String == Main.TargetLib.ValidChar then return nil, false end
			
			String = String:lower( )
			
			for a, b in pairs(Main.BanStore.Local) do
				
				if String == a then
					
					return {a, "Local"}
					
				elseif type(b) == "table" and b.Username then
					
					if b.Username:lower() == String then
						
						return {a, "Local"}
						
					end
					
				elseif Main.Util.UsernameFromID( a ):lower( ) == String then
					
					return {a, "Local"}
					
				end
				
			end
			
			for a, b in pairs(game.PrivateServerId ~= "" and Main.BanStore.VIPDataStore or Main.BanStore.DataStore) do
				
				if String == a then
					
					return {a, game.PrivateServerId ~= "" and "VIPDataStore" or "DataStore"}
					
				elseif type(b) == "table" and b.Username then
					
					if b.Username:lower() == String then
						
						return {a, game.PrivateServerId ~= "" and "VIPDataStore" or "DataStore"}
						
					end
					
				elseif Main.Util.UsernameFromID( a ):lower( ) == String then
					
					return {a, game.PrivateServerId ~= "" and "VIPDataStore" or "DataStore"}
					
				end
				
			end
			
			return nil, false
			
		end, Required = true, Name = "player" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Args[1][2] == "Local" then
				Main.BanStore.Local[Args[1][1]] = nil
			else
				if Main.TargetLib.MatchesPlr(Main.Commands.PermBan.CanRun, Plr) then
					return false, "Not enough user power to remove a permanent ban!"
				else
					Main.BanStore[Args[1][2]][Args[1][1]] = nil
					Main.DataStore:UpdateAsync(game.PrivateServerId ~= "" and (game.PrivateServerId .. "VIPBans") or "Bans", function(Value)
						Value = Value or {}
						Value[Args[1][1]] = nil
						return Value
					end)
				end
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.ArgTest = {
		
		Alias = { "argtest" },
		
		Description = "A command that tests of arg types",
		
		Category = "Debug",
		
		CanRun = "$admin, $debugger",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.ArgType, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Results = { table.remove( Args, 1 )( { }, Args, Plr ) }
			
			if #Results == 1 and type( Results[ 1 ] ) == "table" then Results = Results[ 1 ] end
			
			for a = 1, Main.Util.TableHighestKey( Results ) do
				
				if Results[ a ] == nil then
					
					Results[ a ] = "nil"
					
				else
					
					Results[ a ] = tostring( Results[ a ] )
					
				end
				
			end
			
			if Silent then return true, table.concat( Results, " " ) end
			
			Main.Util.SendMessage( Plr, table.concat( Results, " " ), "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Shutdown = {
		
		Alias = { "shutdown" },
		
		Description = "Shuts the server down",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$admin, $debugger",
		
		ArgTypes = { { Func = function ( self, Strings, Plr )
			
			return table.remove( Strings, 1 ) == "confirm" or nil
			
		end, Required = true, Name = "'confirm'" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Players.PlayerAdded:Connect( function ( Plr )
				
				Plr:Kick( Plr.Name .. " has shutdown the server" )
				
			end )
			
			local Plrs = Players:GetPlayers( )
			
			for a = 1, #Plrs do
				
				Plrs[ a ]:Kick( Plr.Name .. " has shutdown the server" )
				
			end
			
			return true
			
		end
		
	}
	
	local PlrLogs = ( _G.VH_Saved or { } ).PlrLogs or { }
	
	local ChangedEvents = { }
	
	local Plrs = Players:GetPlayers( )
	
	for a = 1, #Plrs do
		
		PlrLogs[ #PlrLogs + 1 ] = { os.time( ), Plrs[ a ].UserId, " - Joined" }
		
		ChangedEvents[ Plrs[ a ] ] = Plrs[ a ].Changed:Connect( function ( Property )
			
			pcall( function ( ) PlrLogs[ #PlrLogs + 1 ] =  { os.time( ), Plrs[ a ].UserId, " - " .. Property .. " changed to " .. tostring( Plrs[ a ][ Property ] ) } end )
			
		end )
		
	end
	
	Main.Events[ #Main.Events + 1 ] = Players.PlayerAdded:Connect( function ( Plr )
		
		PlrLogs[ #PlrLogs + 1 ] = { os.time( ), Plr.UserId, " - Joined" }
		
		ChangedEvents[ Plr ] = Plr.Changed:Connect( function ( Property )
			
			pcall( function ( ) PlrLogs[ #PlrLogs + 1 ] = { os.time( ), Plr.UserId, " - " .. Property .. " changed to " .. tostring( Plr[ Property ] ) } end )
			
		end )
		
	end )
	
	Main.Events[ #Main.Events + 1 ] = Players.PlayerRemoving:Connect( function ( Plr )
		
		PlrLogs[ #PlrLogs + 1 ] = { os.time( ), Plr.UserId, " - Left" }
		
		if ChangedEvents[ Plr ] then
			
			ChangedEvents[ Plr ]:Disconnect( )
			
			ChangedEvents[ Plr ] = nil
			
		end
		
	end )
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		for a, b in pairs( ChangedEvents ) do
			
			b:Disconnect( )
			
		end
		
		if not Update then return end
		
		_G.VH_Saved.PlrLogs = PlrLogs
		
	end )
	
	Main.Commands.PlayerLogs = {
		
		Alias = { "playerlogs", "plrlogs" },
		
		Description = "Displays a list of joins, player changes and disconnects",
		
		Category = "Core",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Str = "Player Logs:\n"
			
			for a = 1, #PlrLogs do
				
				Str = Str .. Main.Util.TimeSince( PlrLogs[ a ][ 1 ] ) .. " - " .. Main.Util.UsernameFromID( PlrLogs[ a ][ 2 ] ) .. ":" .. PlrLogs[ a ][ 2 ] .. ( PlrLogs[ a ][ 3 ]  or "" ) .. "\n"
				
			end
			
			if #PlrLogs == 0 then
				
				Str = "No player log entries exist"
				
			else
				
				Str = Str:sub( 1, -2 )
				
			end
			
			Main.Util.PrintClient( Plr, Str )
			
			if Silent then return true, "Check your client log ( F9 )" end
			
			Main.Util.SendMessage( Plr, "Check your client log ( F9 )", "Info" )
			
			return true
			
		end
		
	}
	
	local ChatLogs = ( _G.VH_Saved or { } ).ChatLogs or { }
	
	local ChattedEvents = { }
	
	local Plrs = Players:GetPlayers( )
	
	for a = 1, #Plrs do
		
		ChatLogs[ #ChatLogs + 1 ] = { os.time( ), Plrs[ a ].UserId, " - Joined" }
		
		ChattedEvents[ Plrs[ a ] ] = Plrs[ a ].Chatted:Connect( function ( Msg, Target )
			
			ChatLogs[ #ChatLogs + 1 ] = { os.time( ), Plrs[ a ].UserId, ": " .. Msg .. ( Target and " @ " .. Target.Name or "" ) }
			
		end )
		
	end
	
	Main.Events[ #Main.Events + 1 ] = Players.PlayerAdded:Connect( function ( Plr )
		
		ChatLogs[ #ChatLogs + 1 ] = { os.time( ), Plr.UserId, " - Joined" }
		
		ChattedEvents[ Plr ] = Plr.Chatted:Connect( function ( Msg, Target )
			
			ChatLogs[ #ChatLogs + 1 ] = { os.time( ), Plr.UserId, ": " .. Msg .. ( Target and " @ " .. Target.Name or "" ) }
			
		end )
		
	end )
	
	Main.Events[ #Main.Events + 1 ] = Players.PlayerRemoving:Connect( function ( Plr )
		
		ChatLogs[ #ChatLogs + 1 ] = { os.time( ), Plr.UserId, " - Left" }
		
		if ChattedEvents[ Plr ] then
			
			ChattedEvents[ Plr ]:Disconnect( )
			
			ChattedEvents[ Plr ] = nil
			
		end
		
	end )
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		for a, b in pairs( ChattedEvents ) do
			
			b:Disconnect( )
			
		end
		
		if not Update then return end
		
		_G.VH_Saved.ChatLogs = ChatLogs
		
	end )
	
	Main.Commands.ChatLogs = {
		
		Alias = { "chatlogs" },
		
		Description = "Displays the chat history for the server",
		
		Category = "Core",
		
		CanRun = "$mod, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Str = "Chat Logs:\n"
			
			for a = 1, #ChatLogs do
				
				Str = Str .. Main.Util.TimeSince( ChatLogs[ a ][ 1 ] ) .. " - " .. Main.Util.UsernameFromID( ChatLogs[ a ][ 2 ] ) .. ":" .. ChatLogs[ a ][ 2 ] .. ( ChatLogs[ a ][ 3 ]  or "" ) .. "\n"
				
			end
			
			if #ChatLogs == 0 then
				
				Str = "No chat log entries exist"
				
			else
				
				Str = Str:sub( 1, -2 )
				
			end
			
			Main.Util.PrintClient( Plr, Str )
			
			if Silent then return true, "Check your client log ( F9 )" end
			
			Main.Util.SendMessage( Plr, "Check your client log ( F9 )", "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.CleanUp = {
		
		Alias = { "cleanup", "clean" },
		
		Description = "Removes any objects the admin has created",
		
		Category = "Core",
		
		CanRun = "$moderator, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a, b in pairs( Main.Objs ) do
				
				b:Destroy( )
				
			end
			
			local Objs = workspace:GetChildren( )
			
			for a = 1, #Objs do
				
				if Objs[ a ]:IsA( "Hat" ) or Objs[ a ]:IsA( "Tool" ) or Objs[ a ]:IsA( "HopperBin" ) then
					
					Objs[ a ]:Destroy( )
					
				end
				
			end
			
			Client.Cleanup:FireAllClients( )
			
			if Silent then return true, "Cleanup complete!" end
			
			Main.Util.SendMessage( Plr, "Cleanup complete!", "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Log = {
		
		Alias = { "log" },
		
		Description = "Logs whatever arguments are passed",
		
		Category = "Core",
		
		CanRun = "$moderator",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			return true
			
		end
		
	}
	
	local Errors = ( _G.VH_Saved or { } ).Errors or { }
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then return end
		
		_G.VH_Saved.Errors = Errors
		
	end )
	
	Main.CommandRan.Event:Connect(function(Success, Ran, RanMsg, Plr, Cmd)
		if not Success then
			Errors[ #Errors + 1 ] = {Cmd, Ran}
		end
	end)
	
	Main.Commands.Errors = {
		
		Alias = { "errors" },
		
		Description = "Lists all the errors the admin has encountered",
		
		Category = "Debug",
		
		CanRun = "$admin, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if #Errors == 0 then Main.Util.PrintClient( Plr, "No errors have been encountered!" ) return true end
			
			local Str = ""
			
			for a = 1, #Errors do
				
				Str = Errors[ a ][ 1 ] .. " - " .. Errors[ a ][ 2 ] .. "\n"
				
			end
			
			Main.Util.PrintClient( Plr, Str:sub( 1, -2 ) )
			
			return true
			
		end
		
	}
	
	Main.Commands.TestError = {
		
		Alias = { "testerror" },
		
		Description = "Causes an error for testing purposes",
		
		Category = "Debug",
		
		CanRun = "$admin, $debugger",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Args[ 1 ] then
				
				error( Args[ 1 ] )
				
			else
				
				print( ( nil )( ) )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.TestClientError = {
		
		Alias = { "testclienterror" },
		
		Description = "Causes an error on the client for testing purposes",
		
		Category = "Debug",
		
		CanRun = "$admin&!$console, $debugger&!$console",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Client.TestClientError:FireClient( Plr, Args[ 1 ] )
			
			return true
			
		end
		
	}
	
	Main.Commands.TestCmd = {
		
		Alias = { "testcmd" },
		
		Description = "Runs a command with the supplied arguments and returns the time it takes to run",
		
		Category = "Debug",
		
		NoTest = true,
		
		NoRepeat = true,
		
		CanRun = "$admin, $debugger",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Name = "Command", Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Timer = tick( )
			
			local Ran, Msg, Errored = Main.ParseCmdStacks( Plr, Args[ 1 ] .. "/?/?/?/?/?/?", nil, true )
			
			Timer = tick( ) - Timer
			
			if Errored then
				
				Main.Util.SendMessage( Plr, "Errored - " .. Timer * 1000 .. "ms" .. ( Msg and " - " .. Msg or "" ), BrickColor.Red( ).Color )
			
			elseif Ran == true then
				
				Main.Util.SendMessage( Plr, "Passed - " .. Timer * 1000 .. "ms" .. ( Msg and " - " .. Msg or "" ), BrickColor.Green( ).Color )
				
			else
				
				Main.Util.SendMessage( Plr, "Failed - " .. Timer * 1000 .. "ms" .. ( Msg and " - " .. Msg or "" ), BrickColor.Yellow( ).Color )
				
			end
			
			return true
			
		end
		
	}
	
	local TestResults = { { }, { } }
	
	local Testing
	
	Main.Commands.TestCmds = {
		
		Alias = { "testcmds" },
		
		Description = "Runs every command once with the arguments supplied",
		
		Category = "Debug",
		
		NoTest = true,
		
		NoRepeat = true,
		
		CanRun = "$admin, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Testing then return false, "Test in progress by " .. Testing end
			
			Testing = ( Plr and Plr.Name or "Console" )
			
			local Cmds = { }
			
			for a, b in pairs( Main.Commands ) do
				
				if not b.NoTest then
					
					Cmds[ #Cmds + 1 ] = type( b.Alias[ 1 ] ) == "string" and b.Alias[ 1 ] or b.Alias[ 1 ][ 2 ]
					
				end
				
			end
			
			table.sort( Cmds )
			
			TestResults = { { }, { }, { } }
			
			-- Special loop code because loop must be ran before endloop and with commands after
			
			for a = 1, #Cmds do
				
				Main.Util.SendMessage( Plr, "Testing command " .. Cmds[ a ] .. " - " .. a .. " / " .. #Cmds, BrickColor.Blue( ).Color )
				
				local Timer, Ran, Msg, Errored = tick( )
				
				Ran, Msg, Errored = Main.ParseCmdStacks( Plr, Cmds[ a ] .. "/?/?/?/?/?/?/?", nil, true )
				
				Timer = tick( ) - Timer
				
				if Errored then
					
					Main.Util.SendMessage( Plr, "Errored - " .. Timer * 1000 .. "ms" .. ( Msg and " - " .. Msg or "" ), BrickColor.Red( ).Color )
					
					TestResults[ 3 ][ #TestResults[ 3 ] + 1 ] = { Cmds[ a ], Timer, Msg }
				
				elseif Ran == true then
					
					Main.Util.SendMessage( Plr, "Passed - " .. Timer * 1000 .. "ms" .. ( Msg and " - " .. Msg or "" ), BrickColor.Green( ).Color )
					
					TestResults[ 1 ][ #TestResults[ 1 ] + 1 ] = { Cmds[ a ], Timer, Msg }
					
				else
					
					Main.Util.SendMessage( Plr, "Failed - " .. Timer * 1000 .. "ms" .. ( Msg and " - " .. Msg or "" ), BrickColor.Yellow( ).Color )
					
					TestResults[ 2 ][ #TestResults[ 2 ] + 1 ] = { Cmds[ a ], Timer, Msg }
					
				end
				
				wait( )
				
			end
			
			if #TestResults[ 1 ] == 0 then 
				
				Main.Util.SendMessage( Plr, "None passed", BrickColor.Red( ).Color )
				
			else
				
				Main.Util.SendMessage( Plr, #TestResults[ 1 ] .. " passed", BrickColor.Green( ).Color )
				
			end
			
			if #TestResults[ 2 ] == 0 then 
				
				Main.Util.SendMessage( Plr, "None couldn't run", BrickColor.Yellow( ).Color )
				
			else
				
				Main.Util.SendMessage( Plr, #TestResults[ 2 ] .. " couldn't run", BrickColor.Yellow( ).Color )
				
			end
			
			if #TestResults[ 3 ] == 0 then 
				
				Main.Util.SendMessage( Plr, "None errored", BrickColor.Green( ).Color )
				
			else
				
				Main.Util.SendMessage( Plr, #TestResults[ 3 ] .. " errored", BrickColor.Red( ).Color )
				
			end
			
			Testing = nil
			
			return true
			
		end
		
	}
	
	Main.Commands.TestResults = {
		
		Alias = { "testresults" },
		
		Description = "Shows the results of the last test ran",
		
		Category = "Debug",
		
		NoTest = true,
		
		NoRepeat = true,
		
		CanRun = "$admin, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Testing then return false, "Test in progress by " .. Testing end
			
			if #TestResults[ 1 ] == 0 and #TestResults[ 2 ] == 0 then return false, "No results found, try running 'testcmds'" end
			
			Plr = type( Plr ) == "table" and Plr.Origin or Plr
			
			if Plr.UserId == "Console" then
				
				local SortMode = 1 -- 0 = Name 1 = Time
				
				local Pass, Fail, Errored = TestResults[ 1 ], TestResults[ 2 ], TestResults[ 3 ]
				
				table.sort( Pass, function ( a, b )
					
					if SortMode == 0 then
						
						return a[ 1 ] < b[ 1]
						
					else
						
						return a[ 2 ] > b[ 2 ]
						
					end
					
				end )
				
				table.sort( Fail, function ( a, b )
					
					if SortMode == 0 then
						
						return a[ 1 ] < b[ 1]
						
					elseif SortMode == 1 then
						
						return a[ 2 ] > b[ 2 ]
						
					end
					
				end )
				
				table.sort( Errored, function ( a, b )
					
					if SortMode == 0 then
						
						return a[ 1 ] < b[ 1]
						
					elseif SortMode == 1 then
						
						return a[ 2 ] > b[ 2 ]
						
					end
					
				end )
				
				if #Pass == 0 then 
					
					print( "None passed" )
					
				else
					
					print( #Pass .. " passed" )
					
				end
				
				if #Fail == 0 then 
					
					print( "None couldn't run" )
					
				else
					
					print( #Fail .. " couldn't run" )
					
				end
				
				if #Errored == 0 then 
					
					print( "None errored" )
					
				else
					
					print( #Errored .. " errored" )
					
				end
				
				if #Pass ~= 0 then 
					
					print( "Passes:" )
					
					for a = 1, #Pass do
						
						print( Pass[ a ][ 1 ] .. ( Pass[ a ][ 3 ] and ( " - " .. Pass[ a ][ 3 ] ) or "" ) .. " - " .. ( Pass[ a ][ 2 ] * 1000 ) .. "ms" )
						
					end
					
				end
				
				if #Fail ~= 0 then 
					
					print( "Fails:" )
					
					for a = 1, #Fail do
						
						print( Fail[ a ][ 1 ] .. ( Fail[ a ][ 3 ] and ( " - " .. Fail[ a ][ 3 ] ) or "" ) .. " - " .. ( Fail[ a ][ 2 ] * 1000 ) .. "ms"  )
						
					end
					
				end
				
				if #Errored ~= 0 then 
					
					print( "Errors:" )
					
					for a = 1, #Errored do
						
						print( Errored[ a ][ 1 ] .. ( Errored[ a ][ 3 ] and ( " - " .. Errored[ a ][ 3 ] ) or "" ) .. " - " .. ( Errored[ a ][ 2 ] * 1000 ) .. "ms"  )
						
					end
					
				end
				
			else
				
				Client.TestResults:FireClient( Plr, TestResults )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.KeyBind = {
		
		Alias = { "keybind", "bind" },
		
		Description = "Binds any proceeding commands to the specified key",
		
		Category = "Core",
		
		CanRun = "!$console",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Key, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Cmd = ""
			
			local Num = #NextCmds
			
			for a = 1, Num do
				
				Cmd = Cmd .. NextCmds[ a ][ 3 ] .. "/" .. table.concat( NextCmds[ a ][ 4 ], "/" ) .. ( a == Num and "" or "|" )
				
				NextCmds[ a ] = nil
				
			end
			
			Client.Bind:FireClient( Plr, Args[ 1 ], Cmd )
			
			return true
			
		end
		
	}
	
	Main.Commands.UnBind = {
		
		Alias = { "unbind" },
		
		Description = "Unbinds the specified key",
		
		Category = "Core",
		
		CanRun = "!$console",
		
		ArgTypes = { { Func = function ( self, Strings, Plr )
			
			local String = table.remove( Strings, 1 )
			
			return Main.TargetLib.IsWildcard( String:lower( ) ) ~= nil or Main.TargetLib.ArgTypes.Key( self, { String }, Plr )
			
		end, Required = true, Name = "key_or_wildcard" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Client.Bind:FireClient( Plr, Args[ 1 ] )
			
			return true
			
		end
		
	}
	
	local CmdHistory = ( _G.VH_Saved or { } ).CmdHistory or { }
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then return end
		
		_G.VH_Saved.CmdHistory = CmdHistory
		
	end )
	
	Main.CommandStackRan.Event:Connect(function(UserId, Msg, CmdStacks)
		local NoRepeat
		for _, CmdStack in ipairs(CmdStacks) do
			if CmdStack[ 1 ].NoRepeat then
				NoRepeat = true
				break
			end
		end
		
		if not NoRepeat then
			--------------- TODO Change from Msg to CmdStacks - Make logs/ and such check [ 3 ] and [ 4 ] for Cmd and StrArgs
			CmdHistory[UserId] = Msg
		end
	end)
	
	Main.Commands.Repeat = {
		
		Alias = { "repeat", "^" },
		
		Description = "Repeats the last command ran",
		
		Category = "Core",
		
		NoRepeat = true,
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Last = CmdHistory[ Plr.UserId ]
			
			if Last then
				
				Main.ParseCmdStacks( Plr, Last, nil, true )
				
				return true
				
			else
				
				return false, "No command to repeat!"
				
			end
			
		end
		
	}
	
	local Heartbeat = game:GetService( "RunService" ).Heartbeat
	
	Main.Commands.Loop = {
		
		Alias = { "loop" },
		
		Description = "Repeats any commands that proceed it an infinite amount of times OR until it has ran [repitions] times\nKey must be unique so that the loop can be ended via endloop/<key>\nExample: loop/uniquestring/5|kill/all|wait/5",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$moderator, $debugger",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Required = true }, { Func = Main.TargetLib.ArgTypes.Number, Default = 0 } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if #NextCmds == 0 then return false, "No commands to loop ( try loop/test:kill/me )" end
			
			local Key = Args[ 1 ]:lower( )
			
			if Main.Loops[ Key ] then return false, "Loop already exists" end
			
			local Reps = Args[ 2 ]
			
			local Speed = Reps ~= 0
			
			local Cur = ( Main.Loops[ Key ] or 0 ) + 1
			
			local WaitCmd, HasWait = Main.Commands.Wait, nil
			
			local Cmd = ""
			
			local Num = #NextCmds
			
			for a = 1, Num do
				
				Cmd = Cmd .. NextCmds[ a ][ 3 ] .. "/" .. table.concat( NextCmds[ a ][ 4 ], "/" ) .. ( a == Num and "" or "|" )
				
				if not HasWait then
					
					for b = 1, #WaitCmd.Alias do
						
						if WaitCmd.Alias[ b ] == NextCmds[ a ][ 3 ]:lower( ) then
							
							HasWait = true
							
							break
							
						end
					
					end
					
				end
				
				NextCmds[ a ] = nil
				
			end
			
			WaitCmd = nil
			
			Main.Loops[ Key ] = Cur
			
			for b = 1, Reps, ( Speed and 1 or -0 ) do
				
				if not HasWait then
					
					Heartbeat:Wait( )
					
				end
				
				if Main.Loops[ Key ] ~= Cur then
					
					for a = 1, #NextCmds do
						
						NextCmds[ a ] = nil
						
					end
					
					return true
					
				end
				
				Main.ParseCmdStacks( Plr, Cmd, nil, true )
				
			end
			
			for a = 1, #NextCmds do
				
				NextCmds[ a ] = nil
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.EndLoop = {
		
		Alias = { "endloop" },
		
		Description = "Ends a loop with the specified key",
		
		Category = "Core",
		
		NoTest = true,
		
		CanRun = "$moderator, $debugger",
		
		ArgTypes = { { Func = function ( self, Strings, Plr )
			
			local String = table.remove( Strings, 1 )
			
			if String == Main.TargetLib.ValidChar then
				
				local Key = next( Main.Loops )
				
				if Key then return Key end
				
				return nil, false
				
			end
			
			String = String:lower( )
			
			if String == "all" then return String end
			
			if Main.Loops[ String ] then return String end
			
			return nil, false
			
		end, Required = true, Name = "loop_key" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Args[ 1 ] == "all" then
				
				Main.Loops = { }
				
				return true
				
			end
			
			Main.Loops[ Args[ 1 ] ] = nil
			
			return true
			
		end
		
	}
	
	Main.Commands.Loops = {
		
		Alias = { "loops" },
		
		Description = "Lists all of the loops currently running",
		
		Category = "Core",
		
		CanRun = "$moderator, $debugger",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Str = ""
			
			for a, b in pairs( Main.Loops ) do
				
				Str = Str .. a .. "\n"
				
			end
			
			if Str == "" then
				
				Str = "No loops running"
				
			else
				
				Str = "Loops:\n" .. Str:sub( 1, -2 )
				
			end
			
			Main.Util.PrintClient( Plr, Str )
			
			if Silent then return true, "Check your client log ( F9 )" end
			
			Main.Util.SendMessage( Plr, "Check your client log ( F9 )", "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Bans = {
		Alias = {"bans", "banlist"},
		Description = "Lists all of the bans",
		Category = "Core",
		CanRun = "$moderator, $debugger",
		Callback = function (self, Plr, Cmd, Args, NextCmds, Silent)
			local Thread = coroutine.running()
			local WaitingFor = 0
			for PlrString, BanInfo, Scope in Main.BanStore:pairs() do
				WaitingFor = WaitingFor + 1
				spawn(function()
					local Ran, Username
					if type(BanInfo) == "table" and BanInfo.Username then
						Ran, Username = true, BanInfo.Username
					else
						Ran, Username = pcall(Main.Util.UsernameFromID, PlrString)
					end
					
					coroutine.resume(Thread, Scope .. " - " .. (Ran and Username or PlrString) .. (type(BanInfo) == "string" and (" - " .. BanInfo) or type(BanInfo) == "table" and type(BanInfo.Reason) == "string" and ( " - " .. BanInfo.Reason) or "") .. (type(BanInfo.Time) == "number" and (" - Unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or "") .. "\n")
				end)
			end
			
			local Str = ""
			while WaitingFor ~= 0 do
				WaitingFor = WaitingFor - 1 Str = Str .. coroutine.yield()
			end
			
			if Str == "" then
				Str = "No bans exist"
			else
				Str = "Bans:\n" .. Str:sub( 1, -2 )
			end
			
			Main.Util.PrintClient( Plr, Str )
			
			if Silent then
				return true, "Check your client log ( F9 )"
			else
				Main.Util.SendMessage( Plr, "Check your client log ( F9 )", "Info" )
				return true
			end
		end
	}
	
	Main.Commands.UserPowers = {
		Alias = {"powers", "powerlist", "userpowers", "userpowerlist", {function(self, Alias)
			return Alias:sub( -1 ) == "s" and Main.UserPower[ Alias:sub( 1, -2 ) ] ~= nil
		end, "users"}},
		Description = "Lists all of the user powers",
		Category = "Core",
		CanRun = "$moderator, $debugger",
		Callback = function (self, Plr, Cmd, Args, NextCmds, Silent)
			local Thread = coroutine.running()
			local WaitingFor = 0
			for PlrString, Power, Scope in Main.UserPowersStore:pairs() do
				WaitingFor = WaitingFor + 1
				spawn(function()
					local Ran, Username = pcall(Main.Util.UsernameFromID, PlrString)
					coroutine.resume(Thread, Scope .. " - " .. (Ran and Username or PlrString) .. " - " .. Main.UserPowerName(Main.UserPowerFromString(Power)) .. "\n")
				end)
			end
			
			local Str = ""
			while WaitingFor ~= 0 do
				WaitingFor = WaitingFor - 1 Str = Str .. coroutine.yield()
			end
			
			if Str == "" then
				Str = "No user powers exist"
			else
				Str = "Powers:\n" .. Str:sub( 1, -2 )
			end
			
			Main.Util.PrintClient( Plr, Str )
			
			if Silent then
				return true, "Check your client log ( F9 )"
			else
				Main.Util.SendMessage( Plr, "Check your client log ( F9 )", "Info" )
				return true
			end
		end
	}
	
	local CmdLogs = ( _G.VH_Saved or { } ).CmdLogs or { }
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then return end
		
		_G.VH_Saved.CmdLogs = CmdLogs
		
	end )
	
	Main.CommandStackRan.Event:Connect(function(UserId, Msg)
		CmdLogs[ #CmdLogs + 1 ] = { os.time( ), UserId, Msg }
	end)
	
	Main.Commands.CmdLogs = {
		
		Alias = { "cmdlogs", "logs" },
		
		Description = "Displays the command log entries",
		
		Category = "Core",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Str = "Command Logs:\n"
			
			for a = 1, #CmdLogs do
				
				Str = Str .. Main.Util.TimeSince( CmdLogs[ a ][ 1 ] ) .. " - " .. Main.Util.UsernameFromID( CmdLogs[ a ][ 2 ] ) .. ":" .. CmdLogs[ a ][ 2 ] .. " ran " .. TextService:FilterStringAsync( CmdLogs[ a ][ 3 ], CmdLogs[ a ][ 2 ] ):GetChatForUserAsync( Plr.UserId ) .. "\n"
				
			end
			
			if #CmdLogs == 0 then
				
				Str = "No log entries exist"
				
			else
				
				Str = Str:sub( 1, -2 )
				
			end
			
			Main.Util.PrintClient( Plr, Str )
			
			if Silent then return true, "Check your client log ( F9 )" end
			
			Main.Util.SendMessage( Plr, "Check your client log ( F9 )", "Info" )
			
			return true
			
		end
		
	}
	
	local function HBWait( Time )
		
		local t = 0
		
		while t < Time do
			
			t = t + Heartbeat:Wait( )
			
		end
		
		return t
		
	end
	
	Main.Commands.Wait = {
		
		Alias = { "wait", "delay" },
		
		Description = "Causes any commands after this one to be delayed, e.g. wait/5:kill/me",
		
		Category = "Core",
		
		CanRun = "$moderator, $debugger",
		
		ArgTypes = { Main.TargetLib.ArgTypes.Time },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			HBWait( Args[ 1 ] )
			
			return true
			
		end
		
	}
	
	Main.Commands.Commands = {
		
		Alias = { "commands", "cmds" },
		
		Description = "Displays a list of commands with 15 per page",
		
		Category = "Core",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Lower = true, Default = "" }, { Func = Main.TargetLib.ArgTypes.Number, Min = 1 } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if not Args[ 2 ] and tonumber( Args[ 1 ] ) then
				
				Args[ 2 ] = tonumber( Args[ 1 ] )
				
				Args[ 1 ] = ""
				
			end
			
			Args[ 2 ] = Args[ 2 ] or 1
			
			local Page = Args[ 2 ] - 1
			
			local CmdNames = { }
			
			local UserPower, Debugger = ( Plr and Main.GetUserPower( Plr.UserId ) or Main.UserPower.console ), Main.IsDebugger( Plr.UserId )
			
			for a, b in pairs( Main.Commands ) do
				
				local Matches = a:lower():find(Args[1]) or b.Category:lower():find(Args[1])
				
				if not Matches then
					
					for c = 1, #b.Alias do
						
						if type( b.Alias[ c ] ) == "string" and b.Alias[ c ]:find( Args[ 1 ] ) then
							
							Matches = true
							
							break
							
						end
						
					end
					
				end
				
				if Matches then
					
					if b.Commands then
						
						local CantRun
						
						for c = 1, #b.Commands do
							
							if b.Commands[ c ].CanRun and not Main.TargetLib.MatchesPlr( b.Commands[ c ].CanRun, Plr ) then
								
								CantRun = true
								
								break
								
							end
							
						end
						
						if not CantRun then
							
							CmdNames[ #CmdNames + 1 ] = a
							
						end
						
					elseif not b.CanRun or Main.TargetLib.MatchesPlr( b.CanRun, Plr ) then
						
						CmdNames[ #CmdNames + 1 ] = a
						
					end
					
				end
				
			end
			
			if #CmdNames == 0 then return false, "Argument 1 does not match any commands" end
			
			table.sort( CmdNames )
			
			local Offset = 0
			
			local a, Name
			
			while true do
				
				a, Name = next( CmdNames, a )
				
				if not a then break end
				
				local CmdObj = Main.Commands[ Name ]
				
				if CmdObj.Commands then
					
					for b = 1, #CmdObj.Commands do
						
						local Found
						
						for c = 1, #CmdNames do
							
							if CmdNames[ c ] == CmdObj.Commands[ b ].Name then
								
								Found = true
								
								break
								
							end
							
						end
						
						if not Found then
							
							Offset = Offset + 1
							
							table.insert( CmdNames, a + Offset, CmdObj.Commands[ b ].Name )
							
						end
						
					end
					
				end
				
				for b, c in pairs( Main.Commands ) do
					
					if c.Commands then
						
						for d = 1, #c.Commands do
							
							if c.Commands[ d ].Name == CmdObj.Name then
								
								local Found
								
								for e = 1, #CmdNames do
									
									if CmdNames[ e ] == c.Name then
										
										Found = true
										
										break
										
									end
									
								end
								
								if not Found then
									
									Offset = Offset + 1
									
									table.insert( CmdNames, a + Offset, c.Name )
									
								end
								
							end
							
						end
						
					end
					
				end
				
			end
			
			local MaxPages = math.ceil( #CmdNames / 5 )
			
			Page = math.min( Page, MaxPages - 1 )
			
			local Str = ""
			
			for a = Page * 5 + 1, math.min( Page * 5 + 5, #CmdNames ) do
				
				local CmdObj = Main.Commands[ CmdNames[ a ] ]
				
				local CanRun
				
				if CmdObj.Commands then
					
					CanRun = "To run this you must be able to run: "
					
					for a = 1, #CmdObj.Commands do
						
						CanRun = CanRun .. ( a == 1 and "" or a == #CmdObj.Commands and " and " or ", " ) .. CmdObj.Commands[ a ].Name
						
					end
					
				else
					
					CanRun = "Can be run by " .. ( CmdObj.CanRun or "anyone" )
					
				end
				
				Str = Str .. CmdNames[ a ] .. " - " .. CanRun .. "\n"
				
			end
			
			if Silent then return true, Str end
			
			Main.Util.SendMessage( Plr, Str .. "Page " .. Page + 1 .. "/" .. MaxPages, "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Help = {
		
		Alias = { "help", "?" },
		
		Description = "Shows info on a command\nArguments with < > are required\nArguments with [ ] are optional are arguments with ... after them can be multiple targets\nE.g. [player...] would mean an optional argument that can take multiple players",
		
		Category = "Core",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Name = "cmd_or_'target'_or_'setup'" }, Main.TargetLib.ArgTypes.String },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Silent then return true end
			
			if not Args[ 1 ] then
				
				Main.Util.SendMessage( Plr, "V-Handle admin commands\nThis is an admin command script created by Partixel\nSay 'cmds/' to see a list of commands\nSay 'help/CMD' to see help on a command\nSay 'help/setup' to see info on how to update the setup model\nSay 'help/target' to see info on how command targetting works", "Info" )
				
				return true
				
			elseif Args[ 1 ]:lower( ) == "setup" then
				
				Main.Util.SendMessage( Plr, "Automatic Plugin: Take Partixel's V-Handler Setup Updater ( ID: 736545282 )\nManual Command: In play solo run the command 'updateconfig/' and follow the instructions in the output\nManual: Insert the latest V-Handle Setup and copy your config settings into the config of the new setup model making sure to keep any new settings in it", "Info" )
				
				return true
				
			elseif Args[ 1 ]:lower( ) == "target" then
				
				if Args[ 2 ] then
					
					Args[ 2 ] = Args[ 2 ]:lower( )
					
					if Args[ 2 ] == "player" then
						
						Main.Util.SendMessage( Plr, "Proceed any of the following with '+' to target friends of the player;\nMe - Targets yourself e.g. 'kill/me'\nName/Partial name - Targets players with a matching name e.g. 'kill/player' or 'kill/play'\nUserId - Targets the player with matching userid e.g. 'kill/1234'", "Info" )
						
					elseif Args[ 2 ] == "group" then
						
						Main.Util.SendMessage( Plr, "When targetting players you can target players within groups via the following;\n^GroupId - Targets a group e.g. 'kill/^123'\n^GroupId>Rank - Targets a group and anyone at or higher then the rank e.g. 'kill/^123>254'\n^GroupId=Rank - Targets a group and anyone at the rank e.g. 'kill/^123=254'\n@GroupId - Targets any allies of a group e.g. 'kill/@123'\n#GroupId - Targets any enemies of a group e.g. 'kill/#123'", "Info" )
						
					elseif Args[ 2 ] == "userpower" then
						
						Main.Util.SendMessage( Plr, "When targetting players you can target players with certain user powers via the following;\n$Power - Targets all players with equal to or more then the specified user power e.g. 'kill/$admin'\nThis can also be used with 'debug' or 'debuggers', e.g. 'kill/$debuggers'\n*Plr*Dist - Targets any players near the target player, dist the distance from the player they must be ( defaults to 15 if none is specified ) e.g. 'kill/*me*10'\n\nYou can use '&' to target objects that match multiple different arguments e.g. 'kill/partixel&!me' will kill anyone with 'partixel' in their name as long as they arent the player running the command", "Info" )
						
					elseif Args[ 2 ] == "distance" then
						
						Main.Util.SendMessage( Plr, "*Plr*Dist - Targets any players near the target player, dist the distance from the player they must be ( defaults to 15 if none is specified ) e.g. 'kill/*me*10'", "Info" )
						
					elseif Args[ 2 ] == "string" then
						
						Main.Util.SendMessage( Plr, "When using the prefix ':' to run commands, e.g. ':kill me', strings must start and end with either \" or ', for example ':m hi there' will make a message 'hi' where as ':m \"hi there\"' will make a message 'hi there'\nThis isn't necessary when using the '/' seperators, e.g. 'kill/me'", "Info" )
						
					elseif Args[ 2 ] == "boolean" then
						
						Main.Util.SendMessage( Plr, "Any of the following can be used in place of 'true';\ntrue, t, yes, y, 1, on\nAny of the following can be used in place of 'false';\nfalse, f, no, n, 0, off", "Info" )
					elseif Args[ 2 ] == "team" then
						
						Main.Util.SendMessage( Plr, "To target a team put % before one of the follow:\nMe - Targets your team e.g. 'kill/%me'\nBiggest - Targets the biggest team e.g. 'kill/%biggest'\nSmallest - Targets the smallest team e.g. 'kill/%smallest'\nRandom - Targets a random team e.g. 'kill/%random'\nName/Partial name - Targets the team with matching name e.g. 'kill/%red' or 'kill/%re'", "Info" )
						
					elseif Args[ 2 ] == "time" then
						
						Main.Util.SendMessage( Plr, "To target a specific amount of time you can use the following;\nNumber - Targets a second e.g. 'wait/5'\nM - Targets a minute e.g. 'wait/5m'\nH - Targets an hour e.g. 'wait/5h'\nD - Targets a day e.g. 'wait/5d'\nW - Targets a week e.g. 'wait/5w'", "Info" )
						
					elseif Args[ 2 ] == "multiples" then
						
						Main.Util.SendMessage( Plr, "When targetting multiple things at once, such as multiple players, you can use the following;\nAll or * can be used to target all possible targets\nRandom can be used to target a random possible target\n! can be used to invert a statement, such as 'kill/!me' will kill everyone that isnt you\n? can be used to match anything at any time\nFinally, you can use '&' to target objects that match multiple different arguments e.g. 'kill/partixel&!me' will kill anyone with 'partixel' in their name as long as they arent the player running the command", "Info" )
						
					end
					
					return true
					
				end
				
				Main.Util.SendMessage( Plr, "The following can be used in commands, e.g. kill/all, or even in the Config UserPowers and Banned,\ne.g. Config.UserPowers = { [ 'all' ] = 'admin' }\nAny of the following can be inverted using !, e.g. !me will target anyone that isn't you\n\nSay 'help/target/player' for info on targetting players\nSay 'help/target/boolean' for info on targetting booleans\nSay 'help/target/team' for info on targetting teams\nSay 'help/target/time' for info on targetting times\nSay 'help/target/group' for info on targetting players in groups\nSay 'help/target/userpower' for info on targetting players with user powers\nSay 'help/target/distance' for info on targetting players near other players\nSay 'help/target/multiples' for info on targetting multiple things at once, such as multiple players", "Info" )
				
				return true
				
			end
			
			local TargetCmd, CmdObj = Args[1]:lower()
			if TargetCmd == Main.TargetLib.ValidChar then
				CmdObj = Main.Commands.Help
			else
				CmdObj = Main.GetCommandAndArgs(TargetCmd)
			end
			
			if CmdObj then
				
				local Config = ""
				
				if CmdObj.Config then
					
					Config = "\nConfigs - "
					
					for a, b in pairs( CmdObj.Config ) do
						
						Config = Config .. a .. ", "
						
					end
					
					Config = Config:sub( 1, -3 )
					
				end
				
				local Aliases = {TargetCmd}
				for a = 1, #CmdObj.Alias do
					if type(CmdObj.Alias[a]) == "table" then
						local Start = type(CmdObj.Alias[a][1]) == "function" and 3 or 1
						for b = Start, #CmdObj.Alias[a] do
							if CmdObj.Alias[a][b] ~= TargetCmd then
								Aliases[#Aliases + 1] = CmdObj.Alias[a][b]
							end
						end
					elseif CmdObj.Alias[a] ~= TargetCmd then
						Aliases[#Aliases + 1] = CmdObj.Alias[a]
					end
				end
				Aliases = Main.Util.FormatStringTable(Aliases)
				
				local CanRun
				
				if CmdObj.Commands then
					
					CanRun = "\nCommand Alias of - "
					
					for a = 1, #CmdObj.Commands do
						
						CanRun = CanRun .. ( a == 1 and "" or a == #CmdObj.Commands and " and " or ", " ) .. CmdObj.Commands[ a ].Name
						
					end
					
					CanRun = CanRun .. "\nTo run this you must be able to run all of the above commands"
					
				else
					
					CanRun = "\nCan run - " .. ( CmdObj.CanRun or "anyone" )
				end
				
				Main.Util.SendMessage( Plr, "Aliases - " .. Aliases .. "\nDescription - " .. CmdObj.Description .. "\nCategory - " .. CmdObj.Category .. "\nUsage - " .. TargetCmd .. Main.GetUsage( Plr, TargetCmd ) .. CanRun .. Config, "Info" )
				
				return true
				
			end
			
			return false, "Argument 1 is incorrect"
			
		end
		
	}
	
end