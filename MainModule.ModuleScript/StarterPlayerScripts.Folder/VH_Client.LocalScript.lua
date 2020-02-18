local TimeSync = require(game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("TimeSync"))

local VFolder = game:GetService("ReplicatedStorage" ):WaitForChild( "V-Handle" )

local Main = { }

Main.Objs = { }

Main.Events = { }

local VH_Command_Clients, VH_Events = VFolder:WaitForChild( "VH_Command_Clients" ), VFolder:WaitForChild( "VH_Events" )

local Destroy, Disconnect = workspace.Destroy, workspace.Changed:Connect( function ( ) end )

Disconnect, _ = Disconnect.Disconnect, Disconnect:Disconnect( )

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
	
end )

Main.FilteredFuncs = { }

Main.PersistentFilteredFuncs = { }

_G.VH_Client = Main

local function RequireModule( Mod )
	
	local Ran, Error = pcall( function ( ) require( Mod )( Main, Mod, VH_Events ) end )
	
	if not Ran then
		
		warn( Mod.Name .. " errored when required:\n" .. Error )
		
	end
	
end

VH_Command_Clients.ChildAdded:Connect( RequireModule )

for _, Mod in ipairs( VH_Command_Clients:GetChildren( ) ) do
	
	RequireModule( Mod )
	
end

VH_Events:WaitForChild( "FilteredReplication" ).OnClientEvent:Connect( function ( FuncName, Text, ... )
	
	if Main.FilteredFuncs[ FuncName ] then
		
		Main.FilteredFuncs[ FuncName ]( Text, ... )
		
	else
		
		error( "V-Handle: " .. FuncName .. " doesn't exist for FilterTo" )
		
	end
	
end )


VH_Events:WaitForChild( "PersistentFilteredReplication" ).OnClientEvent:Connect( function ( FuncName, Key_Time, Text, ... )
	
	if Main.PersistentFilteredFuncs[ FuncName ] then
		
		if type(Key_Time) == "number" then
			
			if Key_Time - TimeSync.GetServerTime() > 0 then
				
				Main.PersistentFilteredFuncs[ FuncName ]( Key_Time - TimeSync.GetServerTime(), Text, ... )
				
			else
				
				warn("V-Handle:" .. FuncName .. " was sent a message that expired - " .. Text)
				
			end
						
		else
			
			Main.PersistentFilteredFuncs[ FuncName ]( Key_Time, Text, ... )
			
		end
		
	else
		
		error( "V-Handle: " .. FuncName .. " doesn't exist for FilterTo" )
		
	end
	
end )