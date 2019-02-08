return function ( ChatService )
	
	repeat wait( ) until _G.VH_Admin
	
	local Main = _G.VH_Admin
	
	local VH_Events = game:GetService( "ReplicatedStorage" ):WaitForChild( "VH_Events" )
	
	local Util_Events_Folder = game:GetService( "ReplicatedStorage" ):WaitForChild( "VH_Util" )
	
	if ChatService:GetChannel( "V-Handle" ) then
		
		ChatService:RemoveChannel( "V-Handle" )
		
	end
	
	if ChatService:ProcessCommandsFunctionExists( "VH_Command_Processor" ) then
		
		ChatService:UnregisterProcessCommandsFunction( "VH_Command_Processor" )
		
	end
	
	local VH_Channel = ChatService:AddChannel( "V-Handle" )
	
	local Speakers = ChatService:GetChannel( "All" ):GetSpeakerList( )
	
	for a = 1, #Speakers do
		
		local SpeakerObj = ChatService:GetSpeaker( Speakers[ a ] )
		
		if SpeakerObj then
			
			SpeakerObj:JoinChannel( "V-Handle" )
			
		end
		
	end
	
	VH_Channel.AutoJoin = true
	
	VH_Channel.Private = true
	
	Main.Events[ #Main.Events + 1 ] = VH_Channel.SpeakerMuted:Connect( function ( Name )
		
		VH_Channel:UnmuteSpeaker( Name )
		
	end )
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if ChatService:GetChannel( "V-Handle" ) then
			
			ChatService:RemoveChannel( "V-Handle" )
			
		end
		
		if ChatService:ProcessCommandsFunctionExists( "VH_Command_Processor" ) then
			
			ChatService:UnregisterProcessCommandsFunction( "VH_Command_Processor" )
			
		end
		
	end )
	
	ChatService:RegisterProcessCommandsFunction( "VHEmotes", function ( SpeakerName, Message, Channel )
		
		local SpeakerObj = ChatService:GetSpeaker( SpeakerName )
		
		if not SpeakerObj then return false end
		
		if Message == "/shrug" then
			
			SpeakerObj:SayMessage( "¯\\_(ツ)_/¯", Channel )
			
			return true
			
		elseif Message == "/tableflip" then
			
			SpeakerObj:SayMessage( "(╯°□°）╯︵ ┻━┻", Channel )
			
			return true
			
		elseif Message == "/unflip" then
			
			SpeakerObj:SayMessage( "┬─┬ ノ( ゜-゜ノ)", Channel )
			
			return true
			
		end
		
		return false
		
	end )
	
	ChatService:RegisterProcessCommandsFunction( "VH_Command_Processor", function ( SpeakerName, Message, Channel )
		
		local SpeakerObj = ChatService:GetSpeaker( SpeakerName )
		
		if not SpeakerObj then return false end
		
		if Channel == "V-Handle" and SpeakerObj:GetExtraData( "RanCmd" ) then
			
			SpeakerObj:SetExtraData( "RanCmd", nil )
			
			return false
			
		end
		
		local Plr = SpeakerObj:GetPlayer( )
		
		if Plr and ( Channel == "All" or Channel == "V-Handle" ) then
			
			return Main.ParseCmdStacks( Plr, ( Channel == "V-Handle" and "log/" or "" ) ..  Message, SpeakerObj ) or false
			
		end
		
		return false
		
	end )
	
	repeat wait( ) until _G.VH_Admin and _G.VH_Admin.Util
	
	local Main = _G.VH_Admin
	
	function GetChannels( )
		
		local Channels = { }
		
		for a, b in pairs( ChatService.ChatChannels ) do
			
			Channels[ #Channels + 1 ] = a
			
		end
		
		return Channels
		
	end
	
	function Main.TargetLib.FindChannels( self, String, Plr )
		
		return Main.TargetLib.MultipleOf( self, String, Plr, { }, GetChannels( ) )
		
	end
	
	Main.TargetLib.AddArgMultiple( "Channel" )
	
	Main.Commands.Channels = {
		
		Alias = { "channels" },
		
		Description = "Displays a list of channels",
		
		Category = "Chats",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Str = ""
			
			local Channels = ChatService.ChatChannels
			
			for a, b in pairs( Channels ) do
				
				Str = Str .. a .. "\n"
				
			end
			
			if Str == "" then
				
				Str = "No channels exist"
				
			else
				
				Str = "Channels:\n" .. Main.Util.utf8sub( Str, 1, utf8.len( Str ) - 1 )
				
			end
			
			Util_Events_Folder.Print:FireClient( Plr, Str )
			
			if Silent then return true, "Check your client log ( F9 )" end
			
			Main.Util.SendMessage( Plr, "Check your client log ( F9 )" )
			
			return true
			
		end
		
	}
	
	local Muted = ( _G.VH_Saved or { } ).Muted or { }
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then return end
		
		_G.VH_Saved.Muted = Muted
		
	end )
	
	Main.Events[ #Main.Events + 1 ] = game:GetService( "Players" ).PlayerAdded:Connect( function ( Plr )
		
		if Muted[ Plr.UserId ] then
			
			for a, b in pairs( Muted[ Plr.UserId ] ) do
				
				local Channel = ChatService:GetChannel( b )
				
				if Channel then
					
					Channel:MuteSpeaker( Plr.Name )
					
				end
				
			end
			
		end
		
	end )
	
	Main.Commands.Mute = {
		
		Alias = { "mute" },
		
		Description = "Mutes the specified player(s)",
		
		Category = "Chats",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, Main.TargetLib.ArgTypes.Channels },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs, Channels = Args[ 1 ], Args[ 2 ] or GetChannels( )
			
			for a = 1, #Plrs do
				
				for b = 1, #Channels do
					
					Muted[ Plrs[ a ].UserId ] = Muted[ Plrs[ a ].UserId ] or { }
					
					Muted[ Plrs[ a ].UserId ][ Channels[ b ] ] = true
					
					local Channel = ChatService:GetChannel( Channels[ b ] )
					
					Channel:MuteSpeaker( Plrs[ a ].Name )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Unmute = {
		
		Alias = { "unmute" },
		
		Description = "Unmutes the specified player(s)",
		
		Category = "Chats",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, Main.TargetLib.ArgTypes.Channels },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs, Channels = Args[ 1 ], Args[ 2 ] or GetChannels( )
			
			for a = 1, #Plrs do
				
				for b = 1, #Channels do
					
					if Muted[ Plrs[ a ].UserId ] and Muted[ Plrs[ a ].UserId ][ Channels[ b ] ] then
						
						Muted[ Plrs[ a ].UserId ][ Channels[ b ] ] = nil
						
						local Found = false
						
						for a, b in pairs( Muted[ Plrs[ a ].UserId ] ) do Found = true break end
						
						if not Found then Muted[ Plrs[ a ].UserId ] = nil end
						
					end
					
					local Channel = ChatService:GetChannel( Channels[ b ] )
					
					Channel:UnmuteSpeaker( Plrs[ a ].Name )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	local TextService = game:GetService( "TextService" )
	
	Main.Commands.Broadcast = {
		
		Alias = { "broadcast", "bc" },
		
		Description = "Broadcasts the specified message to all players chat",
		
		Category = "Messages",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Main.Util.SendMessage( nil, Main.Util.UsernameFromID( Plr.UserId ) .. ": " .. TextService:FilterStringAsync( Args[ 1 ], Plr.UserId ):GetNonChatStringForBroadcastAsync( ) )
			
			return true
			
		end
		
	}
	
	--[[local allChannel = ChatService:GetChannel("All")
	if (allChannel) then
		allChannel.WelcomeMessage = "Chat '/?' or '/help' for a list of chat commands."
	end]]
	
end