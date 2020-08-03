local TimeSync = require(game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("TimeSync"))

local VFolder = game:GetService("ReplicatedStorage" ):WaitForChild( "V-Handle" )

local Main = { }

Main.ExtendedTranslations = require(VFolder:WaitForChild("ExtendedTranslations"))

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

local RunService, LocalPlayer = game:GetService( "RunService" ), game:GetService( "Players" ).LocalPlayer

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
Main.TranslatedFuncs = { }

Main.FilteredFuncs = { }

Main.PersistentFilteredFuncs = { }

_G.VH_Client = Main

local function RequireModule(Mod)
	local Ran, Error = true, nil
	if Mod:IsA("ModuleScript") then
		Ran, Error = pcall(function() require(Mod)(Main, Mod, VH_Events) end)
	end
	if Ran then
		if Mod:FindFirstChild("Translations") then
			print("Translations", Mod)
			local Ran, Translations = pcall(function() return require(Mod.Translations) end)
			if Ran then
				local Ran, Error = pcall(Translations.RobloxLocalizationTable and Main.ExtendedTranslations.ImportRobloxLocalizationTable or Main.ExtendedTranslations.ImportLocalizationTable, Translations)
				if not Ran then
					warn(Mod.Name .. " failed to load due to an error in its translation table:\n" .. Error)
				end
			else
				warn(Mod.Name .. " failed to load due to an error in its translation table:\n" .. Translations)
			end
		end
	else
		warn(Mod.Name .. " errored when required:\n" .. Error)
	end
end

VH_Command_Clients.ChildAdded:Connect( RequireModule )

for _, Mod in ipairs( VH_Command_Clients:GetChildren( ) ) do
	
	RequireModule( Mod )
	
end

local StarterGui = game:GetService("StarterGui")
Main.TranslatedFuncs.CommandMessage = function(Message)
	local Options = {Text = "V-Handle - " .. Message, Color = BrickColor.new("Fog").Color}
	for _, Line in ipairs(string.split(Options.Text, "\n")) do
		Options.Text = Line
		StarterGui:SetCore("ChatMakeSystemMessage", Options)
	end
end
Main.TranslatedFuncs.CommandWarning = function(Message)
	local Options = {Text = "V - Handle - Warning - " .. Message, Color = Color3.fromRGB(255, 194, 61), Font = Enum.Font.Code}
	for _, Line in ipairs(string.split(Options.Text, "\n")) do
		Options.Text = Line
		StarterGui:SetCore("ChatMakeSystemMessage", Options)
	end
end

VH_Events:WaitForChild("TranslatedReplication").OnClientEvent:Connect(function(FuncName, Key, TranslateArgs, ...)
	if Main.TranslatedFuncs[FuncName] then
		local Text = Main.ExtendedTranslations.TranslateFallback(LocalPlayer.LocaleId, Key, TranslateArgs)
		Main.TranslatedFuncs[ FuncName ](Text:sub(1, 1):upper() .. Text:sub(2), ...)
	else
		error("V-Handle: " .. FuncName .. " doesn't exist for TranslatedReplication")
	end
end)

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