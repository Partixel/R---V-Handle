return function ( Main, ModFolder, VH_Events )
	
	local Players = game:GetService( "Players" )
	
	local Ping = ModFolder:WaitForChild( "Ping" )
	
	Ping.OnClientEvent:Connect( function ( Tick )
		
		Ping:FireServer( Tick )
		
	end )
	
	local Spectate = ModFolder:WaitForChild( "Spectate" )
	
	local SpectateEvent = nil
	
	local CurSpec = ( _G.VH_Saved or { } ).CurSpec or 1
	
	function FreeCam( Pos )
		
		if SpectateEvent and SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		Players.LocalPlayer.Character = nil
		
		workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed
		
		if Pos then
			
			workspace.CurrentCamera.Focus = Pos
			
			workspace.CurrentCamera.CFrame = Pos
			
		end
		
		SpectateEvent = true
		
	end
	
	function EndSpec( )
		
		if SpectateEvent and SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		
		SpectateEvent = nil
		
		Spectate:FireServer( )
		
	end
	
	function Spec( Plr )
		
		Players.LocalPlayer.Character = nil
		
		if SpectateEvent and SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		if not Plr.Character then return end
		
		local Char = Plr.Character
		
		local Hum = Char:FindFirstChildOfClass( "Humanoid" )
		
		if not Hum then return end
		
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		
		workspace.CurrentCamera.CameraSubject = Hum
		
		SpectateEvent = Plr:GetPropertyChangedSignal( "Character" ):Connect( function ( )
			
			repeat wait( ) until Plr.Character ~= Char
			
			Char = Plr.Character
			
			if not Plr.Character then return end
			
			local Hum = Plr.Character:FindFirstChildOfClass( "Humanoid" )
			
			if not Hum then return end
			
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
			
			workspace.CurrentCamera.CameraSubject = Hum
			
		end )
		
	end
	
	function ChangeSpec( Am )
		
		CurSpec = CurSpec + Am
			
		local Plrs = Players:GetPlayers( )
		
		if CurSpec > #Plrs then
			
			CurSpec = 1
			
		elseif CurSpec <= 0 then
			
			CurSpec = #Plrs
			
		end
		
		if Plrs[ CurSpec ] == Players.LocalPlayer then
			
			if #Plrs == 1 then return end
			
			CurSpec = CurSpec + Am
			
			if CurSpec > #Plrs then
				
				CurSpec = 1
				
			elseif CurSpec <= 0 then
				
				CurSpec = #Plrs
				
			end
			
		end
		
	end
	
	VH_Events:WaitForChild( "Destroyed" ).Event:Connect( function ( Update )
		
		if not Update then
			
			if SpectateEvent then
				
				EndSpec( )
				
			end
			
			return
			
		end
		
		_G.VH_Saved.CurSpec = CurSpec
		
	end )
	
	function key( t, p )
		
		for a = 1, #t do
			
			if t[ a ] == p then return a end
			
		end
		
	end
	
	Main.Events[ #Main.Events + 1 ] = Players.LocalPlayer.CharacterAdded:Connect( function ( )
		
		if SpectateEvent == nil then return end
		
		if SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		
		workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character:FindFirstChildOfClass( "Humanoid" )
		
		SpectateEvent = nil
		
	end )
	
	Main.Events[ #Main.Events + 1 ] = game:GetService( "UserInputService" ).InputBegan:Connect( function ( Input, Processed )
		
		if Processed or SpectateEvent == nil then return end
		
		if Input.KeyCode == Enum.KeyCode.Space then
			
			local Plr = Players:GetPlayers( )[ CurSpec ]
			
			if Plr then
				
				if SpectateEvent ~= true then
					
					FreeCam( )
					
				else
					
					Spec( Plr )
					
				end
				
			end
			
		elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
			
			ChangeSpec( -1 )
			
			local Plr = Players:GetPlayers( )[ CurSpec ]
			
			if Plr then
				
				if SpectateEvent ~= true then
					
					Spec( Plr )
					
				else
					
					FreeCam( ( Plr.Character and Plr.Character:FindFirstChild( "Head" ) or { } ).CFrame )
					
				end
				
			end
			
		elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
			
			ChangeSpec( 1 )
			
			local Plr = Players:GetPlayers( )[ CurSpec ]
			
			if Plr then
				
				if SpectateEvent ~= true then
					
					Spec( Plr )
					
				else
					
					FreeCam( ( Plr.Character and Plr.Character:FindFirstChild( "Head" ) or { } ).CFrame )
					
				end
				
			end
			
		end
		
	end )
	
	Spectate.OnClientEvent:Connect( function ( Plr )
		
		if Plr == nil then
			
			FreeCam( ( workspace:FindFirstChild( "SpectatePos", true ) or { } ).CFrame )
			
			CurSpec = 1
			
		elseif Plr == false then
			
			EndSpec( )
			
		elseif Plr.Character and Plr.Character:FindFirstChildOfClass( "Humanoid" ) then
			
			Spec( Plr )
			
			CurSpec = key( Players:GetPlayers( ), Plr )
			
		end
		
	end )
	
	Main.FilteredFuncs[ "Message" ] = function ( Text, PlrName, Time )
		
		local Object = Instance.new( "Message" )
		
		Object.Text = PlrName .. ": " .. Text
		
		Object.Parent = Players.LocalPlayer.PlayerGui
		
		Main.Objs[ #Main.Objs + 1 ] = Object
		
		game:GetService( "Debris" ):AddItem( Object, Time )
		
	end
	
	Main.FilteredFuncs[ "Hint" ] = function ( Text, PlrName, Time )
		
		local Object = Instance.new( "Hint" )
		
		Object.Text = PlrName .. ": " .. Text
		
		Object.Parent = Players.LocalPlayer.PlayerGui
		
		Main.Objs[ #Main.Objs + 1 ] = Object
		
		game:GetService( "Debris" ):AddItem( Object, Time )
		
	end
	
end