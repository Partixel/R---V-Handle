local StarterGui = game:GetService( "StarterGui" )

return function(Main, ModFolder, VH_Events)
	ModFolder:WaitForChild("SystemMessage").OnClientEvent:Connect(function(Options)
		wait()
		
		for _, Line in ipairs(string.split(Options.Text, "\n")) do
			Options.Text = Line
			StarterGui:SetCore("ChatMakeSystemMessage", Options)
		end
	end)
	
	ModFolder:WaitForChild( "Print" ).OnClientEvent:Connect(function(Msg, Warn)
		for _, Text in ipairs(string.split(Msg, "\n")) do
			if Warn then
				warn( Text )
			else
				print( Text )
			end
		end
	end)
end