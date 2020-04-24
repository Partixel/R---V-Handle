local Players, Debris = game:GetService("Players"), game:GetService("Debris")
local Stringify = require(2789644632)

return function(Main, Client, VH_Events)
	local Module = {Stringify = Stringify}
	
	local ConfigDefaults = {
		{
			"AnnounceJoin",
			true,
			[[If true the admin will print when a player joins to the chat]],
		},
		{
			"AnnounceLeft",
			true,
			[[If true the admin will print when a player leaves to the chat]],
		},
		{
			"UpdatePeriod",
			60,
			[[How often the admin checks for updates in seconds (Must be at least 30 and at most 1800)]],
			function(Obj) return math.max(math.min(Obj, 1800), 30) end,
		},
		{
			"CommandOptions",
			{},
			[[Override properties of commands like CanRun or Category
	--Examples--
	Config.CommandOptions = {Kill = {CanRun = "all"}} - Allows everyone to use the Kill command]],
		},
		{
			"UserPowers",
			{},
			[[Preceed users with "-" to override any other ranks they are given with the specified ran (More minuses means higher priority)
	e.g. ["-partixel"] = "user" - will force Partixel to have the rank "user" even if other UserPowers match him
	--Examples--
	Config.UserPowers = {["1234"] = "admin"} - This gives admin to the player with a userid equal to "1234"
	Config.UserPowers = {["^4321^50"] = "admin"} - This gives admin to anyone in the group "4321" and have a rank above "50"
	Config.UserPowers = {["^4321&!^1234^12"] = "admin"} - This gives admin to anyone in the group "4321" and don't have a rank of 12 or above in the group "1234"]],
		},
		{
			"Banned",
			{},
			[[Players matching a string on this list is prevented from joining the game with the reason being the value or a default message if true
	--Examples--
	Config.Banned = {["partixel"] = true}
	Config.Banned = {["1234"] = "Hacking", ["^1059575"] = "Bad group"}]],
		},
		{
			"DisabledCommandModules",
			{["VH_Main"] = false, ["VH_Fun"] = false},
			[[If true the specified command module will not load
	Use this if you don't want commands from said command module (e.g. if you don't want 'Fun' commands do ["VH_Fun"] = true]]
		},
	}
	
	function Module.CreateConfigString(Config, LatestSetupVersion)
		Config.SetupVersion = nil
		
		local Cfg = "return {"
		for i, Data in ipairs(ConfigDefaults) do
			if type(Data) == "table" then
				local Val = Config[Data[1]]
				if Val == nil then
					Val = Data[2]
				end
				if Data[4] then
					Val = Data[4](Val)
				end
				Val = Stringify(Val, Data[1], nil, 1)
				
				Cfg = Cfg .. (i ~= 1 and "\n	" or "") .. "\n" .. (Data[3]and "	--[[" .. Data[3] .. "]]\n" or "") .. Val .. ", -- Default - " .. Stringify(Data[2], nil, {NewLine = "", SecondaryNewLine = "", Tab = ""})
			else
				Cfg = Cfg .. (i ~= 1 and "\n	" or "") .. "\n	--------[[" .. Data .. "]]--------"
			end
		end
		
		return Cfg .. '\n	\n	SetupVersion = "' .. LatestSetupVersion .. '", -- DO NOT CHANGE THIS\n}'
	end
	
	function Module.FormatStringTable(Table)
		Table = {unpack(Table)}
		local Str = ""
		local Last = Table[#Table]
		Table[#Table] = nil
		Str = table.concat(Table, ", ")
		Str = Str .. (Str ~= "" and " and " or "") ..  Last
		return Str
	end
	
	function Module.TableOverlappingValues(Table, OtherTable)
		local Overlap = {}
		for _, Val in ipairs(Table) do
			if table.find(OtherTable, Val) then
				Overlap[#Overlap + 1] = Val
			end
		end
		return Overlap
	end
	
	function Module.TableNotOverlappingValues(Table, OtherTable)
		local NotOverlap = {}
		for _, Val in ipairs(Table) do
			if not table.find(OtherTable, Val) then
				NotOverlap[#NotOverlap + 1] = Val
			end
		end
		return NotOverlap
	end
	
	function Module.TableHasValuePairs(Table, Obj)
		for a, b in pairs(Table) do
			if b == Obj then
				return a
			end
		end
	end
	
	function Module.TableDeepCopy(Table)
		local Copy = {}
		for a, b in pairs(Table) do
			Copy[a] = type(b) == "table" and Module.TableDeepCopy(b) or b
		end
		return Copy
	end
	
	function Module.TableCount(Table)
		local Num = 0
		for a, b in pairs(Table) do
			Num = Num + 1
		end
		return Num
	end
	
	function Module.TableHighestKey(Table)
		local Last = 0
		for a, b in pairs(Table) do
			Last = a
		end
		return Last
	end
	
	function Module.TableHighestValue(Table)
		local Last = 0
		for a, b in pairs(Table) do
			Last = math.max(Last, b)
		end
		return Last
	end
	
	function Module.GetPlayerTools(Plr, StarterGear)
		local Tools = {}
		for _, Location in ipairs({Plr.Character, Plr:FindFirstChild("Backpack"), (StarterGear and Plr:FindFirstChild("StarterGear") or nil)}) do
			for _, Child in ipairs(Location:GetChildren()) do
				if Child:IsA("Tool") then
					table.insert(Tools, Child)
				end
			end
		end
		return Tools
	end
	
	function Module.EscapeSplit(String, Pattern)
		local Result = {}
		
		local Count = 0
		local From = 1
		
		local delim_from, delim_to = String:find(Pattern, From)
		while delim_from do
			local LastCount = Count
			
			local Str = String:sub(From , delim_from - 1)
			
			Count = select(2, Str:reverse():find("^[%%]+")) or 0
			
			Str = Str:sub(1, -math.ceil(Count / 2) - 1)
			
			if Count % 2 ~= 0 then
				Str = Str .. String:sub(delim_from, delim_to)
			end
			
			if LastCount % 2 ~= 0 then
				Result[#Result] = Result[#Result] .. Str
				From = delim_to + 1
				delim_from, delim_to = String:find(Pattern, From)
			else
				Result[#Result + 1] = Str
				From = delim_to + 1
				delim_from, delim_to = String:find(Pattern, From)
			end
		end
		
		if Count % 2 ~= 0 then
			Result[#Result] = Result[#Result] .. String:sub(From)
		else
			Result[#Result + 1] = String:sub(From)
		end
		
		return Result
	end
	
	Module.LastPos = (_G.VH_Saved or {}).PlrLogs or setmetatable({}, {__mode = 'k'})
	local function ActualTeleport(Player, Target, Humanoid)
		if Humanoid.SeatPart and Humanoid.SeatPart:FindFirstChild("SeatWeld") then
			Humanoid.SeatPart:FindFirstChild("SeatWeld"):Destroy()
			wait() wait()
		end
		
		Module.LastPos[Player] = Player.Character.HumanoidRootPart.CFrame
		Player.Character.HumanoidRootPart.CFrame = Target
	end
	
	function Module.Teleport(Player, Target)
		local Humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			coroutine.wrap(ActualTeleport)(Player, Target, Humanoid)
		end
	end
	
	function Module.TimeToString(Time)
		return ("%.2d:%.2d:%.2d:%.2d"):format(Time / (60 * 60 * 24), Time / (60 * 60) % 24, Time / 60 % 60, Time % 60)
	end
	
	function Module.TimeRemaining( Time )
		if tonumber(Time) then
			return Module.TimeToString(tonumber(Time) - os.time())
		else
			return "forever"
		end
	end
	
	function Module.TimeSince( Time )
		if tonumber(Time) then
			return Module.TimeToString(os.time() - tonumber(Time))
		else
			return "forever"
		end
	end
	
	local Cache = {}
	function Module.UsernameFromID(ID)
		if Cache[ID] then
			return Cache[ID]
		else
			if tonumber(ID) then
				ID = tonumber(ID)
				if ID > 0 then
					Cache[ID] = Players:GetNameFromUserIdAsync(ID)
					return Cache[ID]
				elseif ID > -1000 then
					if ID == -1 then
						return "Player"
					else
						return "Player" .. ID * -1
					end
				else
					return "Guest "..tostring(ID):sub(-4):gsub("^0*","")
				end
			else
				return ID
			end
		end
	end
	
	function Module.Pluralise(String)
		return String:sub(-1) == "s" and (String .. "es") or (String .. "s")
	end
	
	function Module.utf8safeoffset(Str, Pos)
		return Pos == 0 and 1 or utf8.offset(Str, Pos) or #Str + 1
	end
	
	function Module.utf8sub(Str, Start, End)
		return Str:sub(Module.utf8safeoffset(Str, Start), End and Module.utf8safeoffset(Str, End + 1) - 1 or nil)
	end
	
	function Module.FormatTime(Timestamp)
		local Date = os.date("*t", Timestamp)
		return string.format("%02d/%02d/%04d at %02d:%02d:%02d", Date.day, Date.month, Date.year, Date.hour, Date.min, Date.sec  )
	end
	
	if Main then
		VH_Events.Destroyed.Event:Connect(function(Update)
			if Update then
				_G.VH_Saved.LastPos = Module.LastPos
			end
		end)
			
		function Module.PrintClient(Plr, Text)
			Client.Print:FireClient(Plr, Text)
		end
		-- {Text = "Welcome to my game!", Color = Color3.new(0,1,1), Font = Enum.Font.SourceSans, FontSize = Enum.FontSize.Size24}
		function Module.SendMessage(Plr, Text, Color, Font, FontSize)
			if Color == "Info" then
				Color = BrickColor.new("Fog").Color
				Text = "VH - Info - " .. Text
			elseif Color == "Warning" then
				Color = Color3.fromRGB(255, 194, 61)
				Font = Enum.Font.Code
				Text = "VH - Warning - " .. Text
			elseif Color == "Error" then
				Color = Color3.fromRGB(178, 49, 34)
				Font = Enum.Font.Code
				Text = "VH - Error - " .. Text
			else
				Color = Color or BrickColor.new("Fog").Color
			end
			
			if Plr then
				Plr = type(Plr) == "table" and Plr.Origin or Plr
				if Plr.UserId == "Console" then
					print(Text)
				elseif type(Plr) == "table" then
					for _, Target in ipairs(Plr) do
						Client.SystemMessage:FireClient(Target, {Text = Text, Color = Color, Font = Font, FontSize = FontSize})
					end
				else
					Client.SystemMessage:FireClient(Plr, {Text = Text, Color = Color, Font = Font, FontSize = FontSize})
				end
			else
				Client.SystemMessage:FireAllClients({Text = Text, Color = Color, Font = Font, FontSize = FontSize})
			end
		end
		
		function Module.FormatPlayerList(Executor, List, To)
			if #List ~= 1 and #List == #Players:GetPlayers() then
				return "{everyone:lookup}"
			else
				List = {unpack(List)}
				for k, Plr in ipairs(List) do
					if Plr == Executor then
						if Plr == To then
							List[k] = "{yourself:lookup}"
						else
							List[k] = "{themself:lookup}"
						end
					elseif Plr == To then
						List[k] = "{you:lookup}"
					else
						List[k] = Plr.Name
					end
				end
				
				return Module.FormatStringTable(List)
			end
		end
		
		function Module.HandlePlayerTargetResult(Executor, Silent, Targets, Successful, Format)
			local Warning
			Format["Targets"] = Module.FormatPlayerList(Executor, Successful and #Successful > 0 and Successful or Targets)
			if Successful then
				if #Successful == 0 then
					Format["FailedTargets"] = Module.FormatPlayerList(Executor, Targets, Executor)
					Format["TargetPronoun"] = (Format["FailedTargets"] == "{yourself:lookup}" and "you" or "they")
					Format["TargetDeterminer"] = (Format["FailedTargets"] == "{yourself:lookup}" and "your" or "their")
					return {Success = false, HaltStack = true, Warning = {"Failed", Format}}
				elseif #Successful ~= #Targets then
					Format["FailedTargets"] = Module.FormatPlayerList(Executor, Module.TableNotOverlappingValues(Targets, Successful), Executor)
					Format["TargetPronoun"] = (Format["FailedTargets"] == "{yourself:lookup}" and "you" or "they")
					Format["TargetDeterminer"] = (Format["FailedTargets"] == "{yourself:lookup}" and "your" or "their")
					Warning = {"PartiallyFailed", Format}
				end
			end
			
			return {Success = true, Message = {"Success", Format}, Warning = Warning}
		end
		
		Main.Util = Module
	end
	
	return Module
end