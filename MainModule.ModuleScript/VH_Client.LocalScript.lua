if script.Parent.Name ~= "PlayerScripts" then
	
	script:Clone( ).Parent = game.Players.LocalPlayer.PlayerScripts
	
	wait( )
	
	script:Destroy( )
	
	return
	
end

local Kids = script.Parent:GetChildren( )

for a = 1, #Kids do
	
	if Kids[ a ] ~= script and Kids[ a ].Name == script.Name then
		
		wait( )
		
		script:Destroy( )
		
		return
		
	end
	
end

local ReplicatedStorage = game:GetService("ReplicatedStorage" )

local Main = { }

Main.Objs = { }

Main.Events = { }

local VH_Command_Clients, VH_Events = ReplicatedStorage:WaitForChild( "VH_Command_Clients" ), ReplicatedStorage:WaitForChild( "VH_Events" )

local Destroy, Disconnect = workspace.Destroy, workspace.Changed:Connect( function ( ) end )

Disconnect = Disconnect.Disconnect, Disconnect:Disconnect( )

local function EmptyTable( Table )
	
	for a, b in pairs( Table ) do
		
		pcall( Disconnect, b )
		
		pcall( Destroy, b )
		
		if type( b ) == "table" then EmptyTable( b ) end
		
		Table[ a ] = nil
		
	end
	
end

local RunService, Plr = game:GetService( "RunService" ), game:GetService( "Players" ).LocalPlayer

local Server = RunService:IsServer( )

VH_Events:WaitForChild( "RemoteDestroyed" ).OnClientEvent:Connect( function ( Update )
	
	_G.VH_Client = nil
	
	if not Server then
		
		if Update then
			
			_G.VH_Saved = { }
			
		end
		
		VH_Events.Destroyed:Fire( Update )
		
	end
	
	EmptyTable( Main )
	
	Main = nil
	
	script:Destroy( )
	
	getfenv( ).script = nil
	
end )

Main.FilteredFuncs = { }

VH_Events:WaitForChild( "FilteredReplication" ).OnClientEvent:Connect( function ( FuncName, Text, ... )
	
	if Main.FilteredFuncs[ FuncName ] then
		
		Main.FilteredFuncs[ FuncName ]( Text, ... )
		
	else
		
		error( "V-Handle: " .. FuncName .. " doesn't exist for FilterTo" )
		
	end
	
end )

_G.VH_Client = Main

local function RequireModule( Mod )
	
	local Ran, Error = pcall( function ( ) require( Mod )( Main, ReplicatedStorage:FindFirstChild( Mod.Name:sub( 1, -8 ) ), VH_Events ) end )
	
	if not Ran then
		
		warn( Mod.Name .. " errored when required:\n" .. Error )
		
	end
	
end

local Clients = VH_Command_Clients:GetChildren( )

for a = 1, #Clients do
	
	RequireModule( Clients[ a ] )
	
end

VH_Command_Clients.ChildAdded:Connect( RequireModule )