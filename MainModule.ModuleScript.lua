----==== Create variables ====----

local Main, Players, ReplicatedStorage, InsertService, StarterPlayerScripts, Chat, ServerStorage, RunService, TextService = { }, game:GetService( "Players" ), game:GetService( "ReplicatedStorage" ), game:GetService( "InsertService" ), game:GetService( "StarterPlayer" ):WaitForChild( "StarterPlayerScripts" ), game:GetService( "Chat" ), game:GetService( "ServerStorage" ), game:GetService( "RunService" ), game:GetService( "TextService" )

local ChatModules = Chat:WaitForChild( "ChatModules", math.huge )

if RunService:IsStudio( ) then
	
	Main.Clone = script:Clone( )
	
end

----==== Cleanup Old ====----

if _G.VH_Admin and _G.VH_Admin.Destroy then
	
	pcall( function ( ) _G.VH_Admin.Destroy( ) end )
	
end

if ReplicatedStorage:FindFirstChild( "VH_Events" ) then
	
	if ReplicatedStorage.VH_Events:FindFirstChild( "Destroyed" ) then
		
		_G.VH_Saved = { }
		
		ReplicatedStorage.VH_Events.Destroyed:Fire( true )
		
	end
	
	if ReplicatedStorage.VH_Events:FindFirstChild( "RemoteDestroyed" ) then
		
		ReplicatedStorage.VH_Events.RemoteDestroyed:FireAllClients( true )
		
	end
	
end

local Objs = ServerStorage:GetChildren( )

for a = 1, #Objs do
	
	if Objs[ a ].Name ~= "VH_Config" and Objs[ a ].Name ~= "VH_Command_Modules" and Objs[ a ].Name:lower( ):find( "vh_" ) then
		
		Objs[ a ]:Destroy( )
		
	end
	
end

Objs = ReplicatedStorage:GetChildren( )

for a = 1, #Objs do
	
	if Objs[ a ].Name:lower( ):find( "vh_" ) then
		
		Objs[ a ]:Destroy( )
		
	end
	
end

Objs = StarterPlayerScripts:GetChildren( )

for a = 1, #Objs do
	
	if Objs[ a ].Name:lower( ):find( "vh_" ) then
		
		Objs[ a ]:Destroy( )
		
	end
	
end

while ChatModules:FindFirstChild( "VH_Command_Processor" ) do ChatModules.VH_Command_Processor:Destroy( ) end

----==== Cleanup Setup ====----

local Updated = true

local SetupModel = game:GetService( "ServerScriptService" ):FindFirstChild( "V-Handle" )

if SetupModel then
	
	if SetupModel:FindFirstChild( "VH_Config" ) then
		
		SetupModel.VH_Config.Parent = ServerStorage
		
	end
	
	if SetupModel:FindFirstChild( "EmergencyFunctions" ) then
		
		SetupModel.EmergencyFunctions.Parent = ServerStorage
		
	end
	
	SetupModel:Destroy( )
	
	Updated = false
	
end

----==== Debugger ====----

coroutine.wrap( function ( ... ) return require( ... ) end )( game:GetService( "ServerStorage" ):FindFirstChild( "DebugUtil" ) and game:GetService( "ServerStorage" ).DebugUtil:FindFirstChild( "MainModule" ) or 953754819 )

----==== Create Admin Variables ====----

Main.Changelog = require( script.Changelog )

Main.TargetLib = require( script.TargetLib )

Main.TargetLib.NegativePrefixes = { "un", "de", "retake", "take", "-", "in", "un" }

Main.TargetLib.PositivePrefixes = { "re", "give", "regive", "+" }

Main.TargetLib.TogglePrefixes = { "t", "toggle", "=" }

local function Prefix( Table, String )
	
	local New = { }
	
	for a = 1, #Table do
		
		New[ a ] = String .. Table[ a ]
		
	end
	
	return unpack( New )
	
end

Main.TargetLib.AliasTypes = { }

local function ToggleFunc( Positive, Arg, Aliases, self, Cmd, Plr )
	
	if Plr then
		
		if not self.ArgTypes[ Arg ].ToggleKey then
			
			Main.TargetLib.MaxToggleKey = Main.TargetLib.MaxToggleKey + 1
			
			self.ArgTypes[ Arg ].ToggleKey = Main.TargetLib.MaxToggleKey
			
		end
		
		Main.TargetLib.Toggles[ Plr ] = Main.TargetLib.Toggles[ Plr ] or { }
		
	end
	
	local Args = { }
	
	for a = 1, #Aliases do
		
		local Alias = Aliases[ a ]
		
		if Cmd:sub( Cmd:len( ) - Alias:len( ) ) then
			
			if Cmd == Alias then
				
				if Plr then
					
					Main.TargetLib.Toggles[ Plr ][ self.ArgTypes[ Arg ].ToggleKey ] = Positive
					
				end
				
				Args[ Arg ] = Positive
				
				return true, Args
				
			end
			
			if Cmd:sub( Cmd:len( ) - Alias:len( ) + 1 ) == Alias then
				
				local Prefix = Cmd:sub( 1, Cmd:len( ) - Alias:len( ) )
				
				for a = 1, #Main.TargetLib.NegativePrefixes do
					
					if Prefix == Main.TargetLib.NegativePrefixes[ a ] then
						
						if Plr then
							
							Main.TargetLib.Toggles[ Plr ][ self.ArgTypes[ Arg ].ToggleKey ] = not Positive
							
						end
						
						Args[ Arg ] = not Positive
						
						return true, Args
						
					end
					
				end
				
				for a = 1, #Main.TargetLib.PositivePrefixes do
					
					if Prefix == Main.TargetLib.PositivePrefixes[ a ] then
						
						if Plr then
							
							Main.TargetLib.Toggles[ Plr ][ self.ArgTypes[ Arg ].ToggleKey ] = Positive
							
						end
						
						Args[ Arg ] = Positive
						
						return true, Args
						
					end
					
				end
				
				for a = 1, #Main.TargetLib.TogglePrefixes do
					
					if Prefix == Main.TargetLib.TogglePrefixes[ a ] then
						
						return true
						
					end
					
				end
				
			end
			
		end
	
	end
	
end

Main.TargetLib.AliasTypes.Toggle = function ( Arg, ... )
	
	local Aliases = { ... }
	
	return { function ( ... ) return ToggleFunc( true, Arg, Aliases, ... ) end, "+" .. Aliases[ 1 ], Prefix( Aliases, "(=,+,-)" ) }
	
end

Main.TargetLib.AliasTypes.InvertedToggle = function ( Arg, ... )
	
	local Aliases = { ... }
	
	return { function ( ... ) return ToggleFunc( false, Arg, Aliases, ... ) end, "+" .. Aliases[ 1 ], Prefix( Aliases, "(=,+,-)" ) }
	
end

Main.TargetLib.AliasTypes.Positive = function ( Arg, ... )
	
	local Aliases = { ... }
	
	local Args = { }
	
	Args[ Arg ] = true
	
	return { function ( self, Cmd, Plr )
		
		for a = 1, #Aliases do
			
			if Cmd == Aliases[ a ] then return true, Args end
			
		end
		
	end, unpack( Aliases ) }
	
end

Main.TargetLib.AliasTypes.Negative = function ( Arg, ... )
	
	local Aliases = { ... }
	
	local Args = { }
	
	Args[ Arg ] = false
	
	return { function ( self, Cmd, Plr )
		
		for a = 1, #Aliases do
			
			if Cmd == Aliases[ a ] then return true, Args end
			
		end
		
	end, unpack( Aliases ) }
	
end

Main.ConsoleToString = function ( ) return "Console" end

Main.Console = setmetatable( { UserId = "Console", Name = "Console" }, { __tostring = Main.ConsoleToString } )

Main.Errors = ( _G.VH_Saved or { } ).Errors or { }

Main.Log = ( _G.VH_Saved or { } ).Log or { }

Main.CmdHistory = ( _G.VH_Saved or { } ).CmdHistory or { }

Main.Loops = { }

Main.Objs = { }

Main.Events = { }

Main.AnnounceJoin = { }

Main.AnnouncedLeft = { }

Main.CommandRan = script.CommandRan.Event

----==== Main ====----

script.Name = "VH_Main"

script.Archivable = false

if script.Parent and script.Parent.Name == "Model" then
	
	local Old = script.Parent
	
	script.Parent = ServerStorage
	
	Old:Destroy( )
	
else
	
	script.Parent = ServerStorage
	
end

local VH_Events = script.VH_Events

local VH_Command_Modules, VH_Command_Clients

local VH_Command_Processor = script.VH_Command_Processor

VH_Events.Parent = ReplicatedStorage

VH_Command_Processor.Parent = ChatModules

local TextService = game:GetService("TextService")

function Main.FilterTo( From, To, FuncName, Text, ... )
	
	From = type( From ) == "table" and From.Origin or From
	
	To = type( To ) == "userdata" and { To } or type( To ) == "table" and To or Players:GetPlayers( )
	
	if From.UserId == "Console" then
		
		for a = 1, #To do
			
			VH_Events.FilteredReplication:FireClient( To[ a ], FuncName, Text, ... )
			
		end
		
	else
		
		local FilterResult = TextService:FilterStringAsync( Text, From.UserId )
		
		for a = 1, #To do
			
			VH_Events.FilteredReplication:FireClient( To[ a ], FuncName, FilterResult:GetChatForUserAsync( To[ a ].UserId ), ... )
			
		end
		
	end
	
end

local function Fill( Table, a, max )
	
	a = a or 1
	
	if not max then
		
		max = 1
		
		for a, b in pairs( Table ) do
			
			max = math.max( max, a )
			
		end
		
	end
	
	if a > max then return end
	
	return Table[ a ], Fill( Table, a + 1, max )
	
end

function Main.GetCmdStacks( Plr, Cmd, StrArgs )
	
	local CmdObj, Args = Main.GetCommandAndArgs( Cmd, Plr )
	
	if not CmdObj then
		
		return false
		
	end
	
	if CmdObj.Commands then
		
		for a = 1, #CmdObj.Commands do
			
			if CmdObj.Commands[ a ].CanRun and not Main.TargetLib.MatchesPlr( CmdObj.Commands[ a ].CanRun, Plr ) then
				
				return "Cannot run " .. Cmd .. "!"
				
			end
			
		end
		
	else
		
		if CmdObj.CanRun and not Main.TargetLib.MatchesPlr( CmdObj.CanRun, Plr ) then
			
			return "Cannot run " .. Cmd .. "!"
			
		end
		
	end
	
	local Valid, Fail = true, ""
	
	if CmdObj.ArgTypes then
		
		Args = Args or { }
		
		local ArgCount = math.max( #StrArgs, #CmdObj.ArgTypes )
		
		local Tmp = Main.Util.TableShallowCopy( StrArgs )
		
		for a = 1, ArgCount do
			
			if Tmp[ 1 ] == nil or Tmp[ 1 ] == "" or not CmdObj.ArgTypes[ a ] then
				
				if Args[ a ] == nil then
					
					if type( CmdObj.ArgTypes[ a ] ) == "table" then
						
						if CmdObj.ArgTypes[ a ].Default and not CmdObj.ArgTypes[ a ].ManualRequired then
							
							Args[ a ] = CmdObj.ArgTypes[ a ].Default
							
							if type( Args[ a ] ) == "function" then
								
								local Parsed, Ran, FailMsg = Args[ a ]( type( CmdObj.ArgTypes[ a ] ) == "table" and CmdObj.ArgTypes[ a ] or { }, Tmp, Plr, a == #CmdObj.ArgTypes, Cmd )
								
								if CmdObj.ArgTypes[ a ].Required and ( Parsed == nil or Ran == false ) then
									
									Fail = "Argument " .. a .. " is incorrect" .. ( FailMsg and ( "\n" .. FailMsg ) or "" ) 
									
									Valid = false
									
									break
									
								end
								
								Args[ a ] = Parsed
								
							end
							
						elseif CmdObj.ArgTypes[ a ].Required then
							
							Fail = "Argument " .. a .. " is required"
							
							Valid = false
							
							break
							
						end
						
						table.remove( Tmp, 1 )
						
					elseif CmdObj.ArgTypes[ a ] == nil then
						
						Args[ a ] = table.remove( Tmp, 1 )
						
					end
					
				end
				
			elseif CmdObj.ArgTypes[ a ] then
				
				if Tmp[ 1 ] == Main.TargetLib.ValidChar and type( CmdObj.ArgTypes[ a ] ) == "table" and CmdObj.ArgTypes[ a ].Default then
					
					Args[ a ] = CmdObj.ArgTypes[ a ].Default
					
					if type( Args[ a ] ) == "function" then
						
						local Parsed, Ran, FailMsg = Args[ a ]( type( CmdObj.ArgTypes[ a ] ) == "table" and CmdObj.ArgTypes[ a ] or { }, Tmp, Plr, a == #CmdObj.ArgTypes, Cmd )
						
						if CmdObj.ArgTypes[ a ].Required and ( Parsed == nil or Ran == false ) then
							
							Fail = "Argument " .. a .. " is incorrect" .. ( FailMsg and ( "\n" .. FailMsg ) or "" ) 
							
							Valid = false
							
							break
							
						end
						
						Args[ a ] = Parsed
						
					end
					
					table.remove( Tmp, 1 )
					
				else
					
					local Func = type( CmdObj.ArgTypes[ a ] ) == "function" and CmdObj.ArgTypes[ a ] or CmdObj.ArgTypes[ a ].Func
					
					local Parsed, Ran, FailMsg = Func( type( CmdObj.ArgTypes[ a ] ) == "table" and CmdObj.ArgTypes[ a ] or { }, Tmp, Plr, a == #CmdObj.ArgTypes, Cmd )
					
					if ( Parsed == nil or Ran == false ) then
						
						Fail = "Argument " .. a .. " is incorrect" .. ( FailMsg and ( "\n" .. FailMsg ) or "" ) 
						
						Valid = false
						
						break
						
					end
					
					Args[ a ] = Parsed
					
				end
				
			end
			
		end
		
	else
		
		Args = Main.Util.TableShallowCopy( StrArgs )
		
	end
	
	if not Valid then
		
		return Fail .. "\nCommand usage - " .. Cmd .. Main.GetUsage( CmdObj )
		
	end
	
	if CmdObj.Commands then
		
		local CmdStacks = { }
		
		for a = 1, #CmdObj.Commands do
			
			CmdStacks[ #CmdStacks + 1 ] = { CmdObj.Commands[ a ], Main.Util.TableShallowCopy( Args ) }
			
		end
		
		return unpack( CmdStacks )
		
	end
	
	return { CmdObj, Args }
	
end

function Main.RunCmdStacks( Plr, CmdStacks, Silent )
	
	local Msgs = { }
	
	repeat
		
		if not Main then return false end
		
		local CmdStack = table.remove( CmdStacks, 1 )
		
		local Success, Ran, RanMsg = pcall( CmdStack[ 1 ].Callback, CmdStack[ 1 ], Plr, CmdStack[ 3 ], CmdStack[ 2 ], CmdStacks, Silent )
		
		if not Main then return false end
		
		script.CommandRan:Fire( Plr, CmdStack[ 3 ], { Fill( CmdStack[ 2 ] ) }, CmdStack[ 4 ], CmdStacks, Silent )
		
		if not Success then
			
			Main.Errors[ #Main.Errors + 1 ] =  { CmdStack[ 3 ], Ran }
			
			if Silent then
				
				Msgs[ #Msgs + 1 ] = RanMsg
				
				return true, table.concat( Msgs, ",\n" ), true
				
			end
			
			if #Msgs > 0 then
				
				Main.Util.SendMessage( Plr, table.concat( Msgs, ",\n" ), "Error" )
				
			end
			
			warn( Ran )
			
			Main.Util.SendMessage( Plr, Ran, "Error" )
			
			return true, nil, true
			
		end
			
		if not RanMsg then
			
			if not Ran then
				
				Msgs[ #Msgs + 1 ] = "Command usage - " .. CmdStack[ 3 ] .. Main.GetUsage( CmdStack[ 1 ] )
				
			end
			
		else
			
			Msgs[ #Msgs + 1 ] = RanMsg
			
		end
		
	until not CmdStacks[ 1 ]
	
	if #Msgs > 0 then
		
		if Silent then
			
			return true, table.concat( Msgs, ",\n" )
			
		end
						
		Main.Util.SendMessage( Plr, table.concat( Msgs, ",\n" ), "Warning" )
		
	end
	
	return true
	
end

function Main.ParseCmdStacks( Plr, Msg, ChatSpeaker, Silent )
	
	Plr = Plr or Main.Console
	
	local Prefix, CmdSplit, ArgSplit = "", "|", "/"
	
	if Msg:sub( 1, 1 ) == ":" then
		
		Prefix, CmdSplit, ArgSplit = ":", "|", " "
		
	end
	
	local CmdStrings = Main.Util.EscapeSplit( Msg, CmdSplit )
	
	local CmdStacks = { }
	
	local Msgs = { }
	
	local CmdNum = 0
	
	repeat
		
		if not Main then return end
		
		CmdNum = CmdNum + 1
		
		local Args = Main.Util.EscapeSplit( table.remove( CmdStrings, 1 ), ArgSplit )
		
		if Prefix ~= "" then
			
			if Args[ 1 ]:sub( 1, Prefix:len( ) ) ~= Prefix then
				
				return nil, "Not a command"
				
			end
			
			Args[ 1 ] = Args[ 1 ]:sub( Prefix:len( ) + 1 )
			
		end
		
		if #Args == 1 and Prefix == "" then
			
			return nil, "Not a command"
			
		end
		
		local Cmd = table.remove( Args, 1 ):lower( )
		
		if Cmd ~= "" then
			
			local Found = { Main.GetCmdStacks( Plr, Cmd, Args, CmdStrings, Silent ) }
			
			for a = 1, #Found do
				
				if type( Found[ a ] ) == "table" then
					
					Found[ a ][ 3 ] = Cmd
					
					Found[ a ][ 4 ] = Args
					
					CmdStacks[ #CmdStacks + 1 ] = Found[ a ]
					
				else
					
					if Found[ a ] then
						
						Msgs[ #Msgs + 1 ] = Found[ a ]
						
					else
						
						if CmdNum == 1 then
							
							return nil, Cmd .. " is not a command"
							
						else
							
							Msgs[ #Msgs + 1 ] = Cmd .. " is not a command"
							
							break
							
						end
						
					end
					
				end
				
			end
			
		else
			
			if CmdNum == 1 then
				
				return nil, "Command number " .. CmdNum .. " is not a command"
				
			else
				
				Msgs[ #Msgs + 1 ] = "Command number " .. CmdNum .. " is not a command"
				
				break
				
			end
			
			break
			
		end
		
	until not CmdStrings[ 1 ]
	
	if #Msgs > 0 then
		
		if Silent then
			
			return true, table.concat( Msgs, ",\n" )
			
		end
						
		Main.Util.SendMessage( Plr, table.concat( Msgs, ",\n" ), "Warning" )
		
		if Plr.UserId ~= "Console" and ChatSpeaker then
			
			ChatSpeaker:SendMessage( Msg, "V-Handle", Plr.Name )
			
		end
		
		return true
		
	end
	
	if not Silent then
		
		if Plr.UserId ~= "Console" and ChatSpeaker then
			
			ChatSpeaker:SetExtraData( "RanCmd", true )
				
			ChatSpeaker:SayMessage( Msg, "V-Handle" )
			
		end
		
		Main.Log[ #Main.Log + 1 ] = { os.time( ), Plr.UserId, CmdStacks }
		
		local NoRepeat
		
		for a = 1, #CmdStacks do
			
			if CmdStacks[ a ][ 1 ].NoRepeat then
				
				NoRepeat = true
				
				break
				
			end
			
		end
		
		if not NoRepeat then
			
			Main.CmdHistory[ Plr.UserId ] = Msg
			
		end
		
	end
	
	return Main.RunCmdStacks( Plr, CmdStacks, Silent )
	
end

function Main.Chatted( ... )
	
	warn( "Main.Chatted deprecated! Use Main.ParseCmdStacks\n" .. debug.traceback( ) )
	
	return Main.ParseCmdStacks( ... )
	
end

local HttpEnabled = pcall( function ( ) game.HttpService:GetAsync( "https://www.google.com" ) end )

function Main.PlayerAdded( Plr, JustUpdated )
	
	if Main.Config.AnnounceJoin and not JustUpdated then
		
		delay( 0, function ( )
			
			if Main.AnnounceJoin[ Plr ] then
				
				Main.Util.SendMessage( nil, Plr.Name .. " could not join because " .. Main.Util.FormatStringTable( Main.AnnounceJoin[ Plr ] ), "Info" )
				
				Main.AnnounceJoin[ Plr ] = nil
				
				return
				
			end
			
			local Plrs = Players:GetPlayers( )
			
			for a = 1, #Plrs do
				
				if Plrs[ a ] == Plr then
					
					local Size = #Plrs
					
					Plrs[ a ] = Plrs[ Size ]
					
					Plrs[ Size ] = nil
					
					break
					
				end
				
			end
			
			Main.Util.SendMessage( Plrs, Plr.Name .. " has joined", "Info" )
			
		end )
		
	end
	
	local Banned, BanInfo = Main.GetBanned( Plr.UserId )
	
	if Banned then
		
		if Main.Config.AnnounceJoin then
			
			Main.AnnounceJoin[ Plr ] = Main.AnnounceJoin[ Plr ] or { }
			
			Main.AnnounceJoin[ Plr ][ #Main.AnnounceJoin[ Plr ] + 1 ] = "player is banned" .. ( BanInfo.Reason and ( " for " .. TextService:FilterStringAsync( BanInfo.Reason, BanInfo.Banner ):GetNonChatStringForBroadcastAsync( ) ) or "" )
			
			Main.AnnouncedLeft[ Plr ] = false
			
		end
		
		Plr:Kick( "You have been banned by " .. Main.Util.UsernameFromID( BanInfo.Banner ) .. ( BanInfo.Reason and ( " for " ..  TextService:FilterStringAsync( BanInfo.Reason, BanInfo.Banner ):GetChatForUserAsync( Plr.UserId ) ) or "" ) .. " - You get unbanned in " .. Main.Util.TimeRemaining( BanInfo.Time ) )
		
		return
		
	end
	
	for a, b in pairs( Main.Config.Banned ) do
		
		if type( a ) == "string" and Main.TargetLib.MatchesPlr( a, Plr ) then
			
			if Main.Config.AnnounceJoin then
				
				Main.AnnounceJoin[ Plr ] = Main.AnnounceJoin[ Plr ] or { }
				
				Main.AnnounceJoin[ Plr ][ #Main.AnnounceJoin[ Plr ] + 1 ] = "player is banned"
				
				Main.AnnouncedLeft[ Plr ] = false
				
			end
			
			Plr:Kick( b == true and "You are banned - You get unbanned in forever" or ( "You are banned for " .. Main.Config.Banned[ a ] .. " - You get unbanned in forever" ) )
			
			return
			
		end
		
	end
	
	if RunService:IsStudio( ) then
		
		Main.SetUserPower( Plr.UserId, Main.UserPower.owner )
		
	elseif Main.TempAdminPowers[ tostring( Plr.UserId ) ] == nil then
		
		local Override = 0
		
		for a, b in pairs( Main.Config.UserPowers ) do
			
			local a, Count = a:gsub( "%-", "" )
			
			local UserPower = Main.UserPowerFromString( b )
			
			if Count >= Override or UserPower > Main.GetUserPower( Plr.UserId ) then
				
				if Main.TargetLib.MatchesPlr( a, Plr ) then
					
					if UserPower ~= Main.UserPower.owner then
						
						Override = Count
						
						Main.SetUserPower( Plr.UserId, UserPower )
						
					end
					
				end
				
			end
			
		end
		
	end
	
	if JustUpdated then
		
		Main.Util.SendMessage( Plr, "Admin has been updated! Say 'changelog/' to see the changes!", "Info" )
		
	else
	
		if Main.IsDebugger( Plr.UserId ) then
			
			Main.Util.SendMessage( Plr, "You are a debugger!", "Info" )
			
		end
		
		if Main.GetUserPower( Plr.UserId ) ~= Main.UserPower.user then
			
			Main.Util.SendMessage( Plr, "Your user power is '" .. Main.UserPowerName( Main.GetUserPower( Plr.UserId ) ) .. "'!", "Info" )
			
		end
		
	end
	
	if ( Main.GetUserPower( Plr.UserId ) ~= Main.UserPower.user or Main.IsDebugger( Plr.UserId ) ) then
			
		if not HttpEnabled then
			
			Main.Util.SendMessage( Plr, "You must allow HTTP Requests within the Game Settings menu in studio for V-Handle to function correctly.", "Error" )
			
		end

		if Main.Changelog[ 2 ].SetupVersion ~= _G.VHSetupVersion then
			
			Main.Util.SendMessage( Plr, "A new version of the setup model is available, run help/setup for more information. Make sure the V-Handle Setup Updater plugin is updated.", "Warning" )
			
		end
		
	end
	
end

----==== Config Setup ====----

Main.Config = ServerStorage:FindFirstChild( "VH_Config" ) and require( ServerStorage.VH_Config ) or { }

----==== Destroy Module ====----
local Destroy, Disconnect = workspace.Destroy, workspace.Changed:Connect( function ( ) end )

Disconnect = Disconnect.Disconnect, Disconnect:Disconnect( )

local function EmptyTable( Table )
	
	for a, b in pairs( Table ) do
		
		pcall( Disconnect, b )
		
		pcall( Destroy, b )
		
		if type( b ) == "table" then EmptyTable( b ) end
		
		Table[ a ] = nil
		
	end
	
end

local ModuleObjs = { }

function Main.Destroy( Update )
	
	_G.VH_Admin = nil
	
	if Update then
		
		_G.VH_Saved = { TempBans = Main.TempBans, TempAdminPowers = Main.TempAdminPowers, Errors = Main.Errors, Log = Main.Log, CmdHistory = Main.CmdHistory }
		
	end
	
	VH_Events.Destroyed:Fire( Update )
	
	if Update then
	
		Main.TempBans, Main.TempAdminPowers, Main.Config, Main.Errors, Main.Log, Main.CmdHistory = nil, nil, nil, nil, nil, nil
		
	else
		
		if ServerStorage:FindFirstChild( "VH_Config" ) then
			
			ServerStorage.VH_Config:Destroy( )
			
		end
		
		if ServerStorage:FindFirstChild( "EmergencyFunctions" ) then
			
			ServerStorage.EmergencyFunctions:Destroy( )
			
		end
		
	end
	
	if #VH_Command_Modules:GetChildren( ) == 0 then
		
		VH_Command_Modules:Destroy( )
		
	end
	
	VH_Events.RemoteDestroyed:FireAllClients( Update )
	
	VH_Events:Destroy( )
	
	for a, b in pairs( ModuleObjs ) do
		
		if a.Parent == script.Default_Command_Modules then
			
			b[ 1 ]:Destroy( )
			
			if b[ 2 ] then
				
				b[ 2 ]:Destroy( )
				
			end
			
		else
			
			b[ 1 ].Name = "Client"
			
			b[ 1 ].Parent = a
			
			if b[ 2 ] then
				
				local Events = b[ 2 ]:GetChildren( )
				
				for c = 1, #Events do
					
					Events[ c ]:Clone( ).Parent = a
					
				end
				
				b[ 2 ]:Destroy( )
				
			end
			
		end
		
	end
	
	VH_Command_Clients:Destroy( )
	
	if game:GetService( "StarterPlayer" ).StarterPlayerScripts:FindFirstChild( "VH_Client" ) then
		
		game:GetService( "StarterPlayer" ).StarterPlayerScripts.VH_Client:Destroy( )
		
	end
	
	VH_Command_Processor:Destroy( )
	
	VH_Events = nil
	
	VH_Command_Processor = nil
	
	EmptyTable( Main )
	
	Main = nil
	
	script:Destroy( )
	
	getfenv( ).script = nil
	
end

spawn( function ( ) while wait( ) and script and script.Parent do end if Main then Main.Destroy( ) end end )

----==== Update Setup ====----

function Main.GetLatestId( AssetId )
	
	local Ran, Id = pcall( InsertService.GetLatestAssetVersionAsync, InsertService, AssetId )
	
	if Ran then return Id end
	
	Ran, Id = pcall( game.HttpService.GetAsync, game.HttpService, "https://rbxapi.v-handle.com/?type=1&id=" .. AssetId )
	
	if Ran then return tonumber( Id ) end
	
	return Id
	
end

local LatestId, Latest

function Main.GetLatest( )
	
	local Ids = { 543870197, 571587156 }
	
	local Error
	
	for a = 1, #Ids do
		
		local Id = Main.GetLatestId( Ids[ a ] )
		
		if type( Id ) == "number" then
			
			if Id == LatestId then return Latest end
			
			local Ran, Mod = pcall( InsertService.LoadAssetVersion, InsertService, Id )
			
			if Ran and Mod then
			
				local ModChild = Mod:GetChildren( )[ 1 ]
				
				ModChild.Parent = nil
				
				Mod:Destroy( )
				
				LatestId, Latest = Id, ModChild
				
				return Latest
				
			else
				
				Error = "Couldn't insert latest version of " .. Ids[ a ] .. "\n" .. Mod
				
			end
			
		else
			
			Error = "Couldn't get latest version of " .. Ids[ a ] .. "\n" .. Id
			
		end
		
	end
	
	return Error
	
end

spawn( function ( )
	
	local CurVersion = Main.GetLatestId( 571587156 ) or Main.GetLatestId( 543870197 )
	
	while wait( math.min( math.max( 30, Main.Config.UpdatePeriod or 60 ), 1800 ) ) and Main do
		
		local LatestVersion = Main.GetLatestId( 571587156 ) or Main.GetLatestId( 543870197 )
		
		if tonumber( Latest ) and CurVersion ~= LatestVersion then
			
			Main.Commands.Update:Callback( )
			
			break
			
		end
		
	end
	
end )

----==== Datastore Setup ====----

local Ran, DataStore = pcall( game:GetService( "DataStoreService" ).GetDataStore, game:GetService( "DataStoreService" ), "Partipixel" )

if not Ran or type( DataStore ) ~= "userdata" or not pcall( function ( ) DataStore:GetAsync( "Test" ) end ) then
	
	DataStore = { GetAsync = function ( ) end, SetAsync = function ( ) end, UpdateAsync = function ( ) end, OnUpdate = function ( ) end }
	
end

----==== Ban Setup ====----

Main.TempBans = ( _G.VH_Saved or { } ).TempBans or { }

Main.Events[ #Main.Events + 1 ] = DataStore:OnUpdate( "Bans", function ( Value )
	
	for a, b in pairs( Value or { } ) do
		
		Main.TempBans[ a ] = b
		
		local Plr = game.Players:GetPlayerByUserId( tonumber( a ) ) 
		
		if Plr then
			
			if Main.Config.AnnounceLeft then
						
				Main.AnnouncedLeft[ Plr ] = " has been banned" .. ( b.Reason and ( " for " .. TextService:FilterStringAsync( b.Reason, b.Banner ):GetNonChatStringForBroadcastAsync( ) ) or "" )
				
			end
			
			Plr:Kick( "You have been banned by " .. Main.Util.UsernameFromID( b.Banner ) .. ( b.Reason and ( " for " .. TextService:FilterStringAsync( b.Reason, b.Banner ):GetChatForUserAsync( Plr.UserId ) ) or "" ) .. " - You get unbanned in " .. Main.Util.TimeRemaining( b.Time ) )
			
		end
		
	end
	
end )
	
spawn( function ( )
	
	for a, b in pairs( DataStore:GetAsync( "Bans" ) or { } ) do
		
		if b.Time ~= true and b.Time - os.time( ) < 0 then
			
			Main.SetBan( a, nil, true )
			
		else
			
			Main.TempBans[ a ] = b
			
		end
		
	end
	
end )

function Main.GetBanned( UserId )
	
	local BanInfo = Main.TempBans[ tostring( UserId ) ]
	
	if not BanInfo then return false end
	
	if BanInfo.Time == true then return true, BanInfo end
	
	if os.time( ) < BanInfo.Time then return true, BanInfo end
	
	Main.SetBan( tostring( UserId ), nil, BanInfo.Perm )
	
	return false
	
end

function Main.GetPermBans( )
	
	local Bans = { }
	
	for a, b in pairs( Main.TempBans ) do
		
		if b.Perm and b.Time == true or b.Time - os.time( ) > 0 then
			
			Bans[ a ] = b
			
		end
		
	end
	
	return Bans
	
end

function Main.SetBan( UserId, BanInfo, Perm )
	
	if Perm then
		
		if BanInfo then
			
			BanInfo.Perm = true
			
		end
		
		DataStore:UpdateAsync( "Bans", function ( Value )
			
			Value = Value or { }
			
			Value[ tostring( UserId ) ] = BanInfo
			
			return Value
			
		end )
		
	end
	
	Main.TempBans[ tostring( UserId ) ] = BanInfo
	
end

----==== UserPower Setup ====----

Main.TempAdminPowers = ( _G.VH_Saved or { } ).TempAdminPowers or { }

Main.Events[ #Main.Events + 1 ] = DataStore:OnUpdate( "AdminPowers", function ( Value )
	
	 for a, b in pairs( Value or { } ) do
		
		if not Main then return end
		
		local CurPower = Main.GetUserPower( a )
		
		if CurPower < Main.UserPower.owner and CurPower ~= b then
			
			Main.TempAdminPowers[ a ] = b
			
			a = tonumber( a )
			
			if Players:GetPlayerByUserId( a ) then
				
				Main.Util.SendMessage( Players:GetPlayerByUserId( a ), "Your new user power is '" .. Main.UserPowerName( b ) .. "'!", "Info" )
				
			end
			
		end
		
	end
	
end )



spawn( function ( )
	
	for a, b in pairs( DataStore:GetAsync( "AdminPowers" ) or { } ) do
		
		if Main.GetUserPower( a ) < Main.UserPower.owner then
			
			Main.TempAdminPowers[ a ] = b
			
			a = tonumber( a )
			
			if Players:GetPlayerByUserId( a ) then
				
				Main.Util.SendMessage( Players:GetPlayerByUserId( a ), "Your new user is '" .. Main.UserPowerName( b ) .. "'!", "Info" )
				
			end
			
		end
		
	end
	
end )

local UserPowerCache = { }

Main.UserPower = setmetatable( { }, { __newindex = function ( self, Key, Value )
	
	if rawget( self, Key ) then
		
		UserPowerCache[ rawget( self, Key ) ] = nil
		
	end
	
	if Value then
		
		UserPowerCache[ Value ] = Key:lower( )
		
	end
	
	rawset( self, Key:lower( ), Value )
	
end } )

Main.UserPower.console, Main.UserPower.owner, Main.UserPower.superadmin, Main.UserPower.admin, Main.UserPower.mod, Main.UserPower.moderator, Main.UserPower.user = 60, 50, 40, 30, 20, 20, 10

function Main.UserPowerName( UserPowerNum )
	
	return UserPowerCache[ UserPowerNum ] or "user"
	
end

function Main.UserPowerFromString( String )
	
	return Main.UserPower[ String:lower( ) ] or ( UserPowerCache[ tonumber( String ) ] and tonumber( String ) )
	
end

----==== Player UserPowers ====----

function Main.GetUserPower( UserId )
	
	if UserId == "Console" then return Main.UserPower.console end
	
	return Main.TempAdminPowers[ tostring( UserId ) ] or Main.UserPower.user
	
end

function Main.GetPermUserPower( )
	
	return DataStore:GetAsync( "AdminPowers" ) or { }
	
end

function Main.SetUserPower( UserId, UserPower, Perm )
	
	if not Perm and UserPower == Main.UserPower.user then UserPower = nil end
	
	Main.TempAdminPowers[ tostring( UserId ) ] = UserPower
	
	if Perm then
		
		DataStore:UpdateAsync( "AdminPowers", function ( Value )
			
			Value = Value or { }
			
			Value[ tostring( UserId ) ] = UserPower
			
			return Value
			
		end )
		
	end
	
end

local Debuggers = {
	
	[ 16015142 ] = true, -- Partixel
	
	[ 45858958 ] = true, -- CodeNil
	
	[ 2906531 ] = true, -- Igoing2win
	
	[ 22808842 ] = true, -- Nikolai
	
	[ 4354334 ] = true, -- Antonio
	
	[ 14827891 ] = true -- Nawmis
	
}

Main.Events[ #Main.Events + 1 ] = Players.PlayerRemoving:Connect( function ( Plr )
	
	if not Debuggers[ Plr.UserId ] then Debuggers[ Plr.UserId ] = nil end
	
end )

function Main.IsDebugger( UserId )
	
	if RunService:IsStudio( ) or UserId == "Console" then return true end
	
	if Debuggers[ UserId ] ~= nil then return Debuggers[ UserId ] end
	
	local Ran, Result = pcall( function( ) return game:GetService( "HttpService" ):GetAsync( "https://rbxapi.v-handle.com/?type=2&userid=" .. UserId .. "&placeid=" .. game.PlaceId, true ) end )
	
	if Ran and type( Result ) == "string" then
		
		Ran, Result = pcall( function ( ) return game:GetService( "HttpService" ):JSONDecode( Result ) end )
		
		if Ran then
			
			Debuggers[ UserId ] = Result.CanManage
			
			return Result.CanManage
			
		end
		
	end
	
end

----==== UserPower Targetting ( Name or Number ) ====----

table.insert( Main.TargetLib.MatchFuncs, #Main.TargetLib.MatchFuncs - 1, function ( self,  String, Plr, Matches, Base )
	
	String = String:lower( )
	
	if String:sub( 1, 1 ) ~= "$" then return end
	 
	String = String:sub( 2 )
	
	String = String:match( '^%s*(.*%S)' ) or ""
	
	local Type, UserPowerNum = String:match( "^([><=]*)(.+)" )
	
	local UserPowerNum = Main.UserPowerFromString( UserPowerNum )
	
	if not UserPowerNum then
		
		if Type == "" then
			
			if String:find( "debug" ) then
				
				local Plrs = Players:GetPlayers( )
				
				local Found = { }
				
				for a = 1, #Plrs do
					
					if Main.IsDebugger( Plrs[ a ].UserId ) then
						
						Found[ #Found + 1 ] = Plrs[ a ]
						
					end
					
				end
				
				return true, Found
				
			end
			
		else
			
			return
			
		end
		
	else
		
		Type = Type == "=" and 1 or Type == "<" and 2 or nil
		
		local Plrs = Players:GetPlayers( )
		
		local Found = { }
		
		for a = 1, #Plrs do
			
			if ( Type == 1 and Main.GetUserPower( Plrs[ a ].UserId ) == UserPowerNum ) or ( Type == 2 and Main.GetUserPower( Plrs[ a ].UserId ) <= UserPowerNum ) or ( Type == nil and Main.GetUserPower( Plrs[ a ].UserId ) >= UserPowerNum ) then
				
				Found[ #Found + 1 ] = Plrs[ a ]
				
			end
			
		end
		
		return true, Found
		
	end
	
end )

Main.TargetLib.ArgTypes.PowerNumber = function ( self, Strings, Plr )
	
	local String = table.remove( Strings, 1 )
	
	if String == Main.TargetLib.ValidChar then return self[ 2 ] and self[ 2 ].Default or 10 end
	
	local UserPowerNum = Main.UserPowerFromString( String )
	
	if not UserPowerNum then return nil, false end
	
	return UserPowerNum
	
end
	
Main.TargetLib.ArgTypes.Power = function ( self, Strings, Plr )
	
	local String = table.remove( Strings, 1 )
	
	if String == Main.TargetLib.ValidChar then return self[ 2 ] and self[ 2 ].Default or "user" end
	
	local UserPower = Main.UserPowerName( Main.UserPowerFromString( String ) )
	
	if not UserPower then return nil, false end
	
	return UserPower
	
end

Main.TargetLib.ArgTypeNames.PowerNumber = "power"

----==== UserPower Defaults ====----

if game.CreatorType == Enum.CreatorType.User or game.CreatorId == 0 then
	
	Main.TempAdminPowers[ tostring( game.CreatorId ) ] = Main.UserPower.owner
	
else
	
	local GroupInfo = game:GetService( "GroupService" ):GetGroupInfoAsync( game.CreatorId )
	
	if GroupInfo.Owner then
		
		Main.TempAdminPowers[ tostring( GroupInfo.Owner.Id ) ] = Main.UserPower.owner
		
	end
	
end

----==== Commands Setup ====----

local CmdOptions = {
	
	Alias = { function ( Obj )
		
		if type( Obj ) == "table" and #Obj > 0 then
			
			for a, b in pairs( Obj ) do
				
				if type( b ) == "table" then
					
					if type( b[ 1 ] ) ~= "function" and type( b[ 2 ] ) ~= "string" then
						
						return
						
					end
					
				elseif type( b ) ~= "string" then
					
					return
					
				end
				
			end
			
			return true
			
		end
		
	end },
	
	Description = { "string" },
	
	Category = { "string" },
	
	CanRun = { function ( Obj ) return Obj == nil or type( Obj ) == "string" end },
	
	ArgTypes = { function ( Obj )
		
		if Obj == nil then return true end
		
		for a = 1, #Obj do
			
			if type( Obj[ a ] ) == "table" and ( Obj[ a ].Func == nil or Obj[ a ][ 1 ] or Obj[ a ][ 2 ] ) then return end
			
		end
		
		return true
		
	end },
	
	Callback = { "function" },
	
	Config = { "table", "nil" },
	
	NoTest = { "boolean", "nil" },
	
	NoRepeat = { "boolean", "nil" }
	
}

local AliasCmdOptions = {
	
	Alias = { function ( Obj )
		
		if type( Obj ) == "table" and #Obj > 0 then
			
			for a, b in pairs( Obj ) do
				
				if type( b ) == "table" then
					
					if type( b[ 1 ] ) ~= "function" and type( b[ 2 ] ) ~= "string" then
						
						return
						
					end
					
				elseif type( b ) ~= "string" then
					
					return
					
				end
				
			end
			
			return true
			
		end
		
	end },
	
	Description = { "string" },
	
	Category = { "string" },
	
	Commands = { function ( Obj )
		
		if type( Obj ) == "table" then
			
			for a = 1, #Obj do
				
				if type( Obj[ a ] ) ~= "table" then return end
				
			end
			
			return true
			
		end
		
	end },
	
	ArgTypes = { function ( Obj )
		
		if Obj == nil then return true end
		
		for a = 1, #Obj do
			
			if type( Obj[ a ] ) == "table" and ( Obj[ a ].Func == nil or Obj[ a ][ 1 ] or Obj[ a ][ 2 ] ) then return end
			
		end
		
		return true
		
	end },
	
	NoTest = { "boolean", "nil" },
	
	NoRepeat = { "boolean", "nil" },
	
}

function CheckType( Obj, Types )
	
	for a = 1, #Types do
		
		if type( Types[ a ] ) == "table" then
			
			if type( Obj ) == "table" then
				
				for b, c in pairs( Obj ) do
					
					local Valid = CheckType( c, Types[ a ] )
					
					if not Valid then return end
					
				end
				
				return true
				
			end
			
		elseif type( Types[ a ] ) == "function" then
			
			local Valid = Types[ a ]( Obj )
			
			if Valid then return true end
			
		elseif type( Obj ) == Types[ a ] then
			
			return true
			
		end
		
	end
	
end

local UsageCache, AliasCache, AliasFunctions = { }, { }, { }

function Main.GetUsage( CmdObj )
	
	return UsageCache[ CmdObj ]
	
end

local function Metatable( self, Key, Value )
	
	local Mod = getfenv( 2 )
	
	local ModName = Mod and Mod.script and Mod.script:GetFullName( )
	
	if Main.Config.CommandOptions and Main.Config.CommandOptions[ Key ] then
		
		for a, b in pairs( Main.Config.CommandOptions[ Key ] ) do
			
			Value[ a ] = b
			
		end
		
	end
	
	local Options = Value.Commands and AliasCmdOptions or CmdOptions
	
	for a, b in pairs( Options ) do
		
		local Valid = CheckType( Value[ a ], b )
		
		if not Valid then
			
			warn( ModName .. ":" .. Key .. ":" .. a .. " is invalid" )
			
			return
			
		end
		
	end
	
	for a, b in pairs( Value ) do
		
		if not Options[ a ] then warn( ModName .. ":" .. Key .. ":" .. a .. " is not a Command Option" ) end
		
	end
	
	local Str = ""
	
	if not Value.ArgTypes or #Value.ArgTypes == 0 then
		
		Str = Str .. "/"
		
	else
		
		for a = 1, #Value.ArgTypes do
			
			local Prefix, Suffix = "[/", "]"
			
			repeat
				
				if type( Value.ArgTypes[ a ] ) == "table" then
					
					if Value.ArgTypes[ a ].Required then
						
						Prefix, Suffix = "/<", ">"
						
					end
					
					local Opts = ""
					
					for a, b in pairs( Value.ArgTypes[ a ] ) do
						
						if a ~= "Name" and a ~= "Required" and a ~= "Default" and a ~= "Func" and b then
							
							Opts = Opts .. a .. "=" .. tostring( b ) .. ", "
							
						end
						
					end
					
					if Opts ~= "" then
						
						Suffix = "(" .. Opts:sub( 1, Opts:len( ) - 2 ) .. ")" .. Suffix
						
					end
					
					if Value.ArgTypes[ a ].Name then
						
						Str = Str .. Prefix .. Value.ArgTypes[ a ].Name .. Suffix
						
						do break end
						
					end
					
				end
				
				local Type = Main.TargetLib.GetArgType( type( Value.ArgTypes[ a ] ) == "function" and Value.ArgTypes[ a ] or Value.ArgTypes[ a ].Func )
				
				Type = ( Main.TargetLib.ArgTypeNames[ Type ] or Type or "string" ):lower( )
				
				Str = Str .. Prefix .. Type .. Suffix
				
			until true
			
		end
		
	end
	
	UsageCache[ Value ] = Str
	
	for a = 1, #Value.Alias do
		
		if type( Value.Alias[ a ] ) == "table" then
			--TODO
			--MAKE ERROR
			if AliasCache[ Value.Alias[ a ][ 1 ] ] then warn( Key .. ": Alias " .. Value.Alias[ a ][ 2 ] .. " is already used" ) end
			
			AliasFunctions[ Value.Alias[ a ][ 1 ] ] = Value
			
			AliasCache[ Value.Alias[ a ][ 1 ] ] = Value
			
		else
			--TODO
			--MAKE ERROR
			if AliasCache[ Value.Alias[ a ] ] then warn( Key .. ": Alias " .. Value.Alias[ a ] .. " is already used" ) end
			
			AliasCache[ Value.Alias[ a ] ] = Value
			
		end
		
	end
	
	if Value.Config then
		
		for a, b in pairs( Value.Config ) do
			
			if not Main.Config[ a ] then
				
				Main.Config[ a ] = b
				
			end
			
		end

	end
	
	if ModName and Mod.script.Parent ~= script.Default_Command_Modules and Mod.script ~= VH_Command_Processor then
		
		print( ModName .. ":" .. Key .. " added" )
		
	end
	
	Value.Name = Key
	
	rawset( self, Key, Value )
	
end

function Main.GetCommandAndArgs( Key, Plr )
	
	if AliasCache[ Key ] then
		
		return AliasCache[ Key ]
		
	end
	
	if type( Key ) ~= "string" then return end
	
	for a, b in pairs( AliasFunctions ) do
		
		local Args = { a( b, Key, Plr ) }
		
		if Args[ 1 ] then
			
			return b, unpack( Args, 2 )
			
		end
		
	end
	
end

Main.Commands = setmetatable( { }, { __metatable = "protected", __newindex = Metatable } )


----==== Command Modules ====----

_G.VH_Admin = Main

VH_Command_Modules = ServerStorage:FindFirstChild( "VH_Command_Modules" )

if not VH_Command_Modules then
	
	VH_Command_Modules = Instance.new( "Folder" )
	
	VH_Command_Modules.Name = "VH_Command_Modules"
	
	VH_Command_Modules.Parent = ServerStorage
	
end

VH_Command_Clients = ReplicatedStorage:FindFirstChild( "VH_Command_Clients" )

if not VH_Command_Clients then
	
	VH_Command_Clients = Instance.new( "Folder" )
	
	VH_Command_Clients.Name = "VH_Command_Clients"
	
	VH_Command_Clients.Parent = ReplicatedStorage
	
end

local Loaded = { }

local Loading = { }

local function RequireModule( Mod, Required, LoopReq )
	
	if ( not Main.Config.DisabledCommandModules[ Mod.Name ] or Required ) and not Loaded[ Mod ] then
		
		Loading[ Mod ] = true
		
		LoopReq = LoopReq or { }
		
		LoopReq[ Mod ] = true
		
		if Mod:FindFirstChild( "Required" ) then
			
			local Required = Mod.Required:GetChildren( )
			
			for a = 1, #Required do
				
				if not Required[ a ].Value then
					
					Loading[ Mod ] = false
					
					warn( Required[ a ]:GetFullName( ) .. " is an empty require" )
					
					return false
					
				end
				
				if LoopReq[ Required[ a ].Value ] then
					
					Loading[ Mod ] = false
					
					return false, true
					
				end
				
				local Start = tick( )
				
				while Loading[ Required[ a ].Value ] and wait( ) do
					
					if Start and tick( ) - Start > 5 then
						
						Start = nil
						
						warn( Required[ a ].Value.Name .. " is taking a long time to be required" )
						
					end
					
				end
				
				if Loading[ Required[ a ].Value ] == false then
					
					warn( Mod.Name .. " failed to load due to an error loading " .. Required[ a ].Value.Name )
					
					Loading[ Mod ] = false
					
					return false
					
				end
				
				if not Loaded[ Required[ a ].Value ] then
					
					local Ran, Loop = RequireModule( Required[ a ].Value, true, LoopReq )
					
					if Ran == false then
						
						if Loop then
							
							Loading[ Mod ] = false
							
							warn( "Required loop - " .. Mod.Name .. " and " .. Required[ a ].Value.Name )
							
						end
						
						return false
						
					end
					
				end
				
			end
			
		end
		
		local ModFolder
		
		if Mod:FindFirstChild( "Client" ) then
			
			local Events = Mod:GetChildren( )
			
			for a = 1, #Events do
				
				if Events[ a ]:IsA( "RemoteEvent" ) or Events[ a ]:IsA( "RemoteFunction" ) then
					
					if not ModFolder then
						
						ModFolder = Instance.new( "Folder" )
						
						ModFolder.Name = "VH_" .. Mod.Name
						
					end
					
					Events[ a ].Parent = ModFolder
					
				end
				
			end
			
			if ModFolder then
				
				ModFolder.Parent = ReplicatedStorage
				
			end
			
			local CommandClient = Mod.Client
			
			CommandClient.Name = "VH_" .. Mod.Name .. "_Client"
			
			CommandClient.Parent = VH_Command_Clients
			
			ModuleObjs[ Mod ] = { CommandClient, ModFolder }
			
		end
		
		local Ran, Error = pcall( function ( ) require( Mod )( Main, ModFolder, VH_Events ) end )
		
		if not Ran then
			
			warn( Mod.Name .. " errored when required:\n" .. Error )
			
			if ModFolder then
				
				ModFolder:Destroy( )
				
			end
			
			Loading[ Mod ] = false
			
			return false
			
		end
		
		Loading[ Mod ] = nil
		
		Loaded[ Mod ] = true
		
	end
	
end

local Mods = script.Default_Command_Modules:GetChildren( )

for a = 1, #Mods do
	
	if Mods[ a ] == script.Default_Command_Modules.Core or not VH_Command_Modules:FindFirstChild( Mods[ a ].Name ) then
		
		coroutine.wrap( RequireModule )( Mods[ a ], Mods[ a ] == script.Default_Command_Modules.Core )
		
	end
	
end

Main.Events[ #Main.Events + 1 ] = VH_Command_Modules.ChildAdded:Connect( RequireModule )

Mods = VH_Command_Modules:GetChildren( )

for a = 1, #Mods do
	
	coroutine.wrap( RequireModule )( Mods[ a ] )
	
end

----==== External Commands ====----
--[[repeat wait( ) until _G.VH_AddExternalCmds
_G.VH_AddExternalCmds( function ( Main ) end )]]--

local VH_ExternalCmds = ( _G.VH_Saved or { } ).VH_ExternalCmds or { }

VH_Events.Destroyed.Event:Connect( function ( Update )
	
	if not Update then return end
	
	_G.VH_Saved.VH_ExternalCmds = VH_ExternalCmds
	
end )

function _G.VH_AddExternalCmds( Func )
	
	VH_ExternalCmds[ #VH_ExternalCmds + 1 ] = Func
	
	Func( Main )
	
	return #VH_ExternalCmds
	
end

function _G.VH_RemoveExternalCmds( Key )
	
	local Size = #_G.VH_ExternalCmds
	
	_G.VH_ExternalCmds[ Key ] = _G.VH_ExternalCmds[ Size ]
	
	_G.VH_ExternalCmds[ Size ] = nil
	
end

for a = 1, #VH_ExternalCmds do
	
	coroutine.wrap( VH_ExternalCmds[ a ] )( Main )
	
end

----==== Events & Client ====----

VH_Events.RunCommand.OnServerInvoke = Main.ParseCmdStacks

VH_Events.RunCmdStacks.OnServerInvoke = Main.RunCmdStacks

Main.Events[ #Main.Events + 1 ] = Players.PlayerAdded:Connect( Main.PlayerAdded )

local VH_Client = script.VH_Client

VH_Client.Parent = game:GetService( "StarterPlayer" ):WaitForChild( "StarterPlayerScripts" )

local Plrs = Players:GetPlayers( )

for a = 1, #Plrs do
	
	spawn( function ( ) Main.PlayerAdded( Plrs[ a ], Updated ) end )
	
	if Plrs[ a ]:FindFirstChild( "Backpack" ) then
		
		VH_Client:Clone( ).Parent = Plrs[ a ].Backpack
		
	end
	
end

Main.Events[ #Main.Events + 1 ] = Players.PlayerRemoving:Connect( function ( Plr )
	
	if Main.Config.AnnounceLeft then
		
		if Main.AnnouncedLeft[ Plr ] ~= false then
			
			Main.Util.SendMessage( nil, Plr.Name .. ( Main.AnnouncedLeft[ Plr ] or " has left" ), "Info" )
			
		end
		
		Main.AnnouncedLeft[ Plr ] = nil
		
	end
	
end )

Main.TargetLib.Toggles = ( _G.VH_Saved or { } ).TL_Toggles or Main.TargetLib.Toggles

VH_Events.Destroyed.Event:Connect( function ( Update )
	
	if not Update then return end
	
	_G.VH_Saved.TL_Toggles = Main.TargetLib.Toggles
	
end )

----==== Cleanup saved variables ====----

_G.VH_Saved = nil

if game:GetService( "StarterGui" ):FindFirstChild( "ErrorNotification" ) then
	
	game:GetService( "StarterGui" ).ErrorNotification:Destroy( )
	
end

script.ErrorNotification.Parent = game:GetService( "StarterGui" )

return Main