return function ( Main, Client, VH_Events )
	
	local Teams, Players, TeleportService, PointsService, Lighting = game:GetService( "Teams" ), game:GetService( "Players" ), game:GetService( "TeleportService" ), game:GetService( "PointsService" ), game:GetService( "Lighting" )
	
	Main.Commands.Calculate = {
		
		Alias = { "calculate", "calc" },
		
		Description = "Calculates out the given equation",
		
		Category = "Math",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Number, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Silent then return true, Args[ 1 ] end
			
			Main.Util.SendMessage( Plr, Args[ 1 ], "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.Give = {
		
		Alias = { "give", "givetool" },
		
		Description = "Gives the specified player(s) the specified tools",
		
		Category = "Tools",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Tools, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if Args[ 1 ][ a ]:FindFirstChild( "Backpack" ) then
					
					for b = 1, #Args[ 2 ] do
						
						Args[ 2 ][ b ]:Clone( ).Parent = Args[ 1 ][ a ].Backpack
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Take = {
		
		Alias = { "take", "taketool", "strip" },
		
		Description = "Takes the specified tools from the specified player(s)",
		
		Category = "Tools",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.String, Required = true, Name = "tool..." } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				local Tools = Main.TargetLib.FindTools( self.ArgTypes[ 2 ], Args[ 2 ], Plr, Main.Util.GetPlayerTools( Args[ 1 ][ a ] )  )
				
				for b = 1, #Tools do
					
					Tools[ b ]:Destroy( )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.PermGive = {
		
		Alias = { "permgive", "toggle" },
		
		Description = "Gives the specified tools to the specified player(s) permanently",
		
		Category = "Tools",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Tools, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				for b = 1, #Args[ 2 ] do
					
					if Args[ 1 ][ a ]:FindFirstChild( "StarterGear" ) then
						
						Args[ 2 ][ b ]:Clone( ).Parent = Args[ 1 ][ a ].StarterGear
						
					end
					
					if Args[ 1 ][ a ]:FindFirstChild( "Backpack" ) then
						
						Args[ 2 ][ b ]:Clone( ).Parent = Args[ 1 ][ a ].Backpack
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.PermTake = {
		
		Alias = { "permtake", "untoggle" },
		
		Description = "Takes the specified tools from the specified player(s) permanently",
		
		Category = "Tools",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.String, Required = true, Name = "tool..." } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				local Tools = Main.TargetLib.FindTools( { }, Args[ 2 ], Plr, Main.Util.GetPlayerTools( Args[ 1 ][ a ], true )  )
				
				for b = 1, #Tools do
					
					Tools[ b ]:Destroy( )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Rank = {
		
		Alias = { "rank" },
		
		Description = "Gets the rank of the specified player in the specified group",
		
		Category = "Groups",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Number, Required = true, Name = "groupid" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local String = ""
			
			for a = 1, #Args[ 1 ] do
				
				String = String .. Args[ 1 ][ a ].Name .. " is rank " .. Args[ 1 ][ a ]:GetRankInGroup( Args[ 2 ] ) .. " - " .. Args[ 1 ][ a ] :GetRoleInGroup( Args[ 2 ] ) .. "\n"
				
			end
			
			String = String:sub( 1, -2 )
			
			if Silent then return true, String end
			
			Main.Util.SendMessage( Plr, String, "Info" )
			
			return true
			
		end
		
	}
	
	Client.Spectate.OnServerEvent:Connect( function ( Plr )
		
		Plr:LoadCharacter( )
		
	end )
	
	Main.Commands.Spectate = {
		
		Alias = { Main.TargetLib.AliasTypes.Toggle( 1, "spectate", "watch", "spec" ) },
		
		Description = "Spectates the specified player or free camera",
		
		Category = "Players",
		
		CanRun = "$moderator&!$console",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Boolean, Default = Main.TargetLib.Defaults.Toggle }, Main.TargetLib.ArgTypes.Player },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Args[ 1 ] then
				
				if Args[ 2 ] == Plr then return false, "You can't spectate yourself!" end
				
				if Plr.Character then
					
					Plr.Character:Destroy( )
					
				end
				
				Client.Spectate:FireClient( Plr, Args[ 2 ] )
				
			else
				
				Client.Spectate:FireClient( Plr, false )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Kill = {
		
		Alias = { "kill", "slay" },
		
		Description = "Kills the specified player(s)",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if Args[ 1 ][ a ].Character and Args[ 1 ][ a ].Character:FindFirstChild( "Humanoid" ) then
					
					Args[ 1 ][ a ].Character:FindFirstChild( "Humanoid" ).Health = 0
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	local LuaLoadCharacter = function ( Obj ) Obj:LoadCharacter( ) end
	
	Main.Commands.Respawn = {
		
		Alias = { "respawn", "re" },
		
		Description = "Respawns the specified player(s)",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				coroutine.wrap( LuaLoadCharacter )( Args[ 1 ][ a ] )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Heal = {
		
		Alias = { "heal" },
		
		Description = "Full heals the target player(s)",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					Plrs[ a ].Character.Humanoid.Health = Plrs[ a ].Character.Humanoid.MaxHealth
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	local Blind = ( _G.VH_Saved or { } ).Blind or setmetatable( { }, { __mode = "k" } )
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then
			
			for a, b in pairs( Blind ) do
				
				b:Destroy( )
				
			end
			
			return
			
		end
		
		_G.VH_Saved.Blind = Blind
		
	end )
	
	Main.Commands.Blind = {
		
		Alias = { Main.TargetLib.AliasTypes.Toggle( 2, "blind" ) },
		
		Description = "Makes the specified player(s) (un)blind",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Boolean, Default = Main.TargetLib.Defaults.Toggle } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local GUI = Instance.new( "ScreenGui" )
			
			GUI.Name = "VH_Blind"
			
			GUI.ResetOnSpawn = false
			
			local Frame = Instance.new( "Frame", GUI )
			
			Frame.Size = UDim2.new( 10, 0, 10, 0 )
			
			Frame.Position = UDim2.new( -5, 0, -5, 0 )
			
			Frame.BackgroundColor3 = Color3.new( 0, 0, 0 )
			
			Frame.ZIndex = -10
			
			for a = 1, #Args[ 1 ] do
				
				local PlayerGui = Args[ 1 ][ a ]:FindFirstChildOfClass( "PlayerGui" )
				
				if PlayerGui then
					
					if Args[ 2 ] then
						
						if not Blind[ Args[ 1 ][ a ] ] then
							
							local Clone = GUI:Clone( )
							
							Clone.Parent = PlayerGui
							
							Blind[ Args[ 1 ][ a ] ] = Clone
							
						end
						
					else
						
						Blind[ Args[ 1 ][ a ] ]:Destroy( )
						
						Blind[ Args[ 1 ][ a ] ] = nil
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	local Invincible = ( _G.VH_Saved or { } ).Invincible or setmetatable( { }, { __mode = "k" } )
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then return end
		
		_G.VH_Saved.Invincible = Invincible
		
	end )
	
	Main.Commands.Invincible = {
		
		Alias = { Main.TargetLib.AliasTypes.Toggle( 2, "invincible", "god" ) },
		
		Description = "Makes the specified player(s) invincible/vincible",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable }, { Func = Main.TargetLib.ArgTypes.Boolean, Default = Main.TargetLib.Defaults.Toggle } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				local Hum = Args[ 1 ][ a ].Character and Args[ 1 ][ a ].Character:FindFirstChildOfClass( "Humanoid" )
				
				if Hum then
					
					if Args[ 2 ] then
						
						Invincible[ Args[ 1 ][ a ] ] = { Hum.Health, Hum.MaxHealth }
						
						Hum.MaxHealth = math.huge
						
						Hum.Health = math.huge
						
					else
						
						local Health, Max = unpack( Invincible[ Args[ 1 ][ a ] ] or { 100, 100 } )
						
						Hum.MaxHealth = Max or 100
						
						Hum.Health = Health or 100
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.ForceField = {
		
		Alias = { Main.TargetLib.AliasTypes.Toggle( 2, "ff", "forcefield" ) },
		
		Description = "Gives/removes the specified player(s) forcefield",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable }, { Func = Main.TargetLib.ArgTypes.Boolean, Default = Main.TargetLib.Defaults.Toggle } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if Args[ 1 ][ a ].Character then
					
					if Args[ 2 ] then
						
						Instance.new( "ForceField", Args[ 1 ][ a ].Character ).Name = "VH_FF"
						
					else
						
						while Args[ 1 ][ a ].Character:FindFirstChildOfClass( "ForceField" ) do
							
							Args[ 1 ][ a ].Character:FindFirstChildOfClass( "ForceField" ):Destroy( )
							
						end
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Invisible = {
		
		Alias = { "invisible", "hide", "cloak" },
		
		Description = "Makes the specified player(s) invisible/visible",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable }, { Func = Main.TargetLib.ArgTypes.Boolean, Default = Main.TargetLib.Defaults.Toggle } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if Args[ 1 ][ a ].Character then
					
					local Children = Args[ 1 ][ a ].Character:GetDescendants( )
					
					for b = 1, #Children do
						
						local Property = ( ( Children[ b ]:IsA( "BasePart" ) or Children[ b ]:IsA( "Decal" ) ) and "Transparency" )
						
						if Property then
							
							local Old = Children[ b ]:FindFirstChild( "VH_Invisible_Old" )
							
							if Args[ 2] then
								
								local Old = Instance.new( "NumberValue" )
								
								Old.Name = "VH_Invisible_Old"
								
								Old.Value = Children[ b ][ Property ]
								
								Old.Parent = Children[ b ]
								
								Children[ b ][ Property ] = 1
								
							elseif Old then
								
								Children[ b ][ Property ] = Old.Value
								
							end
							
							if Old then Old:Destroy( ) end
							
						end
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	local Spawns = ( _G.VH_Saved or { } ).Spawns or { }
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then
			
			for a, b in pairs( Spawns ) do
				
				b[ 2 ]:Disconnect( )
				
				Spawns[ a ] = nil
				
			end
			
			return
			
		end
		
		_G.VH_Saved.Spawns = Spawns
		
	end )
	
	function SpawnEvent( Plr, Char )
		
		Char:WaitForChild( "HumanoidRootPart" ).CFrame = Spawns[ Plr ][ 1 ]
		
	end
	
	for Plr, Objs in pairs( Spawns ) do
		
		Objs[ 2 ]:Disconnect( )
		
		Objs[ 2 ] = Plr.CharacterAppearanceLoaded:Connect( function ( Char ) SpawnEvent( Plr, Char ) end )
		
	end
	
	Main.Commands.SetSpawn = {
		
		Alias = { "setspawn" },
		
		Description = "Sets the specified player(s) spawn to your current location",
		
		Category = "Characters",
		
		CanRun = "$moderator&!$console",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local CF = Plr.Character and Plr.Character:FindFirstChild( "HumanoidRootPart" ) and Plr.Character.HumanoidRootPart.CFrame
			
			if not CF then return false, "You must be alive and have a Torso" end
			
			for a = 1, #Args[ 1 ] do
				
				if Spawns[ Args[ 1 ][ a ] ] then
					
					Spawns[ Args[ 1 ][ a ] ][ 1 ] = CF
					
				else
					
					Spawns[ Args[ 1 ][ a ] ] = { CF, Args[ 1 ][ a ].CharacterAppearanceLoaded:Connect( function ( Char ) SpawnEvent( Args[ 1 ][ a ], Char ) end ) }
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.RemoveSpawn = {
		
		Alias = { "removespawn", "unsetspawn" },
		
		Description = "Removes the specified player(s) custom spawns",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if Spawns[ Args[ 1 ][ a ] ] then
					
					Spawns[ Args[ 1 ][ a ] ][ 2 ]:Disconnect( )
					
					Spawns[ Args[ 1 ][ a ] ] = nil
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Health = {
		
		Alias = { "health", "sethealth", "sh" },
		
		Description = "Sets the specified players health to a specific amount or to a percent of max health ( e.g. 50% )",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = function ( self, Strings, Plr )
			
			local String = table.remove( Strings, 1 )
			
			if String == Main.TargetLib.ValidChar then return { true, 0.75 } end
			
			if String:sub( -1 ) == "%" and tonumber( String:sub( 1, -2 ) ) then
				
				return { false, tonumber( String:sub( 1, -2 ) ) / 100 }
				
			elseif tonumber( String ) then
				
				return { true, tonumber( String) }
				
			end
			
			return nil, false
			
		end, Required = true, Name = "number_or_percentage" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
				
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					local Humanoid = Plrs[ a ].Character.Humanoid
					
					if Args[ 2 ][ 1 ] then
						
						Humanoid.Health = Args[ 2 ][ 2 ]
						
					else
						
						Humanoid.Health = Humanoid.MaxHealth * Args[ 2 ][ 2 ]
						
					end
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.MaxHealth = {
		
		Alias = { "maxhealth", "mh" },
		
		Description = "Sets the maximum health of the specified player(s) to the specified amount",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Number, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					local Humanoid = Plrs[ a ].Character.Humanoid
					
					Humanoid.MaxHealth = Args[ 2 ]
					
					Humanoid.Health = math.min( Humanoid.Health, Humanoid.MaxHealth )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Speed = {
		
		Alias = { "speed", "walkspeed", "ws" },
		
		Description = "Sets the walkspeed of the specified player(s) to the specified amount",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Number, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					Plrs[ a ].Character.Humanoid.WalkSpeed = Args[ 2 ]
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Damage = {
		
		Alias = { "damage" },
		
		Description = "Damages the specified player by the specified amount",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Number, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					Plrs[ a ].Character.Humanoid:TakeDamage( Args[2] )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Jump = {
		
		Alias = { "jump" },
		
		Description = "Causes the specified player(s) to jump",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					Plrs[ a ].Character.Humanoid.Jump = true
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Return = {
		
		Alias = { "return" },
		
		Description = "Teleports the specified player to the place before they were last teleported",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Player, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if not Main.Util.LastPos[ Args[ 1 ] ] then return false, "No previous location found" end
			
			Main.Util.Teleport( Args[ 1 ], Main.Util.LastPos[ Args[ 1 ] ] )
			
			return true
			
		end
		
	}
	
	Main.Commands.Goto = {
		
		Alias = { "goto" },
		
		Description = "Teleports you to the specified player",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Player, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
				
			Main.Util.Teleport( Plr, Args[ 1 ].Character.HumanoidRootPart.CFrame + Vector3.new( math.random( -20, 20 ), math.random( -20, 20 ), math.random( -20, 20 ) ) / 20 )
			
			return true
			
		end
		
	}
	
	Main.Commands.Bring = {
		
		Alias = { "bring" },
		
		Description = "Teleports the specified player(s) to you",
		
		Category = "Characters",
		
		CanRun = "$moderator&!$console",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			if Plr.Character and Plr.Character:FindFirstChild( "HumanoidRootPart" ) then
				
				for a = 1, #Plrs do
					
					Main.Util.Teleport( Plrs[ a ], Plr.Character.HumanoidRootPart.CFrame + Vector3.new( math.random( -20, 20 ), math.random( -20, 20 ), math.random( -20, 20 ) ) / 20 )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Teleport = {
		
		Alias = { "teleport", "tp", "send" },
		
		Description = "Teleports the specified player(s) to the target player",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Player, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Args[ 2 ].Character and Args[ 2 ].Character:FindFirstChild("HumanoidRootPart") then
				
				local TargRoot = Args[ 2 ].Character.HumanoidRootPart
				
				local Plrs = Args[ 1 ]
				
				for a = 1, #Plrs do
					
					Main.Util.Teleport( Plrs[ a ], TargRoot.CFrame + Vector3.new( math.random( -20, 20 ), math.random( -20, 20 ), math.random( -20, 20 ) ) / 20 )
					
				end
				
				return true
				
			end
			
		end
		
	}
	
	Main.Commands.PlaceTeleport = {
		
		Alias = { "placeteleport", "place" },
		
		Description = "Teleports specified player(s) to the specified place",
		
		Category = "Players",
		
		NoTest = true,
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.PlaceId, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				TeleportService:Teleport( Args[ 2 ], Args[ 1 ][ a ] )
				
				if a == 1 then wait( 1 ) end
				
			end
			
			--TeleportService:TeleportPartyAsync( Args[ 2 ], Args[ 1 ] )
			
			return true
			
		end
		
	}
	
	local TeamOverride = setmetatable( { }, { __mode = "k" } )
	
	local TeamLocked = ( _G.VH_Saved or { } ).TeamLocked or setmetatable( { }, { __mode = "k" } )
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then
			
			for a, b in pairs( TeamLocked ) do
				
				b:Disconnect( )
				
				TeamLocked[ a ] = nil
				
			end
			
			return
			
		end
		
		_G.VH_Saved.TeamLocked = TeamLocked
		
	end )
	
	Main.Commands.LockTeam = {
		
		Alias = { Main.TargetLib.AliasTypes.Toggle( 2, "lockteam", "lteam" ) },
		
		Description = "(Un)Locks the specified player(s) team unless set by admin",
		
		Category = "Players",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Boolean, Default = Main.TargetLib.Defaults.Toggle } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if TeamLocked[ Args[ 1 ][ a ] ] then
					
					TeamLocked[ Args[ 1 ][ a ] ]:Disconnect( )
					
					TeamLocked[ Args[ 1 ][ a ] ] = nil
					
				end
				
				if Args[ 2 ] then
					
					local OriginalTeam = Args[ 1 ][ a ].Team
					
					TeamLocked[ Args[ 1 ][ a ] ] = Args[ 1 ][ a ]:GetPropertyChangedSignal( "Team" ):Connect( function ( )
						
						if TeamOverride[ Args[ 1 ][ a ] ] then
							
							OriginalTeam = Args[ 1 ][ a ].Team
							
							TeamOverride[ Args[ 1 ][ a ] ] = nil
							
						else
							
							Args[ 1 ][ a ].Team = OriginalTeam
							
						end
						
					end )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Team = {
		
		Alias = { "team", "setteam" },
		
		Description = "Changes the team of the specified player(s) to the specified team",
		
		Category = "Players",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Team, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if TeamLocked[ Args[ 1 ][ a ] ] then
					
					TeamOverride[ Args[ 1 ][ a ] ] = true
					
				end
				
				Args[ 1 ][ a ].TeamColor = Args[ 2 ].TeamColor
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.BalanceTeams = {
		
		Alias = { "balanceteams" },
		
		Description = "Balances the specified player(s) between the specified team(s)",
		
		Category = "Players",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Teams } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			local Teams = Args[ 2 ] or Teams:GetTeams( )
			
			local Cur = math.random( 1, #Teams )
			
			while #Plrs > 0 do
				
				local Chosen = math.random( 1, #Plrs )
				
				if TeamLocked[ Plrs[ Chosen ] ] then
					
					TeamOverride[ Plrs[ Chosen ] ] = true
					
				end
				
				Plrs[ Chosen ].TeamColor = Teams[ Cur ].TeamColor
				
				table.remove( Plrs, Chosen )
				
				Cur = Cur + 1
				
				if Cur > #Teams then Cur = 1 end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.RandomiseTeams = {
		
		Alias = { "randomiseteams" },
		
		Description = "Randomly places the specified player(s) in the specified team(s) or all",
		
		Category = "Players",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, Main.TargetLib.ArgTypes.Teams },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Teams = Args[ 2 ] or Teams:GetTeams( )
			
			for a = 1, #Args[ 1 ] do
				
				if TeamLocked[ Args[ 1 ][ a ] ] then
					
					TeamOverride[ Args[ 1 ][ a ] ] = true
					
				end
				
				Args[ 1 ][ a ].TeamColor = Teams[ math.random( #Teams ) ].TeamColor
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Message = {
		
		Alias = { "message", "m" },
		
		Description = "Creates a message with the specified text",
		
		Category = "Messages",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Required = true }, Main.TargetLib.ArgTypes.Time },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Time = Args[ 2 ] or ( #Args[ 1 ] / 15 + 2 )
			
			if Time < 0 then return true end
			
			Main.FilterTo( Plr, nil, "Message", Args[ 1 ], Plr.Name, Time )
			
			if not Silent then
				
				wait( Time )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Hint = {
		
		Alias = { "hint", "h" },
		
		Description = "Creates a hint with the specified text",
		
		Category = "Messages",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.String, Required = true }, Main.TargetLib.ArgTypes.Time },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Time = Args[ 2 ] or ( #Args[ 1 ] / 15 + 2 )
			
			if Time < 0 then return true end
			
			Main.FilterTo( Plr, nil, "Hint", Args[ 1 ], Plr.Name, Time )
			
			if not Silent then
				
				wait( Time )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Stats = {
		
		Alias = { "stats", "change", "setstat", "stat", "setstats" },
		
		Description = "Changes the value of the specified leaderboard stat for the specified player(s)",
		
		Category = "Stats",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.String, Required = true, Name = "stat" }, { Func = Main.TargetLib.ArgTypes.String, Required = true, Name = "value" } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Args[ 2 ] = Args[ 2 ]:lower( )
			
			local Found = false
			
			for a = 1, #Args[ 1 ] do
				
				local Stats = Args[ 1 ][ a ]:FindFirstChild( "leaderstats" )
				
				if Stats then
					
					Stats = Stats:GetChildren( )
					
					for a = 1, #Stats do
						
						if Stats[ a ].Name:lower( ):sub( 1, #Args[ 2 ] ) == Args[ 2 ]:lower( ) then
							
							Stats[ a ].Value = Args[ 3 ]
							
							Found = true
							
						end
						
					end
					
				end
				
			end
			
			if Found then return true end
			
			return false, "Argument 2 is incorrect"
			
		end
		
	}
	
	Main.Commands.ResetStats = {
		
		Alias = { "resetstats", "rs" },
		
		Description = "Changes the value of all number leaderboard stats to 0 for the specified player(s)",
		
		Category = "Stats",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Found = false
			
			for a = 1, #Args[ 1 ] do
				
				local Stats = Args[ 1 ][ a ]:FindFirstChild( "leaderstats" )
				
				if Stats then
					
					Stats = Stats:GetChildren( )
					
					for a = 1, #Stats do
						
						if type( Stats[ a ].Value ) == "number" then
							
							Stats[ a ].Value = 0
							
							Found = true
							
						end
						
					end
					
				end
				
			end
			
			if Found then return true end
			
			return false, "Argument 2 is incorrect"
			
		end
		
	}
	
	local Locked = ( _G.VH_Saved or { } ).Locked
	
	VH_Events.Destroyed.Event:Connect( function ( Update )
		
		if not Update then
			
			if Locked then
				
				Locked[ 1 ]:Destroy( )
				
				Locked[ 2 ]:Disconnect( )
				
			end
			
			return
			
		end
		
		_G.VH_Saved.Locked = Locked
		
		return true
		
	end )
	
	local Hard, Soft, Number = { [ "hard" ] = 0, [ "h" ] = 0, [ "true" ] = 0 }, { [ "soft" ] = 1, [ "s" ] = 1, [ "false" ] = 1 }, { [ "number" ] = 2, [ "n" ] = 2 }
	
	Main.Commands.LockServer = {
		
		Alias = { "lockserver" },
		
		Description = "Prevents players from joining the server\nIf the second argument is 'soft' players that leave can rejoin, if it is 'number' it locks it to the number of players on each team",
		
		Category = "Servers",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = function ( self, Strings, Plr )
			
			local String = table.remove( Strings, 1 ):lower( )
			
			return ( String == Main.TargetLib.ValidChar or Hard[ String ] ) or Soft[ String ] or Number[ String ] or nil
			
		end, Name = "hard_soft_number" }, Main.TargetLib.ArgTypes.Time },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Locked then
				
				Main.Commands.UnlockServer.Callback( )
				
			end
			
			local PlrIds = { }
			
			if Args[ 1 ] == 1 then
				
				local Plrs = Players:GetPlayers( )
				
				for a = 1, #Plrs do
					
					PlrIds[ Plrs[ a ].UserId ] = true
					
				end
				
			elseif Args[ 1 ] == 2 then
				
				local Teams = Teams:GetTeams( )
				
				for a = 1, #Teams do
					
					PlrIds[ Teams[ a ] ] = #Teams[ a ]:GetPlayers( )
					
				end
				
			end
			
			local H = Instance.new( "Hint" )
			
			Locked = { H, Players.PlayerAdded:Connect( function ( Plr )
				
				if Args[ 1 ] == 1 then
					
					if PlrIds[ Plr.UserId ] then
						
						return
						
					end
					
				elseif Args[ 1 ] == 2 then
					
					wait( )
					
					if #Plr.Team:GetPlayers( ) <= PlrIds[ Plr.Team ] then
						
						return
						
					end
					
				end
				
				Main.AnnounceJoin[ Plr ] = Main.AnnounceJoin[ Plr ] or { }
				
				Main.AnnounceJoin[ Plr ][ #Main.AnnounceJoin[ Plr ] + 1 ] = "the server is locked"
				
				Main.AnnouncedLeft[ Plr ] = false
					
				Plr:Kick( "Server is locked" )
				
			end ) }
			
			if Args[ 1 ] == 1 then
				
				H.Text = "This server has been soft locked, if you leave you can rejoin"
				
			elseif Args[ 1 ] == 2 then
				
				H.Text = "The team numbers have been locked"
				
			else
				
				H.Text = "This server has been locked"
				
			end
			
			H.Parent = workspace
			
			if Args[ 2 ] then
				
				delay( Args[ 2 ], function ( )
					
					if Locked then Main.Commands.UnlockServer.Callback( ) end
					
				end )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.UnlockServer = {
		
		Alias = { "unlockserver" },
		
		Description = "Unlocks the server",
		
		Category = "Servers",
		
		CanRun = "$moderator",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if not Locked then return false, "Server isn't locked" end
			
			Locked[ 1 ]:Destroy( )
			
			Locked[ 2 ]:Disconnect( )
			
			Locked = nil
			
			return true
			
		end
		
	}
	
	local Rejoining, RejoiningEvent
	
	Main.Commands.Rejoin = {
		
		Alias = { "rejoin" },
		
		Description = "Makes you rejoin the server",
		
		Category = "Debug",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			if Plr:FindFirstChild( "leaderstats" ) then
				
				Rejoining = Rejoining or { }
				
				Rejoining[ Plr.UserId ] = { ["Team"] = Plr.Team }
				
				local Stats = Plr.leaderstats:GetChildren( )
				
				for a = 1, #Stats do
					
					Rejoining[ Plr.UserId ][ Stats[ a ].Name ] = Stats[ a ].Value
					
				end
				
				if not RejoiningEvent then
					
					RejoiningEvent = Players.PlayerAdded:Connect( function ( Plr )
						
						if Rejoining[ Plr.UserId ] then
							
							local leaderstats = Plr:WaitForChild( "leaderstats" )
							
							for a, b in pairs( Rejoining[ Plr.UserId ] ) do
								
								leaderstats:WaitForChild( a ).Value = b
								
							end
							
							wait()
							
							Plr.Team = Rejoining[Plr.UserId].Team
							
							Rejoining[ Plr.UserId ] = nil
							
						end
						
						if not next( Rejoining ) then
							
							Rejoining = nil
							
							RejoiningEvent:Disconnect( )
							
							RejoiningEvent = nil
							
						end
						
					end )
					
				end
				
				delay( 5, function ( )
					
					if RejoiningEvent then
						
						Rejoining[ Plr.UserId ] = nil
						
						if not next( Rejoining ) then
							
							Rejoining = nil
							
							RejoiningEvent:Disconnect( )
							
							RejoiningEvent = nil
							
						end
						
					end
					
				end )
				
			end
			
			TeleportService:TeleportToPlaceInstance( game.PlaceId, game.JobId, Plr )
			
			return true
			
		end
		
	}
	
	Main.Commands.Ping = {
		
		Alias = { "ping", "pingof" },
		
		Description = "Returns the current ping of the specified player or yourself",
		
		Category = "Debug",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Msg = "The ping of the specified players are:"
			
			local Thread = coroutine.running( )
			
			local WaitingFor = 0
			
			for a = 1, #Args[ 1 ] do
				
				WaitingFor = WaitingFor + 1
				
				spawn( function ( )
						
					local Tick = tick( )
					
					Client.Ping:InvokeClient( Args[ 1 ][ a ] )
					
					Tick = tick( ) - Tick
					
					Tick = math.floor( Tick * 100000 + 0.5 ) / 100
					
					coroutine.resume( Thread, "\n" .. Args[ 1 ][ a ].Name .. " - " .. Tick .. "ms" )
					
				end )
				
			end
			
			while WaitingFor ~= 0 do WaitingFor = WaitingFor - 1 Msg = Msg .. coroutine.yield( ) end
			
			Main.Util.SendMessage( Plr, Msg, "Info" )
			
			return true
			
		end
		
	}
	
	Main.Commands.AddTime = {
		
		Alias = { "addtime" },
		
		Description = "Adds the specified time to the current time",
		
		Category = "Lightings",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Time, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Lighting:SetMinutesAfterMidnight( Lighting:GetMinutesAfterMidnight( ) + Args[ 1 ] / 60 )
			
			return true
			
		end
		
	}
	
	Main.Commands.SetTime = {
		
		Alias = { "settime" },
		
		Description = "Sets the current time",
		
		Category = "Lightings",
		
		CanRun = "$moderator, $debugger",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Time, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Lighting:SetMinutesAfterMidnight( Args[ 1 ] / 60 )
			
			return true
			
		end
		
	}
	
	Main.Commands.TeamRespawn = {
		
		Alias = { "teamrespawn", "set" },
		
		Description = "Changes the team of the specified player(s) to the specified team and respawns them",
		
		Category = "Players",
		
		Commands = { Main.Commands.Team, Main.Commands.Respawn },
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Team, Required = true } },
		
	}
			
end