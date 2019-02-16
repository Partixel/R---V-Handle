return function ( Main, ModFolder, VH_Events )
	
	local StarterGui = game:GetService( "StarterGui" )
	
	ModFolder:WaitForChild( "SystemMessage" ).OnClientEvent:Connect( function ( Options )
		
		local Text = Options.Text
		
		Text = string.split( Text, "\n" )
		
		wait( )
		
		for a = 1, #Text do
			
			Options.Text = Text[ a ]
			
			StarterGui:SetCore( "ChatMakeSystemMessage", Options )
			
		end
		
	end )
	
	ModFolder:WaitForChild( "Print" ).OnClientEvent:Connect( function ( Msg, Warn )
		
		Msg = string.split( Msg, "\n" )
		
		for a = 1, #Msg do
			
			if Warn then warn( Msg[ a ] ) else print( Msg[ a ] ) end
			
		end
		
	end )
	
end