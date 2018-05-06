return function ( Main, ModFolder, VH_Events )
	
	local Module = { }
	
	local Players, Debris = game:GetService( "Players" ), game:GetService( "Debris" )
	
	Module.ConfigDefaults = {
		
		{ "AnnounceJoin", true,
			
	[[-- If true the admin will print when a player joins to the chat]] },
		
		{ "AnnounceLeft", true,
			
	[[-- If true the admin will print when a player leaves to the chat]] },
		
		{ "UpdatePeriod", 60,
			
	[[-- How often the admin checks for updates in seconds ( Must be at least 30 and at most 1800 )]], function ( Obj ) return math.max( math.min( Obj, 1800 ), 30 ) end },
		
		{ "CommandOptions", { },
			
	[[-- Override properties of commands like CanRun or Category
-- --Examples--
-- Config.CommandOptions = { Kill = { CanRun = "all" } } - Allows everyone to use the Kill command]] },
		
		{ "UserPowers", { },
			
	[[-- Preceed users with "-" to override any other ranks they are given with the specified ran ( More minuses means higher priority )
-- e.g. [ "-partixel" ] = "user" - will force Partixel to have the rank "user" even if other UserPowers match him
-- --Examples--
-- Config.UserPowers = { ["1234"] = "admin" } - This gives admin to the player with a userid equal to "1234"
-- Config.UserPowers = { ["^4321^50"] = "admin" } - This gives admin to anyone in the group "4321" and have a rank above "50"
-- Config.UserPowers = { ["^4321&!^1234^12"] = "admin" } - This gives admin to anyone in the group "4321" and don't have a rank of 12 or above in the group "1234"]] },
		
		{ "Banned", { },
			
	[[-- Players matching a string on this list is prevented from joining the game with the reason being the value or a default message if true
-- --Examples--
-- Config.Banned = { ["partixel"] = true }
-- Config.Banned = { ["1234"] = "Hacking", ["^1059575"] = "Bad group" }]] },
		
		{ "DisabledCommandModules", { [ "VH_Main" ] = false, [ "VH_Fun" ] = false },
			
	[[-- If true the specified command module will not load
-- Use this if you don't want commands from said command module ( e.g. if you don't want 'Fun' commands do [ "VH_Fun" ] = true]] }
		
	}
	
	function Module.CreateConfigString( Config )
		
		Config = Config or Main.Config
		
		local Cfg = "local Config = { }"
		
		for a = 1, #Module.ConfigDefaults do
			
			local Val = Config[ Module.ConfigDefaults[ a ][ 1 ] ] or Module.ConfigDefaults[ a ][ 2 ]
			
			if Module.ConfigDefaults[ a ][ 4 ] then
				
				Val = Module.ConfigDefaults[ a ][ 4 ]( Val )
				
			end
			
			Val = Module.ToString( Val, "Config." .. Module.ConfigDefaults[ a ][ 1 ] )
			
			Cfg = Cfg .. "\n\n" .. Module.ConfigDefaults[ a ][ 3 ] .. "\n" .. Val
			
		end
		
		Cfg = Cfg .. "\n\nreturn Config"
		
		return Cfg
		
	end
	
	function Module.ToString( Obj, Name, Options, Tabs, Cyclic, Key, CyclicObjs, WaitedFor, NumKey )
		
		local First = Cyclic == nil
		
		Options = Options or { }
		
		Options.Space = Options.Space or " "
		
		Options.Tab = Options.Tab or "	"
		
		Options.NewLine = Options.NewLine or "\n"
		
		Options.SecondaryNewLine = Options.SecondaryNewLine or "\n"
		
		Options.MaxDepth = Options.MaxDepth or math.huge
		
		Tabs = Tabs or 0
		
		local newKey = { }
		
		Key = Key or { }
		
		for a = 1, #Key do newKey[ a ] = Key[ a ] end
		
		Key = newKey
		
		if Name then
			
			local Match = First and "^[_%a][%w_%.]*" or "^[_%a][%w_]*"
			
			if type( Name ) == "string" and Name:gsub( Match, "" ) == "" then
				
				Key[ #Key + 1 ] = Name
				
			else
				
				Name = "[" .. Options.Space .. Module.ToString( Name, nil, Options, 0, Cyclic, Key, CyclicObjs, WaitedFor ) .. Options.Space .. "]"
				
				Key[ #Key + 1 ] = Name
				
				if First then Name = "getfenv(" .. Options.Space .. ")" .. Name end
				
			end
			
			Name = Options.Tab:rep( Tabs ) .. Name .. Options.Space .. "=" .. Options.Space
					
		else
			
			if NumKey then
				
				Key[ #Key + 1 ] = "[" .. Options.Space .. NumKey .. Options.Space .. "]"
				
			end
			
			Name = Options.Tab:rep( Tabs )
			
		end
		
		if Cyclic and type( Obj ) == "table" and Obj ~= { } and Cyclic[ Obj ] then
			
			local Str = Key[ 1 ]
			
			for a = 2, #Key do
				
				Str = Str .. ( Key[ a ]:sub( 1, 1 ) == "[" and "" or "." ) .. Key[ a ]
				
			end
			
			CyclicObjs[ Str ] = Cyclic[ Obj ]
			
			return nil, true
			
		end
		
		if Options.Process then
			
			local Str = Options.Process( Obj, Name, Options, Tabs, Cyclic, Key, CyclicObjs, WaitedFor, NumKey )
			
			if Str then return Str end
			
		end
		
		local Type = typeof( Obj )
		
		if Type == "table" then
			
			if #Key > Options.MaxDepth then
				
				return Options.MaxDepthReplacement or Name .. "{" .. Options.Space .. "..." .. Options.Space .. "}"
				
			end
			
			Cyclic = Cyclic or { }
			
			WaitedFor = WaitedFor or { }
			
			CyclicObjs = CyclicObjs or { }
			
			local Str = Key[ 1 ]
			
			for a = 2, #Key do
				
				Str = Str .. ( Key[ a ]:sub( 1, 1 ) == "[" and "" or "." ) .. Key[ a ]
				
			end
			
			Cyclic[ Obj ] = Str
			
			Str = "{" .. Options.Space
			
			local Num = 0
			
			for a, b in pairs( Obj ) do
				
				Num = Num + 1
				
				local Val, Cyc = Module.ToString( b, Num ~= a and a or nil, Options, Tabs + 1, Cyclic, Key, CyclicObjs, WaitedFor, Num == a and a or nil )
				
				if not Cyc then
					
					Str = Str .. Options.SecondaryNewLine .. Options.Tab:rep( Tabs + 1 ) .. Options.SecondaryNewLine .. Val .. ( next( Obj, a ) ~= nil and ( "," .. Options.Space ) or "" )
					
				end
				
			end
			
			if Num == 0 then
				
				Str = "{" .. Options.Space .. "}"
				
			else
				
				Str = Str .. Options.SecondaryNewLine .. Options.Tab:rep( Tabs + 1 ) .. Options.SecondaryNewLine .. Options.Tab:rep( Tabs ) .. ( Options.Tab == "" and Options.Space or "" ) .. "}"
				
			end
			
			if getmetatable( Obj ) then
				
				Str = "setmetatable(" .. Options.Space .. Str .. "," .. Options.Space .. Module.ToString( getmetatable( Obj ), nil, Options, Tabs, Cyclic, Key, CyclicObjs, WaitedFor )
				
			end
			
			if First and Name ~= ( "	" ):rep( Tabs ) then
				
				for a, b in pairs( CyclicObjs ) do
					
					Str = Str .. Options.SecondaryNewLine .. Options.Tab:rep( Tabs ) .. Options.NewLine .. Options.Tab:rep( Tabs ) .. a .. Options.Space .. "=" .. Options.Space .. b
					
				end
				
			end
			
			return Name .. Str
			
		elseif Type == "string" then
			
			Obj = Obj:gsub( "\\", "\\\\" )
			
			local Start, End
			
			if Obj:find( "\n" ) then
				
				Start, End = "[[", "]]"
				
				if Obj:find( "%[%[" ) or Obj:find( "%]%]" ) then
					
					Obj = Obj:gsub( "%[%[", "\\%[\\%[" ):gsub( "%]%]", "\\%]\\%]" ) 
					
				end
				
			elseif Obj:find( '"' ) then
				
				if Obj:find( "'" ) then
					
					if Obj:find( "%[%[" ) or Obj:find( "%]%]" ) then
						
						Start, End = '"', '"'
						
						Obj = Obj:gsub( '"', '\\"' )
						
					else
						
						Start, End = "[[", "]]"
						
					end
					
				else
					
					Start, End = "'", "'"
					
				end
				
			else
				
				Start, End = '"', '"'
				
			end
			
			return Name .. Start .. Obj .. End
			
		elseif Type == "number" then
			
			local Str = tostring( Obj )
			
			if Str:len( ) ~= Str:match( "%d+" ):len( ) then
				
				if tonumber( Str ) then
					
					return Name .. 'tonumber(' .. Options.Space .. '"' .. Str .. '"' .. Options.Space .. ')'
					
				elseif Obj == math.huge then
					
					return Name .. "math.huge"
					
				else
					
					return Name .. "0" .. Options.Space .. "/" .. Options.Space .. "0"
					
				end
				
			end
			
			return Name .. Str
			
		elseif Type == "boolean" then
			
			return Name .. tostring( Obj )
			
		elseif Type == "Instance" then
			
			if Obj == game then return "game" end
			
			if not Obj.Parent then return "" end
			
			local Par = Obj
			
			local Str = ""
			
			while Par do
				
				if Par == workspace then
					
					Str = "workspace" .. Str
					
					break
					
				elseif Par == game then
					
					Str = "game" .. Str
					
					break
					
				elseif Par.Parent == game then
					
					Str = "game:GetService(" .. Options.Space .. Module.ToString( Par.ClassName, nil, Options, 0, Cyclic, Key, CyclicObjs, WaitedFor ) .. Options.Space .. ")" .. Str
					
					break
					
				elseif WaitedFor[ Par ] then
					
					Str = "." .. Par.Name .. Str
					
				else
					
					WaitedFor[ Par ] = true
					
					Str = ":WaitForChild(" .. Options.Space .. Module.ToString( Par.Name, nil, Options, 0, Cyclic, Key, CyclicObjs, WaitedFor ) .. Options.Space .. ")" .. Str
					
				end
				
				Par = Par.Parent
				
			end
			
			return Name .. Str
			
		elseif Type == "nil" then
			
			return Name .. "nil"
			
		elseif Type == "EnumItem" then
			
			return Name .. tostring( Obj )
			
		elseif Type == "function" then
			
			return Name .. [[function ( ) error( "Can't run ToString functions" ) end]]
			
		elseif Type == "BrickColor" then
			
			return Name .. Type .. ".new(" .. Options.Space .. Module.ToString( tostring( Obj ), nil, Options, 0, Cyclic, Key, CyclicObjs, WaitedFor ) .. Options.Space .. ")"
			
		elseif Type == "Color3" then
			
			return Name .. Type .. ".fromRGB(" .. Options.Space .. math.floor( Obj.r * 255 + 0.5 ) .. "," .. Options.Space .. math.floor( Obj.g * 255 + 0.5 ) .. "," .. Options.Space .. math.floor( Obj.b * 255 + 0.5 ) .. Options.Space .. ")"
			
		else
			
			return Name .. Type .. ".new(" .. Options.Space ..tostring( Obj ) .. Options.Space .. ")"
			
		end
		
	end
	
	function Module.FormatStringTable( Table )
		
		local Str = ""
		
		local Last = Table[ #Table ]
		
		Table[ #Table ] = nil
		
		Str = table.concat( Table, ", " )
		
		Str = Str .. ( Str ~= "" and "and" or "" ) ..  Last
		
		return Str
		
	end
	
	function Module.TableHasValue( Table, Obj )
		
		for a = 1, #Table do
			
			if Table[ a ] == Obj then return a end
			
		end
		
	end
	
	function Module.TableHasValuePairs( Table, Obj )
		
		for a, b in pairs( Table ) do
			
			if b == Obj then return a end
			
		end
		
	end
	
	function Module.TableShallowCopy( Table )
		
		local Copy = { }
		
		for a, b in pairs( Table ) do
			
			Copy[ a ] = b
			
		end
		
		return Copy
		
	end
	
	function Module.TableCount( Table )
		
		local Num = 0
		
		for a, b in pairs( Table ) do
			
			Num = Num + 1
			
		end
		
		return Num
		
	end
	
	function Module.TableHighestKey( Table )
		
		local Last = 0
		
		for a, b in pairs( Table ) do
			
			Last = a
			
		end
		
		return Last
		
	end
	
	function Module.TableHighestValue( Table )
		
		local Last = 0
		
		for a, b in pairs( Table ) do
			
			Last = math.max( Last, b )
			
		end
		
		return Last
		
	end
	
	function Module.TableFirstKey( Table )
		
		for a, b in pairs( Table ) do
			
			return a
			
		end
		
	end
	
	function Module.GetPlayerTools( Plr, StarterGear )
		
		local Tools = { }
		
		local Locations = { Plr.Character, Plr:FindFirstChild( "Backpack" ), ( StarterGear and Plr:FindFirstChild( "StarterGear" ) or nil ) }
		
		for a = 1, #Locations do
			
			local Children = Locations[ a ]:GetChildren( )
			
			for b = 1, #Children do
				
				if Children[ b ]:IsA( "Tool" ) then table.insert( Tools, Children[ b ] ) end
				
			end
			
		end
		
		return Tools
		
	end
	
	function Module.EscapeSplit( String, Pattern )
		
		local Result = { }
		
		local Count, _ = 0
		
		local From = 1
		
		local delim_from, delim_to = String:find( Pattern, From )
		
		while delim_from do
			
			local LastCount = Count
			
			local Str = String:sub( From , delim_from - 1 )
			
			_, Count = Str:reverse( ):find( "^[%%]+" )
			
			Count = Count or 0
			
			Str = Str:sub( 1, Str:len( ) - math.ceil( Count / 2 ) )
			
			if Count % 2 ~= 0 then
				
				Str = Str .. String:sub( delim_from, delim_to )
				
			end
			
			if LastCount % 2 ~= 0 then
				
				Result[ #Result ] = Result[ #Result ] .. Str
				
				From = delim_to + 1
				
				delim_from, delim_to = String:find( Pattern, From )
				
			else
				
				Result[ #Result + 1 ] = Str
				
				From = delim_to + 1
				
				delim_from, delim_to = String:find( Pattern, From )
				
			end
			
		end
		
		if Count % 2 ~= 0 then
			
			Result[ #Result ] = Result[ #Result ] .. String:sub( From )
			
		else
			
			Result[ #Result + 1 ] = String:sub( From )
			
		end
		
		return Result
		
	end
	
	function Module.Split( String, Pattern )
		
		local Result = { }
		
		local From = 1
		
		local delim_from, delim_to = String:find( Pattern, From  )
		
		while delim_from do
			
			Result[ #Result + 1 ] = String:sub( From, delim_from - 1 )
			
			From  = delim_to + 1
			
			delim_from, delim_to = String:find( Pattern, From  )
			
		end
		
		Result[ #Result + 1 ] = String:sub( From )
		
		return Result
		
	end
	
	Module.LastPos = ( _G.VH_Saved or { } ).PlrLogs or setmetatable( { }, { __mode = 'k' })
	
	function Module.Teleport( Player, Target )
		
		spawn( function ( )
			
			if Player == nil then return end
			
			if Player.Character and Player.Character:FindFirstChild( "HumanoidRootPart" ) then
				
				local Humanoid = Player.Character:FindFirstChildOfClass( "Humanoid" )
				
				if Humanoid and Humanoid.SeatPart and Humanoid.SeatPart:FindFirstChild( "SeatWeld" ) then
					
					Humanoid.SeatPart:FindFirstChild( "SeatWeld" ):Destroy( )
					
					wait( ) wait( )
					
				end
				
				Module.LastPos[ Player ] = Player.Character.HumanoidRootPart.CFrame
				
				Player.Character.HumanoidRootPart.CFrame = Target
				
			end
			
		end )
		
	end
	
	function Module.TimeRemaining( String )
		
		if not tonumber( String ) then return "forever" end
		
		String = tonumber( String ) - os.time( )
		
		return ( "%.2d:%.2d:%.2d:%.2d" ):format( String / ( 60 * 60 * 24 ), String / ( 60 * 60 ) % 24, String / 60 % 60, String % 60 )
		
	end
	
	function Module.TimeSince( String )
		
		if not tonumber( String ) then return "forever" end
		
		String = os.time( ) - tonumber( String )
		
		return ( "%.2d:%.2d:%.2d:%.2d" ):format( String / ( 60 * 60 * 24 ), String / ( 60 * 60 ) % 24, String / 60 % 60, String % 60 )
		
	end
	
	local Cache = { }
	
	function Module.UsernameFromID( ID )
		
		if Cache[ ID ] then return Cache[ ID ] end
		
		if not tonumber( ID ) then
			
			return ID
			
		end
		
		ID = tonumber( ID )
		
		if ID > 0 then
			
			local Name = Players:GetNameFromUserIdAsync( ID )
			
			Cache[ ID ] = Name
			
			return Name
			
		elseif ID > -1000 then
			
			if ID == -1 then
				
				return "Player"
				
			else
				
				return "Player" .. ID * -1
				
			end
			
		else
			
			return "Guest "..tostring( ID ):sub( -4 ):gsub( "^0*","" )
			
		end
		
		return ID
		
	end
	
	function Module.Pluralise( String )
		
		if String:sub( String:len( ) ) == "s" then
			
			return String .. "es"
			
		end
		
		return String .. "s"
		
	end
	
	local sub = string.sub
	
	function Module.utf8safeoffset( Str, Pos )
		
		return Pos == 0 and 1 or utf8.offset( Str, Pos ) or Str:len( ) + 1
		
	end
	
	function Module.utf8sub( Str, Start, End )
		
		return sub( Str, Module.utf8safeoffset( Str, Start ), End and Module.utf8safeoffset( Str, End + 1 ) - 1 or nil )
		
	end
	
	function Module.FormatTime( Timestamp )
		
		local Date = os.date( "*t", Timestamp )
		
		return string.format( "%02d/%02d/%04d at %02d:%02d:%02d", Date.day, Date.month, Date.year, Date.hour, Date.min, Date.sec  )
		
	end
	
	if Main then
		
		for a = 1, #Module.ConfigDefaults do
			
			if Main.Config[ Module.ConfigDefaults[ a ][ 1 ] ] == nil then
				
				Main.Config[ Module.ConfigDefaults[ a ][ 1 ] ] = Module.ConfigDefaults[ a ][ 2 ]
				
			end
			
		end
		
		VH_Events.Destroyed.Event:Connect( function ( Update )
			
			if not Update then return end
			
			_G.VH_Saved.LastPos = Module.LastPos
			
		end )
		
		-- { Text = "Welcome to my game!", Color = Color3.new(0,1,1), Font = Enum.Font.SourceSans, FontSize = Enum.FontSize.Size24 }
		
		function Module.SendMessage( Plr, Text, Color, Font, FontSize )
			
			if Color == "Info" then
				
				Color = BrickColor.new( "Fog" ).Color
				
				Text = "VH - Info - " .. Text
				
			elseif Color == "Warning" then
				
				Color = Color3.fromRGB( 255, 194, 61 )
				
				Font = Enum.Font.Code
				
				Text = "VH - Warning - " .. Text
				
			elseif Color == "Error" then
				
				Color = Color3.fromRGB( 178, 49, 34 )
				
				Font = Enum.Font.Code
				
				Text = "VH - Error - " .. Text
				
			end
			
			Color = Color or BrickColor.new( "Fog" ).Color
			
			if not script.Parent then return end
			
			if Plr then
				
				Plr = type( Plr ) == "table" and Plr.Origin or Plr
				
				if Plr.UserId == "Console" then
					
					print( Text )
				
				elseif type( Plr ) == "table" then
					
					for a = 1, #Plr do
						
						ModFolder.SystemMessage:FireClient( Plr[ a ], { Text = Text, Color = Color, Font = Font, FontSize = FontSize } )
						
					end
					
				else
					
					ModFolder.SystemMessage:FireClient( Plr, { Text = Text, Color = Color, Font = Font, FontSize = FontSize } )
					
				end
						
			else
				
				ModFolder.SystemMessage:FireAllClients( { Text = Text, Color = Color, Font = Font, FontSize = FontSize } )
				
			end
			
		end
		
		Main.Util = Module
		
	end
	
	return Module

end