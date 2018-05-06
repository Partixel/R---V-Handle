return function ( Main, ModFolder, VH_Events )
	
	local StarterGui = game:GetService( "StarterGui" )
	
	function Split( String, Pattern )
		
		local Result = { }
		
		local From = 1
		
		local delim_from, delim_to = String:find( Pattern, From  )
		
		while delim_from do
			
			table.insert( Result, String:sub( From , delim_from - 1 ) )
			
			From  = delim_to + 1
			
			delim_from, delim_to = String:find( Pattern, From  )
			
		end
		
		table.insert( Result, String:sub( From  ) )
		
		return Result
		
	end
	
	ModFolder:WaitForChild( "SystemMessage" ).OnClientEvent:Connect( function ( Options )
		
		local Text = Options.Text
		
		Text = Split( Text, "%\n" )
		
		wait( )
		
		for a = 1, #Text do
			
			Options.Text = Text[ a ]
			
			StarterGui:SetCore( "ChatMakeSystemMessage", Options )
			
		end
		
	end )
	
	ModFolder:WaitForChild( "Print" ).OnClientEvent:Connect( function ( Msg, Warn )
		
		Msg = Split( Msg, "%\n" )
		
		for a = 1, #Msg do
			
			if Warn then warn( Msg[ a ] ) else print( Msg[ a ] ) end
			
		end
		
	end )
	
end