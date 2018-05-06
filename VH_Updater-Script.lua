local InsertService = game:GetService( "InsertService" )
print"test"
wait( 5 )

repeat
	
	local OldSetup = game:GetService( "ServerScriptService" ):FindFirstChild( "V-Handle" )
	
	if OldSetup and OldSetup:FindFirstChild( "Setup" ) then
		
		local NewSetup
		
		local Ran, Items = pcall( game.GetObjects, game, "https://www.roblox.com/asset/?id=543870970&r=2" )
		
		if not Ran then return end
		
		for a, b in pairs( Items ) do NewSetup = b break end
		
		if NewSetup and NewSetup:FindFirstChild( "Setup" ) then
			
			local CurVer, NewVer = ( OldSetup.Setup.Source:match( '_G.VHSetupVersion = "(%d.%d.%d)"' ) or "0" ):gsub( "%.", "" ), NewSetup.Setup.Source:match( '_G.VHSetupVersion = "(%d.%d.%d)"' ):gsub( "%.", "" )
			
			if CurVer < NewVer then
				
				local VH
				
				Ran, Items = pcall( game.GetObjects, game, "https://www.roblox.com/asset/?id=543870197&r=2" )
				
				if not Ran then return end
				
				VH = Items[ 1 ]
				
				if VH then
					
					if VH:FindFirstChild( "Util", true ) then
						
						Util = require( VH:FindFirstChild( "Util", true ) )( )
						
						local NewConf = Util.CreateConfigString( require( OldSetup:FindFirstChild( "VH_Config" ) or OldSetup:FindFirstChild( "VHConfig" ) ) )
						
						OldSetup:Destroy( )
						
						NewSetup.VH_Config.Source = NewConf
						
						NewSetup.Parent = game:GetService( "ServerScriptService" )
						
					else
						
						VH:Destroy( )
						
					end
					
				end
				
			else
				
				NewSetup:Destroy( )
				
			end
			
		elseif NewSetup then
			
			NewSetup:Destroy( )
			
		end
		
	end
	
until not wait( 60 )