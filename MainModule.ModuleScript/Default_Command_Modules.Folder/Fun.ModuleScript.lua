local MarketplaceService, InsertService, Players = game:GetService("MarketplaceService"), game:GetService("InsertService"), game:GetService("Players")

return function(Main, Client, VH_Events)
	Main.Commands.Clone = {
		Alias = {"clone"},
		Description = "Clones the specified players",
		Category = "Characters",
		CanRun = "$moderator",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Players, Default = Main.TargetLib.Defaults.SelfTable}},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			local Successful = {}
			for _, Target in ipairs(Args[1]) do
				if Target.Character and Target.Character:FindFirstChild("Humanoid") then
					local Orig = Target.Character.Archivable
					Target.Character.Archivable = true
					local Clone = Target.Character:Clone()
					Clone.Humanoid.Died:Connect(function()
						wait(4)
						if Clone.Parent then
							Clone:Destroy()
						end
					end)
					Main.Objs[#Main.Objs + 1] = Clone
					Clone.Parent = workspace
					
					Target.Character.Archivable = Orig
					
					Successful[#Successful + 1] = Target
				end
			end
			
			return Main.Util.HandlePlayerTargetResult(Executor, Silent, Args[1], Successful, {})
		end
	}
	
	Main.Commands.BuildTools = {
		Alias = {"buildtools", "btools"},
		Description = "Gives the specified players building tools",
		Category = "Tools",
		CanRun = "$admin",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Players, Default = Main.TargetLib.Defaults.SelfTable}},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			local Successful = {}
			for _, Target in ipairs(Args[1]) do
				if Target:FindFirstChild("Backpack") then
					local H = Instance.new("HopperBin")
					H.BinType = Enum.BinType.Grab
					H.Parent = Target:WaitForChild("Backpack")
					H = Instance.new("HopperBin")
					H.BinType = Enum.BinType.Clone
					H.Parent = Target.Backpack
					H = Instance.new("HopperBin")
					H.BinType = Enum.BinType.Hammer
					H.Parent = Target.Backpack
					Successful[#Successful + 1] = Target
				end
			end
			return Main.Util.HandlePlayerTargetResult(Executor, Silent, Args[1], Successful, {})
		end
	}
	
	Main.Commands.PlaySound = {
		Alias = {"playsound", "music"},
		Description = "Plays the specified sound for the specified player(s) on a loop if the second argument is true",
		Category = "Sounds",
		CanRun = "$moderator",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Sound, Required = true}, {Func = Main.TargetLib.ArgTypes.Boolean, Default = false}, Main.TargetLib.ArgTypes.Players},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			if Args[3] then
				local Successful = {}
				for _, Target in ipairs(Args[3]) do
					if Target:FindFirstChild("PlayerGui") then
						local Sound = Instance.new("Sound")
						Sound.SoundId = "rbxassetid://" .. Args[1].AssetId
						Main.Objs[#Main.Objs + 1] = Sound
						Sound.Looped = Args[2]
						if not Args[2] then
							Sound.Ended:Connect(function() Sound:Destroy() end)
						end
						Sound.Parent = Target.PlayerGui
						Sound:Play()
						Successful[#Successful + 1] = Target
					end
				end
				
				return Main.Util.HandlePlayerTargetResult(Executor, Silent, Args[3], Successful, {["SoundId"] = Args[1].Name, ["Loop"] = Args[2]})
			else
				local Sound = Instance.new("Sound")
				Sound.SoundId = "rbxassetid://" .. Args[1].AssetId
				Main.Objs[#Main.Objs + 1] = Sound
				Sound.Looped = Args[2]
				if not Args[2] then
					Sound.Ended:Connect(function() Sound:Destroy() end)
				end
				Sound.Parent = workspace
				Sound:Play()
				
				return {Success = true, Message = {"Success", {["SoundId"] = Args[1].Name, ["Targets"] = Main.Util.FormatPlayerList(Executor, Players:GetPlayers()), ["Loop"] = Args[2]}}}
			end
		end
	}
	
	Main.Commands.StopSounds = {
		Alias = {"stopsounds", "stopmusic"},
		Description = "Stops all sounds played by the admin",
		Category = "Sounds",
		CanRun = "$moderator",
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			local Stopped = 0
			for a, b in pairs(Main.Objs) do
				if b:IsA("Sound") then
					Stopped = Stopped + 1
					b:Stop()
					b:Destroy()
					Main.Objs[a] = nil
				end
			end
			if Stopped == 0 then
				return {Success = false, HaltStack = true, Warning = {"Failed"}}
			else
				return {Success = true, Message = {"Success", {["NumberPlaying"] = Stopped}}}
			end
		end
	}
	
	Main.Commands.Gravity = {
		Alias = {"gravity", "grav"},
		Description = "Sets the workspace gravity, leave the parameter empty for the default (196.2)",
		Category = "Physics",
		CanRun = "$moderator",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Number, Default = 196.2}},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			workspace.Gravity = Args[1]
			return {Success = true, Message = {"Success", {["Gravity"] = Args[1]}}}
		end
	}
	
	Main.Commands.RemoveCharacter = {
		Alias = {"removecharacter", "rc"},
		Description = "Removes the specified player(s) character",
		Category = "Character",
		CanRun = "$moderator",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Players, Required = true}},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			local Successful = {}
			for _, Target in ipairs(Args[1]) do
				if Target.Character then
					Target.Character:Destroy()
					Target.Character = nil
					Successful[#Successful + 1] = Target
				end
			end
			
			return Main.Util.HandlePlayerTargetResult(Executor, Silent, Args[1], Successful, {})
		end
	}
	
	Main.Commands.Explode = {
		Alias = {"explode","boom","blow"},
		Description = "Blows a player up",
		Category = "Character",
		CanRun = "$moderator",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable}, {Func = Main.TargetLib.ArgTypes.Number, Default = 500000}, {Func = Main.TargetLib.ArgTypes.Number, Default = 4}},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			local Successful = {}
			for _, Target in ipairs(Args[1]) do
				if Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
					local Explosion = Instance.new("Explosion")
					Explosion.Position = Target.Character.HumanoidRootPart.Position
					Explosion.BlastPressure = Args[2]
					Explosion.BlastRadius = Args[3]
					Explosion.Parent = Target.Character.HumanoidRootPart
					Successful[#Successful + 1] = Target
				end
			end
			
			return Main.Util.HandlePlayerTargetResult(Executor, Silent, Args[1], Successful, {["BlastPressure"] = Args[2], ["BlastRadius"] = Args[3]})
		end
	}
	
	Main.Commands.GiveGear = {
		Alias = {"givegear","gear"},
		Description = "Blows a player up",
		Category = "Character",
		CanRun = "$moderator",
		ArgTypes = {{Func = Main.TargetLib.ArgTypes.Players, Required = true, Default = Main.TargetLib.Defaults.SelfTable}, {Func = Main.TargetLib.ArgTypes.Gear, Required = true}},
		Callback = function(self, Executor, Cmd, Args, NextCmds, Silent)
			local Gear = InsertService:LoadAsset(Args[2].AssetId):GetChildren()[1]
			local Successful = {}
			for _, Target in ipairs(Args[1]) do
				if Target:FindFirstChild("Backpack") then
					Gear:Clone().Parent = Target.Backpack
					Successful[#Successful + 1] = Target
				end
			end
			
			return Main.Util.HandlePlayerTargetResult(Executor, Silent, Args[1], Successful, {["GearName"] = Args[2].Name})
		end
	}
end
