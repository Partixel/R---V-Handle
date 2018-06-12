local Hint = Instance.new( "Hint", workspace )

Hint.Text = "Admin failed to load, reverting to emergency functions - Say update/ to attempt a fix"

local Players, InsertService = game:GetService( "Players" ), game:GetService( "InsertService" )

local Events = { }

function GetLatestId( AssetId )
	
	local Ran, Id = pcall( InsertService.GetLatestAssetVersionAsync, InsertService, AssetId )
	
	if Ran then return Id end
	
	Ran, Id = pcall( game.HttpService.GetAsync, game.HttpService, "https://rbxapi.v-handle.com/?type=1&id=" .. AssetId )
	
	if Ran then return tonumber( Id ) end
	
	return Id
	
end

function GetLatest( )
	
	local Ids = { 543870197, 571587156 }
	
	local Error
	
	for a = 1, #Ids do
		
		local Id = GetLatestId( Ids[ a ] )
		
		if type( Id ) == "number" then
			
			local Ran, Mod = pcall( InsertService.LoadAssetVersion, InsertService, Id )
			
			if Ran and Mod then
			
				local ModChild = Mod:GetChildren( )[ 1 ]
				
				ModChild.Parent = nil
				
				Mod:Destroy( )
				
				return ModChild
				
			else
				
				Error = "Couldn't insert latest version of " .. Ids[ a ] .. "\n" .. Mod
				
			end
			
		else
			
			Error = "Couldn't get latest version of " .. Ids[ a ] .. "\n" .. Id
			
		end
		
	end
	
	return Error
	
end

local Updated = false

spawn( function ( )
	
	while not Updated and wait( 30 ) do
		
		local NewMain = GetLatest( )
		
		if not NewMain or type( NewMain ) == "string" then return end
		
		if pcall( function ( ) require( NewMain ) end ) then
			
			Updated = true
			
			for a = 1, #Events do
				
				Events[ a ]:Disconnect( )
				
			end
			
			Hint:Destroy( )
			
			break
			
		end
		
	end
	
end )

function Chatted( Msg, Plr )
	
	if Msg == "shutdown/" then
		
		Players.PlayerAdded:Connect( function ( Plr ) Plr:Kick( "Shutdown" ) end )
		
		local Plrs = Players:GetPlayers( )
		
		for a = 1, #Plrs do
			
			Plrs[ a ]:Kick( "Shutdown" )
			
		end
		
	elseif Msg == "update/" then
		
		local NewMain = GetLatest( )
		
		if not NewMain or type( NewMain ) == "string" then return end
		
		if pcall( function ( ) require( NewMain ) end ) then
			
			Updated = true
			
			for a = 1, #Events do
				
				Events[ a ]:Disconnect( )
				
			end
			
			Hint:Destroy( )
			
		end
		
	end
	
end

Events[ #Events + 1 ] = Players.PlayerAdded:Connect( function ( Plr ) Events[ #Events + 1 ] = Plr.Chatted:Connect( function ( Msg ) Chatted( Msg, Plr ) end ) end )

local Plrs = Players:GetPlayers( )

for a = 1, #Plrs do
	
	Events[ #Events + 1 ] = Plrs[ a ].Chatted:Connect( function ( Msg ) Chatted( Msg, Plrs[ a ] ) end )
	
end

return nil