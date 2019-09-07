return function ( Main, Client, VH_Events )
	
	Main.Commands.Clone = {
		
		Alias = { "clone" },
		
		Description = "Clones the specified players",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Default = Main.TargetLib.Defaults.SelfTable } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					local Orig = Plrs[ a ].Character.Archivable
					
					Plrs[ a ].Character.Archivable = true
					
					local Clone = Plrs[ a ].Character:Clone( )
					
					Plrs[ a ].Character.Archivable = Orig
					
					Main.Objs[ #Main.Objs + 1 ] = Clone
					
					Clone.Humanoid.Died:Connect( function ( )
						
						wait( 4 )
						
						if Clone.Parent then
							
							Clone:Destroy( )
							
						end
						
					end )
					
					Clone.Parent = workspace
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.JumpPower = {
		
		Alias = { "jumppower", "jp" },
		
		Description = "Changes the jumppower of the specified players",
		
		Category = "Characters",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true }, { Func = Main.TargetLib.ArgTypes.Number, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local Plrs = Args[ 1 ]
			
			for a = 1, #Plrs do
				
				if Plrs[ a ].Character and Plrs[ a ].Character:FindFirstChild( "Humanoid" ) then
					
					Plrs[ a ].Character.Humanoid.JumpPower = Args[ 2 ]
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.BuildTools = {
		
		Alias = { "buildtools", "btools" },
		
		Description = "Gives the specified player building tools",
		
		Category = "Tools",
		
		CanRun = "$admin",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Player, Required = true } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			local H = Instance.new( "HopperBin" )
			
			H.BinType = Enum.BinType.Grab
			
			H.Parent = Args[ 1 ]:WaitForChild( "Backpack" )
			
			H = Instance.new( "HopperBin" )
			
			H.BinType = Enum.BinType.Clone
			
			H.Parent = Args[ 1 ]:WaitForChild( "Backpack" )
			
			H = Instance.new( "HopperBin" )
			
			H.BinType = Enum.BinType.Hammer
			
			H.Parent = Args[ 1 ]:WaitForChild( "Backpack" )
			
			return true
			
		end
		
	}
	
	Main.Commands.PlaySound = {
		
		Alias = { "playsound", "music" },
		
		Description = "Plays the specified sound for the specified player(s) on a loop if the second argument is true",
		
		Category = "Sounds",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.SoundId, Required = true }, Main.TargetLib.ArgTypes.Boolean, Main.TargetLib.ArgTypes.Players },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			Args[ 2 ] = Args[ 2 ] or false
			
			if Args[ 3 ] then
				
				for a = 1, #Args[ 3 ] do
					
					if Args[ 3 ][ a ]:FindFirstChild( "PlayerGui" ) then
						
						local Sound = Instance.new( "Sound" )
						
						Sound.SoundId = "rbxassetid://" .. Args[ 1 ]
						
						Main.Objs[ #Main.Objs + 1 ] = Sound
						
						Sound.Looped = Args[ 2 ]
						
						if not Args[ 2 ] then
							
							Sound.Ended:Connect( function ( ) Sound:Destroy( ) end )
							
						end
						
						Sound.Parent = Args[ 3 ][ a ].PlayerGui
						
						Sound:Play( )
						
					end
					
				end
				
			else
				
				local Sound = Instance.new( "Sound" )
				
				Sound.SoundId = "rbxassetid://" .. Args[ 1 ]
				
				Main.Objs[ #Main.Objs + 1 ] = Sound
				
				Sound.Looped = Args[ 2 ]
				
				if not Args[ 2 ] then
					
					Sound.Ended:Connect( function ( ) Sound:Destroy( ) end )
					
				end
				
				Sound.Parent = workspace
				
				Sound:Play( )
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.StopSounds = {
		
		Alias = { "stopsounds", "stopmusic" },
		
		Description = "Stops all sounds played by the admin",
		
		Category = "Sounds",
		
		CanRun = "$moderator",
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a, b in pairs( Main.Objs ) do
				
				if b:IsA( "Sound" ) then
					
					b:Stop( )
					
					b:Destroy( )
					
				end
				
			end
			
			return true
			
		end
		
	}
	
	Main.Commands.Gravity = {
		
		Alias = { "gravity", "grav" },
		
		Description = "Sets the workspace gravity, leave the parameter empty for the default (196.2)",
		
		Category = "Physics",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Number, Default = 196.2 } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			workspace.Gravity = Args[ 1 ]
			
			return true
			
		end
		
	}
	
	Main.Commands.Explode = {
		
		Alias = { "explode","boom","blow" },
		
		Description = "Blows a player up",
		
		Category = "Character",
		
		CanRun = "$moderator",
		
		ArgTypes = { { Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable }, { Func = Main.TargetLib.ArgTypes.Number, Default = 500000 }, { Func = Main.TargetLib.ArgTypes.Number, Default = 4 } },
		
		Callback = function ( self, Plr, Cmd, Args, NextCmds, Silent )
			
			for a = 1, #Args[ 1 ] do
				
				if Args[ 1 ][ a ].Character and Args[ 1 ][ a ].Character:FindFirstChild( "HumanoidRootPart" ) then
					
					local Explosion = Instance.new( "Explosion" )
					
					Explosion.Position = Args[ 1 ][ a ].Character.HumanoidRootPart.Position
					
					Explosion.BlastPressure = Args[ 2 ]
					
					Explosion.BlastRadius = Args[ 3 ]
					
					Explosion.Parent = Args[ 1 ][ a ].Character.HumanoidRootPart
					
				end
				
			end
			
			return true
			
		end
		
	}
	
end
