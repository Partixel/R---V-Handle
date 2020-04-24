return function ( Main, ModFolder, VH_Events )
	
	local Binds, RunCommand = ( _G.VH_Saved or { } ).Binds or { }, VH_Events:WaitForChild( "RunCommand" )
	
	VH_Events:WaitForChild( "Destroyed" ).Event:Connect( function ( Update )
		
		if not Update then return end	
		
		_G.VH_Saved.Binds = Binds
		
	end )
	
	Main.Events[ #Main.Events + 1 ] = game:GetService( "UserInputService" ).InputBegan:Connect( function ( Input, Processed )
		
		if Processed then return end
		
		if Binds[ Input.KeyCode ] then
			
			RunCommand:InvokeServer( Binds[ Input.KeyCode ] )
			
		end
		
	end )
	
	ModFolder:WaitForChild( "Cleanup" ).OnClientEvent:Connect( function ( )
		
		for a, b in pairs( Main.Objs ) do
			
			b:Destroy( )
			
		end
		
	end )
	
	ModFolder:WaitForChild( "Bind" ).OnClientEvent:Connect( function ( Key, Cmds )
		
		if Key == true then Binds = { } return end
		
		Binds[ Key ] = Cmds
		
	end )
	
	ModFolder:WaitForChild( "TestClientError" ).OnClientEvent:Connect( function ( Msg )
		
		if Msg then
			
			error( Msg )
			
		else
			
			print( ( nil )( ) )
			
		end
		
	end )
	
	ModFolder:WaitForChild( "TestResults" ).OnClientEvent:Connect( function ( Results )
		
		local SortMode = 1 -- 0 = Name 1 = Time
		
		local Pass, Fail, Errored = Results[ 1 ], Results[ 2 ], Results[ 3 ]
		
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
			
			for _, Result in ipairs(Pass) do
				
				print( Result[ 1 ] .. ( Result[ 3 ] and ( " - " .. Result[ 3 ] ) or "" ) .. " - " .. ( Result[ 2 ] * 1000 ) .. "ms" )
				
			end
			
		end
		
		if #Fail ~= 0 then 
			
			print( "Fails:" )
			
			for _, Result in ipairs(Fail) do
				
				print( Result[ 1 ] .. ( Result[ 3 ] and ( " - " .. Result[ 3 ] ) or "" ) .. " - " .. ( Result[ 2 ] * 1000 ) .. "ms"  )
				
			end
			
		end
		
		if #Errored ~= 0 then 
			
			print( "Errors:" )
			
			for _, Result in ipairs(Errored) do
				
				print( Result[ 1 ] .. ( Result[ 3 ] and ( " - " .. Result[ 3 ] ) or "" ) .. " - " .. ( Result[ 2 ] * 1000 ) .. "ms"  )
				
			end
			
		end
		
	end )
	
end