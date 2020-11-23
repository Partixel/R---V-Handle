----==== Create variables ====----

local Main, Players, InsertService, Chat, ServerStorage, RunService, TextService, StarterPlayerScripts, HttpService, ChatModules = {}, game:GetService("Players"), game:GetService("InsertService"), game:GetService("Chat"), game:GetService("ServerStorage"), game:GetService("RunService"), game:GetService("TextService"), game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"), game:GetService("HttpService"), game:GetService("Chat"):WaitForChild("ChatModules")

Main.CoroutineErrorHandling = require(game:GetService("ReplicatedStorage"):FindFirstChild("CoroutineErrorHandling") or game:GetService("ServerStorage"):FindFirstChild("CoroutineErrorHandling") and game:GetService("ServerStorage").CoroutineErrorHandling:FindFirstChild("MainModule") or 4851605998)

Main.ScopedStore = require(script.ScopedStore)

require(game:GetService("ServerStorage"):FindFirstChild("TimeSync") and game:GetService("ServerStorage").TimeSync:FindFirstChild("MainModule") or 4698309617) -- TimeSync

local LoaderModule = require(game:GetService("ServerStorage"):FindFirstChild("LoaderModule") and game:GetService("ServerStorage").LoaderModule:FindFirstChild("MainModule") or 03593768376)("V-Handle")

Main.Clone = script:Clone()

local VFolder = game:GetService("ReplicatedStorage"):FindFirstChild("V-Handle") or Instance.new("Folder")

VFolder.Name = "V-Handle"

VFolder.Parent = game:GetService("ReplicatedStorage")

----==== Cleanup Old ====----

if _G.VH_Admin and _G.VH_Admin.Destroy then
	
	Main.CoroutineErrorHandling.RunFunctionWithWarn(_G.VH_Admin.Destroy)
	
end

if VFolder:FindFirstChild("VH_Events") then
	
	if VFolder.VH_Events:FindFirstChild("Destroyed") then
		
		_G.VH_Saved = {}
		
		VFolder.VH_Events.Destroyed:Fire(true)
		
	end
	
	if VFolder.VH_Events:FindFirstChild("RemoteDestroyed") then
		
		VFolder.VH_Events.RemoteDestroyed:FireAllClients(true)
		
	end
	
end

while ServerStorage:FindFirstChild("VH_Main") do
	
	ServerStorage.VH_Main:Destroy()
	
end

while StarterPlayerScripts:FindFirstChild("VH_Client") do
	
	StarterPlayerScripts.VH_Client:Destroy()
	
end

VFolder:ClearAllChildren()

while ChatModules:FindFirstChild("VH_Command_Processor") do ChatModules.VH_Command_Processor:Destroy() end

----==== Get Config ====----

local Config = game:GetService("ServerScriptService"):FindFirstChild("V-Handle Setup"):WaitForChild("Config"):Clone()
Main.Config = require(Config)
Config.Parent = VFolder

Main.ConfigDefaults = require(script.ConfigDefaults)

local Updated = ServerStorage:FindFirstChild("VH_Ran")
if not Updated then
	Instance.new("Folder", ServerStorage).Name = "VH_Ran"
end

----==== Debugger ====----

Main.CoroutineErrorHandling.CoroutineWithStack(require, game:GetService("ServerStorage"):FindFirstChild("DebugUtil") and game:GetService("ServerStorage").DebugUtil:FindFirstChild("MainModule") or 953754819)

----==== Create Admin Variables ====----

Main.Changelog = require(script.Changelog)
print("VH - Loading version " .. Main.Changelog[2].Version .. " - s" .. Main.Changelog[2].SetupVersion)

Main.TargetLib = require(script.TargetLib)

Main.ExtendedTranslations = require(script.ExtendedTranslations)
script.ExtendedTranslations.Parent = VFolder

Main.TargetLib.NegativePrefixes = {"-", "un", "de", "retake", "take", "in", "end", "stop", "unset", "off", "disable",}

Main.TargetLib.PositivePrefixes = {"+", "re", "give", "regive", "start", "set", "on", "enable",}

Main.TargetLib.TogglePrefixes = {"=", "t", "toggle"}

local function Prefix(Table, String)
	
	local New = {}
	
	for a = 1, #Table do
		
		New[a] = String .. Table[a]
		
	end
	
	return unpack(New)
	
end

Main.TargetLib.AliasTypes = {}

Main.TargetLib.AliasTypes.Toggle = function(Arg, Pos, ...)
	
	local Aliases = {...}
	
	if type(Pos) == "string" then
		
		table.insert(Aliases, 1, Pos)
		
		Pos = nil
		
	end
	
	local PositiveAliases, NegativeAliases, ToggleAliases = {Args = {[Arg] = true}, unpack(Aliases)}, {Args = {[Arg] = false}}, {}
	
	for a = 1, #Aliases do
		
		local First, Second = "", Aliases[a]
		
		if Pos then
			
			First, Second = Second:sub(1, Pos - 1), Second:sub(Pos)
			
		end
		
		for b = 1, #Main.TargetLib.PositivePrefixes do
			
			PositiveAliases[#PositiveAliases + 1] = First .. Main.TargetLib.PositivePrefixes[b] .. Second
			
		end
		
		for b = 1, #Main.TargetLib.NegativePrefixes do
			
			NegativeAliases[#NegativeAliases + 1] = First .. Main.TargetLib.NegativePrefixes[b] .. Second
			
		end
		
		for b = 1, #Main.TargetLib.TogglePrefixes do
			
			ToggleAliases[#ToggleAliases + 1] = First .. Main.TargetLib.TogglePrefixes[b] .. Second
			
		end
		
	end
	
	return PositiveAliases, NegativeAliases, unpack(ToggleAliases)
	
end

Main.TargetLib.AliasTypes.InvertedToggle = function(Arg, Pos, ...)
	
	local Aliases = {...}
	
	if type(Pos) == "string" then
		
		table.insert(Aliases, 1, Pos)
		
		Pos = nil
		
	end
	
	local PositiveAliases, NegativeAliases, ToggleAliases = {Args = {[Arg] = false}, unpack(Aliases)}, {Args = {[Arg] = true}}, {}
	
	for a = 1, #Aliases do
		
		local First, Second = "", Aliases[a]
		
		if Pos then
			
			First, Second = Second:sub(1, Pos - 1), Second:sub(Pos)
			
		end
		
		for b = 1, #Main.TargetLib.PositivePrefixes do
			
			PositiveAliases[#PositiveAliases + 1] = First .. Main.TargetLib.PositivePrefixes[b] .. Second
			
		end
		
		for b = 1, #Main.TargetLib.NegativePrefixes do
			
			NegativeAliases[#NegativeAliases + 1] = First .. Main.TargetLib.NegativePrefixes[b] .. Second
			
		end
		
		for b = 1, #Main.TargetLib.TogglePrefixes do
			
			ToggleAliases[#ToggleAliases + 1] = First .. Main.TargetLib.TogglePrefixes[b] .. Second
			
		end
		
	end
	
	return PositiveAliases, NegativeAliases, ToggleAliases
	
end

Main.TargetLib.AliasTypes.Positive = function(Arg, ...)
	
	local Aliases = {...}
	
	Aliases.Args = {[Arg] = true}
	
	return Aliases
	
end

Main.TargetLib.AliasTypes.Negative = function(Arg, ...)
	
	local Aliases = {...}
	
	Aliases.Args = {[Arg] = false}
	
	return Aliases
	
end

Main.ConsoleToString = function() return "Console" end

Main.Console = setmetatable({UserId = "Console", Name = "Console", LocaleId = "en_us"}, {__tostring = Main.ConsoleToString})

Main.Loops = {}

Main.Objs = {}

Main.Events = {}

Main.AnnounceJoin = {}

Main.AnnouncedLeft = {}

Main.CommandRan = Instance.new("BindableEvent")

Main.CommandStackRan = Instance.new("BindableEvent")

Main.ModuleLoaded = Instance.new("BindableEvent")

----==== Main ====----

script.Name = "VH_Main"

script.Archivable = false

if script.Parent and script.Parent.Name == "Model" then
	
	local Old = script.Parent
	
	script.Parent = ServerStorage
	
	Old:Destroy()
	
else
	
	script.Parent = ServerStorage
	
end

local VH_Events = script.VH_Events

local VH_Command_Modules, VH_Command_Clients

local VH_Command_Processor = script.VH_Command_Processor

VH_Events.Parent = VFolder

VH_Command_Processor.Parent = ChatModules

local TextService = game:GetService("TextService")

function Main.FilterTo(From, To, FuncName, Text, ...)
	From = type(From) == "table" and From.Origin or From
	
	if From.UserId == "Console" or not Text then
		for _, ToPlr in ipairs(type(To) == "userdata" and {To} or type(To) == "table" and To or Players:GetPlayers()) do
			VH_Events.FilteredReplication:FireClient(ToPlr, FuncName, Text, ...)
		end
	else
		local FilterResult = TextService:FilterStringAsync(Text, From.UserId)
		for _, ToPlr in ipairs(type(To) == "userdata" and {To} or type(To) == "table" and To or Players:GetPlayers()) do
			VH_Events.FilteredReplication:FireClient(ToPlr, FuncName, FilterResult:GetChatForUserAsync(ToPlr.UserId), ...)
		end
	end
end

local PersistentFilters = {}

Main.Events[#Main.Events + 1] = Players.PlayerAdded:Connect(function(Plr)
	for _, FilterInfo in pairs(PersistentFilters) do
		if FilterInfo.From.UserId == "Console" or not FilterInfo.Text then
			VH_Events.PersistentFilteredReplication:FireClient(Plr, FilterInfo.FuncName, FilterInfo.Key_Time, FilterInfo.Text, unpack(FilterInfo.Args))
			if FilterInfo.To then
				FilterInfo.To[#FilterInfo.To + 1] = Plr
			end
		else
			local FilterResult = TextService:FilterStringAsync(FilterInfo.Text, FilterInfo.From.UserId)
			VH_Events.PersistentFilteredReplication:FireClient(Plr, FilterInfo.FuncName, FilterInfo.Key_Time, FilterResult:GetChatForUserAsync(Plr.UserId), unpack(FilterInfo.Args))
			if FilterInfo.To then
				FilterInfo.To[#FilterInfo.To + 1] = Plr
			end
		end
	end
end)

local function EndTimedFilter(Key, Time, ...)
	wait(Time)
	
	PersistentFilters[Key] = nil
end

function Main.PersistentFilter(From, FuncName, Key_Time, Text, ...)
	From = type(From) == "table" and From.Origin or From
	local To = Players:GetPlayers()
	local Start, Args = tick(), {...}
	
	if From.UserId == "Console" or not Text then
		for _, ToPlr in ipairs(To) do
			VH_Events.PersistentFilteredReplication:FireClient(ToPlr, FuncName, type(Key_Time) == "number" and tick() + Key_Time or Key_Time, Text, ...)
		end
	else
		local FilterResult = TextService:FilterStringAsync(Text, From.UserId)
		for _, ToPlr in ipairs(To) do
			VH_Events.PersistentFilteredReplication:FireClient(ToPlr, FuncName, type(Key_Time) == "number" and tick() + Key_Time or Key_Time, FilterResult:GetChatForUserAsync(ToPlr.UserId), ...)
		end
	end
		
	if type(Key_Time) == "string" then
		PersistentFilters[Key_Time] = {To = To, From = From, FuncName = FuncName, Key_Time = Key_Time, Text = Text, Args = Args}
	else
		local Key = {}
		PersistentFilters[Key] = {From = From, FuncName = FuncName, Key_Time = tick() + Key_Time, Text = Text, Args = Args}
		
		Main.CoroutineErrorHandling.CoroutineWithStack(EndTimedFilter, Key, Key_Time, FuncName, Text)
	end
end

function Main.EndPersistentFilter(Key)
	for _, ToPlr in ipairs(PersistentFilters[Key].To) do
		if ToPlr.Parent then
			VH_Events.PersistentFilteredReplication:FireClient(ToPlr, PersistentFilters[Key].FuncName, Key)
		end
	end
	PersistentFilters[Key] = nil
end

local function Fill(Table, a, max)
	
	a = a or 1
	
	if not max then
		
		max = 1
		
		for a, b in pairs(Table) do
			
			max = math.max(max, a)
			
		end
		
	end
	
	if a > max then return end
	
	return Table[a], Fill(Table, a + 1, max)
	
end

function Main.GetCmdStacks(Executor, Cmd, StrArgs, ArgSplit)
	
	local CmdObj, Args = Main.GetCommandAndArgs(Cmd, Executor)
	
	if not CmdObj then
		
		return false
		
	end
	
	if CmdObj.Commands then
		
		for a = 1, #CmdObj.Commands do
			
			if CmdObj.Commands[a].CanRun and not Main.TargetLib.MatchesPlr(CmdObj.Commands[a].CanRun, Executor) then
				
				return "Cannot run " .. Cmd .. "!"
				
			end
			
		end
		
	else
		
		if CmdObj.CanRun and not Main.TargetLib.MatchesPlr(CmdObj.CanRun, Executor) then
			
			return "Cannot run " .. Cmd .. "!"
			
		end
		
	end
	
	local Valid, Fail = true, ""
	
	if CmdObj.ArgTypes then
		
		Args = Args or {}
		
		local ArgCount = math.max(#StrArgs, #CmdObj.ArgTypes)
		
		local Tmp = {unpack(StrArgs)}
		
		for a = 1, ArgCount do
			
			if Args[a] == nil then
				
				if Tmp[1] == nil or Tmp[1] == "" or not CmdObj.ArgTypes[a] then
					
					if type(CmdObj.ArgTypes[a]) == "table" then
						
						if CmdObj.ArgTypes[a].Default ~= nil then
							
							local Arg = CmdObj.ArgTypes[a].Default
							
							if type(Arg) == "function" then
								
								local Parsed, Ran, FailMsg = Arg(type(CmdObj.ArgTypes[a]) == "table" and CmdObj.ArgTypes[a] or {}, Tmp, Executor, a == #CmdObj.ArgTypes, Cmd, ArgSplit)
								
								if CmdObj.ArgTypes[a].Required and (Parsed == nil or Ran == false) then
									
									Fail = "Argument " .. a .. " is incorrect" .. (FailMsg and ("\n" .. FailMsg) or "") 
									
									Valid = false
									
									break
									
								end
								
								Arg = Parsed
								
							end
							
							Args[a] = Arg
							
						elseif CmdObj.ArgTypes[a].Required then
							
							Fail = "Argument " .. a .. " is required"
							
							Valid = false
							
							break
							
						end
						
						table.remove(Tmp, 1)
						
					elseif CmdObj.ArgTypes[a] == nil then
						
						Args[a] = table.remove(Tmp, 1)
						
					end
				
				elseif CmdObj.ArgTypes[a] then
					
					if Tmp[1] == Main.TargetLib.ValidChar and type(CmdObj.ArgTypes[a]) == "table" and CmdObj.ArgTypes[a].Default ~= nil then
						
						local Arg = CmdObj.ArgTypes[a].Default
						
						if type(Arg) == "function" then
							
							local Parsed, Ran, FailMsg = Arg(type(CmdObj.ArgTypes[a]) == "table" and CmdObj.ArgTypes[a] or {}, Tmp, Executor, a == #CmdObj.ArgTypes, Cmd, Args, ArgSplit)
							
							if CmdObj.ArgTypes[a].Required and (Parsed == nil or Ran == false) then
								
								Fail = "Argument " .. a .. " is incorrect" .. (FailMsg and ("\n" .. FailMsg) or "") 
								
								Valid = false
								
								break
								
							end
							
							Arg = Parsed
							
						end
						
						Args[a] = Arg
						
						table.remove(Tmp, 1)
						
					else
						
						local Func = type(CmdObj.ArgTypes[a]) == "function" and CmdObj.ArgTypes[a] or CmdObj.ArgTypes[a].Func
						
						local Parsed, Ran, FailMsg = Func(type(CmdObj.ArgTypes[a]) == "table" and CmdObj.ArgTypes[a] or {}, Tmp, Executor, a == #CmdObj.ArgTypes, Cmd, Args, ArgSplit)
						
						if (Parsed == nil or Ran == false) then
							
							Fail = "Argument " .. a .. " is incorrect" .. (FailMsg and ("\n" .. FailMsg) or "") 
							
							Valid = false
							
							break
							
						end
						
						Args[a] = Parsed
						
					end
					
				end
				
			end
			
		end
		
	else
		
		Args = {unpack(StrArgs)}
		
	end
	
	if not Valid then
		
		return Fail .. "\nCommand usage - " .. Cmd .. Main.GetUsage(Executor, Cmd)
		
	end
	
	if CmdObj.Commands then
		
		local CmdStacks = {}
		
		for a = 1, #CmdObj.Commands do
			
			CmdStacks[#CmdStacks + 1] = {CmdObj.Commands[a], Args, Cmd, StrArgs}
			
		end
		
		return CmdStacks
		
	end
	
	return {{CmdObj, Args, Cmd, StrArgs}}
	
end
	
local EscapeCharacters = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z",
}

local function GetReplacements(From, ToPlr, UnfilteredArgs, FilteredArgs)
	local Replacements = {}
	UnfilteredArgs["Executor"] = From.Name
	
	local ToPlrName = ToPlr.Name:gsub(".", EscapeCharacters)
	for k, v in pairs(UnfilteredArgs) do
		Replacements[k] = type(v) == "string" and (From.Name == ToPlr.Name and v:gsub("{themself:lookup}", "{yourself:lookup}") or v):gsub(ToPlrName, "{you:lookup}") or v
	end
	
	if FilteredArgs then
		if type(ToPlr) == "table" then
			for k, v in ipairs(FilteredArgs) do
				Replacements[k] = v
			end
		else
			for k, v in pairs(FilteredArgs) do
				Replacements[k] = FilteredArgs:GetChatForUserAsnyc(ToPlr.UserId)
			end
		end
	end
	
	return Replacements
end

local function HandleCmdResult(From, Key, UnfilteredArgs, FilteredArgs)
	From = type(From) == "table" and From.Origin or From
	
	local Filters
	if From.UserId ~= "Console" and FilteredArgs then
		Filters = {}
		for k, v in pairs(FilteredArgs) do
			Filters[k] = TextService:FilterStringAsync(v, From.UserId)
		end
	end
	
	for _, ToPlr in ipairs(Players:GetPlayers()) do
		Main.CoroutineErrorHandling.CoroutineWithStack(function()
			local Replacements = GetReplacements(From, ToPlr, UnfilteredArgs, FilteredArgs)
			VH_Events.TranslatedReplication:FireClient(ToPlr, "CommandMessage", Key, Replacements)
		end)
	end
	
	local Replacements = GetReplacements(From, Main.Console, UnfilteredArgs, FilteredArgs)
	local MyText = Main.ExtendedTranslations.TranslateFallback("en-us", Key, Replacements)
	print("V-Handle: " .. MyText:sub(1, 1):upper() .. MyText:sub(2))
end

function Main.RunCmdStacks(Executor, CmdStacks, Silent)
	local Msgs, Legacy = {}, nil
	
	repeat
		if not Main then
			return false
		 end
		
		local CmdStack = table.remove(CmdStacks, 1)
		
		local Success, Result, RanMsg = xpcall(CmdStack[1].Callback, Main.CoroutineErrorHandling.ErrorHandler, CmdStack[1], Executor, CmdStack[3], CmdStack[2], CmdStacks, Silent)
		if Success and type(Result) ~= "table" then
			warn(CmdStack[3] .. " is returning a legacy result, please update it")
			Legacy = true
			Result = {Warning = RanMsg, Success = Result}
		end
		
		if not Main then
			return Success and Result.Warning or Result.Success
		end
		
		Main.CommandRan:Fire(Success, Result, Executor, CmdStack[3], {Fill(CmdStack[2])}, CmdStack[4], CmdStacks, Silent)
		
		if not Success then
			Result = Main.CoroutineErrorHandling.GetError(Result)
			
			warn("VH - Error -", Executor, Result)
			
			if Silent then
				Msgs[#Msgs + 1] = Result
				return true, table.concat(Msgs, ",\n"), true
			end
			
			if #Msgs > 0 then
				Main.Util.SendMessage(Executor, table.concat(Msgs, ",\n"), "Error")
			end
			
			Main.Util.SendMessage(Executor, Result, "Error")
			return true, nil, true
		end
		
		if Result.Success then
			if not CmdStack[1].Silent and Result.Message then
				local Key = CmdStack[1].Name .. Result.Message[1]
				if Silent then
					local Filters
					if Executor.UserId ~= "Console" and Result.Message[3] then
						Filters = {}
						for k, v in pairs(Result.Message[3]) do
							Filters[k] = TextService:FilterStringAsync(v, Executor.UserId)
						end
					end
					
					local Replacements = GetReplacements(Executor, Executor, Result.Message[2], Filters)
					local MyText = Main.ExtendedTranslations.TranslateFallback("en-us", Key, Replacements)
					Msgs[#Msgs + 1] = MyText:sub(1, 1):upper() .. MyText:sub(2)
				else
					HandleCmdResult(Executor, Key, unpack(Result.Message, 2))
				end
			end
		elseif not Result.Warning then
			Result.Warning = "Command usage - " .. CmdStack[3] .. Main.GetUsage(Executor, CmdStack[3])
		end
		
		if Result.Warning and (not Result.Success or not Silent) then
			if type(Result.Warning) == "table" then
				local Key = CmdStack[1].Name .. Result.Warning[1]
				local Filters
				if Executor.UserId ~= "Console" and Result.Warning[3] then
					Filters = {}
					for k, v in pairs(Result.Warning[3]) do
						Filters[k] = TextService:FilterStringAsync(v, Executor.UserId)
					end
				end
				
				local Replacements = GetReplacements(Executor, Executor, Result.Warning[2], Filters)
				if Silent then
					local MyText = Main.ExtendedTranslations.TranslateFallback("en-us", Key, Replacements)	
					Msgs[#Msgs + 1] = MyText:sub(1, 1):upper() .. MyText:sub(2)
				else
					VH_Events.TranslatedReplication:FireClient(Executor, "CommandWarning", Key, Replacements)
				end
			else
				warn(CmdStack[3] .. " is returning a legacy warning, please update it:\n", Result.Warning)
				if Silent then
					Msgs[#Msgs + 1] = Result.Warning
				else
					Main.Util.SendMessage(Executor, Result.Warning, "Warning")
				end
			end
		end
		
		if Result.HaltStack then
			break
		end
	until not CmdStacks[1]
	
	if #Msgs > 0 then
		if Silent then
			return true, table.concat(Msgs, ",\n"), Legacy
		end
		
		Main.Util.SendMessage(Executor, table.concat(Msgs, ",\n"), "Warning")
	end
	
	return true, nil, Legacy
end

local SpaceCmds = {}

function Main.ParseCmdStacks(Executor, Msg, ChatSpeaker, Silent)
	
	Executor = Executor or Main.Console
	
	local Prefix, CmdSplit, ArgSplit = "", "|", "/"
	
	--[[if Msg:sub(1, 1) == ":" then
		
		Prefix, CmdSplit, ArgSplit = ":", "|", " "
		
	end]]
	
	local CmdStrings = Main.Util.EscapeSplit(Msg, CmdSplit)
	
	local CmdStacks = {}
	
	local Msgs = {}
	
	local CmdNum = 0
	
	repeat
		
		if not Main then return end
		
		CmdNum = CmdNum + 1
		
		local Args = Main.Util.EscapeSplit(table.remove(CmdStrings, 1), ArgSplit)
		
		if Prefix ~= "" then
			
			if Args[1]:sub(1, #Prefix) ~= Prefix then
				
				return nil, "Not a command"
				
			end
			
			Args[1] = Args[1]:sub(#Prefix + 1)
			
		end
		
		if #Args == 1 and Prefix == "" then
			
			return nil, "Not a command"
			
		end
		
		local Cmd = table.remove(Args, 1):lower()
		
		if ArgSplit == " " then
			
			for a = 1, # SpaceCmds do
				
				if Cmd == SpaceCmds[a]:sub(1, #Cmd) then
					
					local Str = Cmd
					
					for b = 1, #Args do
						
						Str = Str .. " " .. Args[b]
						
						if Str == SpaceCmds[a] then
							
							Str = b
							
							break
							
						elseif Str ~= SpaceCmds[a]:sub(1, #Str) then
							
							break
							
						end
						
					end
					
					if type(Str) == "number" then
						
						Cmd = SpaceCmds[a]
						
						for b = 1, Str do
							
							table.remove(Args, 1)
							
						end
						
						break
						
					end
					
				end
				
			end
			
		end
		
		if Cmd ~= "" then
			
			local Found = Main.GetCmdStacks(Executor, Cmd, Args, ArgSplit)
			
			if type(Found) == "table" then
				
				for a = 1, #Found do
					
					CmdStacks[#CmdStacks + 1] = Found[a]
					
				end
				
			else
				
				if Found then
					
					Msgs[#Msgs + 1] = Found
					
				else
					
					if CmdNum == 1 then
						
						return nil, Cmd .. " is not a command"
						
					else
						
						Msgs[#Msgs + 1] = Cmd .. " is not a command"
						
						break
						
					end
					
				end
				
			end
			
		else
			
			if CmdNum == 1 then
				
				return nil, "Command number " .. CmdNum .. " is not a command"
				
			else
				
				Msgs[#Msgs + 1] = "Command number " .. CmdNum .. " is not a command"
				
				break
				
			end
			
		end
		
	until not CmdStrings[1]
	
	if #Msgs > 0 then
		
		if Silent then
			
			return true, table.concat(Msgs, ",\n")
			
		end
		
		if Executor.UserId ~= "Console" and ChatSpeaker then
			
			ChatSpeaker:SendSystemMessage("You failed to run: " .. Msg, "V-Handle")
			
		end
						
		Main.Util.SendMessage(Executor, table.concat(Msgs, ",\n"), "Warning")
		
		return true
		
	end
	
	if not Silent then
		--------------- TODO Change from Msg to CmdStacks - Make logs/ and such check [3] and [4] for Cmd and StrArgs
		Main.CommandStackRan:Fire(Executor.UserId, Msg, CmdStacks)
	end
	
	local Ran, Message, Legacy = Main.RunCmdStacks(Executor, CmdStacks, Silent)
	if not Silent and Legacy and Executor.UserId ~= "Console" and ChatSpeaker then
		ChatSpeaker:SetExtraData("RanCmd", true)
		ChatSpeaker:SayMessage(Msg, "V-Handle")
	end
	return Ran, Message
end

function Main.Chatted(...)
	
	warn("Main.Chatted deprecated! Use Main.ParseCmdStacks\n" .. debug.traceback())
	
	return Main.ParseCmdStacks(...)
	
end

local HttpEnabled = pcall(function() HttpService:GetAsync("https://www.google.com") end)

function Main.PlayerAdded(Plr, JustUpdated)
	
	if Main.Config.AnnounceJoin and not JustUpdated then
		
		delay(0, function()
			
			if Main.AnnounceJoin[Plr] then
				
				Main.Util.SendMessage(nil, Plr.Name .. " couldn't join because " .. Main.Util.FormatStringTable(Main.AnnounceJoin[Plr]), "Info")
				
				Main.AnnounceJoin[Plr] = nil
				
				return
				
			end
			
			local Plrs = Players:GetPlayers()
			
			for a = 1, #Plrs do
				
				if Plrs[a] == Plr then
					
					local Size = #Plrs
					
					Plrs[a] = Plrs[Size]
					
					Plrs[Size] = nil
					
					break
					
				end
				
			end
			
			Main.Util.SendMessage(Plrs, Plr.Name .. " has joined", "Info")
			
		end)
		
	end
	
	local BanInfo = Main.GetBanStoreMatch(Plr)
	if BanInfo then
		if BanInfo.Banner then
			if Main.Config.AnnounceJoin then
				Main.AnnounceJoin[Plr] = Main.AnnounceJoin[Plr] or {}
				Main.AnnounceJoin[Plr][#Main.AnnounceJoin[Plr] + 1] = "they are banned" .. (type(BanInfo.Reason) == "string" and (" for " .. TextService:FilterStringAsync(BanInfo.Reason, BanInfo.Banner):GetNonChatStringForBroadcastAsync()) or "")
				Main.AnnouncedLeft[Plr] = false
			end
			
			Plr:Kick("You have been banned by " .. Main.Util.UsernameFromID(BanInfo.Banner) .. (type(BanInfo.Reason) == "string" and (" for " .. TextService:FilterStringAsync(BanInfo.Reason, BanInfo.Banner):GetChatForUserAsync(Plr.UserId)) or "") .. (type(BanInfo.Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or ""))
		else
			if Main.Config.AnnounceJoin then
				Main.AnnounceJoin[Plr] = Main.AnnounceJoin[Plr] or {}
				Main.AnnounceJoin[Plr][#Main.AnnounceJoin[Plr] + 1] = "they are banned" .. (type(BanInfo.Reason) == "string" and (" for " .. BanInfo.Reason) or "")
				Main.AnnouncedLeft[Plr] = false
			end
			
			Plr:Kick("You have been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. BanInfo.Reason) or "") .. (type(BanInfo.Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or ""))
		end
	end
	
	if Main.Config.ReservedFor and  #Players:GetPlayers() > Players.MaxPlayers - (Main.Config.ReservedSlots or 1) and not Main.IsDebugger(Plr.UserId) and not Main.TargetLib.MatchesPlr(Main.Config.ReservedFor, Plr) then
		
		if Main.Config.AnnounceJoin then
			
			Main.AnnounceJoin[Plr] = Main.AnnounceJoin[Plr] or {}
			
			Main.AnnounceJoin[Plr][#Main.AnnounceJoin[Plr] + 1] = "max players has been reached"
			
			Main.AnnouncedLeft[Plr] = false
			
		end
		
		Plr:Kick("The server is full, the remaining spaces are reserved")
		
		return
		
	end
	
	local Power = Main.GetUserPowersStoreMatch(Plr)
	if Power then
		Main.SetUserPower(Plr.UserId, Power)
	end
	
	if JustUpdated then
		
		Main.Util.SendMessage(Plr, "Admin has been updated! Say 'changelog/' to see the changes!", "Info")
		
	else
	
		if Main.IsDebugger(Plr.UserId) then
			
			Main.Util.SendMessage(Plr, "You are a debugger!", "Info")
			
		end
		
		if Main.GetUserPower(Plr.UserId) ~= Main.UserPower.user then
			
			Main.Util.SendMessage(Plr, "Your user power is '" .. Main.UserPowerName(Main.GetUserPower(Plr.UserId)) .. "'!", "Info")
			
		end
		
	end
	
	if (Main.GetUserPower(Plr.UserId) ~= Main.UserPower.user or Main.IsDebugger(Plr.UserId)) then
			
		if not HttpEnabled then
			
			Main.Util.SendMessage(Plr, "You must allow HTTP Requests within the Game Settings menu in studio for V-Handle to function correctly.", "Error")
			
		end
		
		if Main.Changelog[2].SetupVersion ~= Main.Config.SetupVersion then
			
			Main.Util.SendMessage(Plr, "A new version of the setup model is available, run help/setup for more information. Make sure the V-Handle Setup Updater plugin is updated.\nCurrent version: " .. Main.Config.SetupVersion .. "\nAvailable version: " .. Main.Changelog[2].SetupVersion, "Warning")
			
		end
		
	end
	
end

----==== Destroy Module ====----

local Destroy, Disconnect = workspace.Destroy, workspace.Changed:Connect(function() end)

Disconnect, _ = Disconnect.Disconnect, Disconnect:Disconnect()

local function EmptyTable(Table)
	for a, b in pairs(Table) do
		local Type = typeof(b)
		if Type == "RBXScriptConnection" then
			b:Disconnect()
		elseif Type == "Instance" then
			b:Destroy()
		elseif Type == "table" then
			EmptyTable(b)
		end
		
		Table[a] = nil
	end
end

local ModuleObjs = {}

function Main.Destroy(Update)
	
	_G.VH_Admin = nil
	
	if Update then
		
		_G.VH_Saved = {}
		
	end
	
	VH_Events.Destroyed:Fire(Update)
	
	if Update then
		Main.CoroutineErrorHandling, Main.ScopedStore = nil, nil
		Main.Config = nil
	end
	
	if #VH_Command_Modules:GetChildren() == 0 then
		
		VH_Command_Modules:Destroy()
		
	end
	
	VH_Events.RemoteDestroyed:FireAllClients(Update)
	
	VH_Events:Destroy()
	
	for a, b in pairs(ModuleObjs) do
		
		if a.Parent == script.Default_Command_Modules then
			
			b:Destroy()
			
		else
			
			b.Name = "Client"
			
			b.Parent = a
			
			for _, Obj in ipairs(b:GetChildren()) do
				
				if Obj:IsA("RemoteEvent") or Obj:IsA("RemoteFunction") or Obj:IsA("BindableEvent") or Obj:IsA("BindableFunction") then
					
					Obj:Clone().Parent = b
					
					Obj:Destroy()
					
				end
				
			end
			
		end
		
	end
	
	VH_Command_Clients:Destroy()
	
	if StarterPlayerScripts:FindFirstChild("VH_Client") then
		
		StarterPlayerScripts.VH_Client:Destroy()
		
	end
	
	VH_Command_Processor:Destroy()
	
	VH_Events = nil
	
	VH_Command_Processor = nil
	
	EmptyTable(Main)
	
	Main = nil
	
	script:Destroy()
	
	if not Update then
		ServerStorage.VH_Ran:Destroy()
		VFolder:Destroy()
	end
end

----==== Update Setup ====----

function Main.GetLatestId(AssetId)
	local Ran, Id = pcall(InsertService.GetLatestAssetVersionAsync, InsertService, AssetId)
	if Ran then
		return Id
	else
		Ran, Id = xpcall(HttpService.GetAsync, Main.CoroutineErrorHandling.ErrorHandler, HttpService, "https://rbxapi.v-handle.com/?type=1&id=" .. AssetId)
		if Ran then
			return tonumber(Id)
		else
			return Id
		end
	end
end

local Ids, LatestId, Latest = {543870197, 571587156}, nil, nil
function Main.GetLatest()
	local Error
	for _, ID in ipairs(Ids) do
		local LatestID = Main.GetLatestId(ID)
		if type(LatestID) == "number" then
			if LatestID == LatestId then
				return Latest
			else
				local Ran, Mod = xpcall(InsertService.LoadAssetVersion, Main.CoroutineErrorHandling.ErrorHandler, InsertService, LatestID)
				if Ran and Mod then
					local ModChild = Mod:GetChildren()[1]
					ModChild.Parent = nil
					Mod:Destroy()
					
					LatestId, Latest = LatestID, ModChild
					
					return Latest
				else
					Error = "Couldn't insert latest version of " .. tostring(ID) .. "\n" .. tostring(Mod)
				end
			end
		else
			Error = "Couldn't get latest version of " .. tostring(ID) .. "\n" .. tostring(LatestID)
		end
	end
	
	return Error
end

----==== Datastore Setup ====----

local Ran, DataStore = pcall(game:GetService("DataStoreService").GetDataStore, game:GetService("DataStoreService"), "Partipixel")

if not Ran or type(DataStore) ~= "userdata" or not pcall(function() DataStore:GetAsync("Test") end) then
	
	DataStore = {GetAsync = function() end, SetAsync = function() end, UpdateAsync = function() end, OnUpdate = function() end}
	
end

Main.DataStore = DataStore

----==== Trello Helper Functions ====----
local function GetCards(Key, Token, Id, Type, Bans)
	local Result = HttpService:RequestAsync{Url = "https://api.trello.com/1/" .. Type .. "/" .. Id .. "/cards?key=" .. Key .. "&token=" .. Token, Method = "GET", Headers = {Accept = "application/json"}}
	if Result.Success then
		Result = HttpService:JSONDecode(Result.Body)
		
		Bans = Bans or {}
		for _, UserData in ipairs(Result) do
			Bans[string.split(UserData.name, " ")[1]] = "Exploiting - " .. UserData.desc
		end
		
		return Bans
	elseif Result.StatusCode == 429 then
		wait(1)
		
		return GetCards(Key, Token, Id, Type, Bans)
	end
end

----==== Ban Setup ====----
Main.BanStore = Main.ScopedStore()

Main.GetBanStoreMatch = function(Plr)
	local Remove = {}
	for PlrString, BanInfo, Scope in Main.BanStore:pairs() do
		local Match
		if Scope ~= "Config" and not Scope:find("Trello") then
			if PlrString == tostring(Plr.UserId) then
				Match = type(BanInfo) ~= "table" and {Reason = BanInfo, Scope = Scope} or BanInfo
			end
		elseif Main.TargetLib.MatchesPlr(PlrString, Plr) then
			Match = type(BanInfo) ~= "table" and {Reason = BanInfo, Scope = Scope} or BanInfo
		end
		
		if Match then
			if type(Match.Time) == "number" then
				if os.time() < Match.Time then
					return Match
				else
					Remove[Scope] = Remove[Scope] or {}
					Remove[Scope][#Remove[Scope] + 1] = PlrString
					if Scope == "DataStore" or Scope == "VIPDataStore" then
						Main.DataStore:UpdateAsync(game.PrivateServerId ~= "" and (game.PrivateServerId .. "VIPBans") or "Bans", function(Value)
							Value = Value or {}
							Value[PlrString] = nil
							return Value
						end)
					end
				end
			else
				return Match
			end
		end
	end
	
	for Scope, List in pairs(Remove) do
		for _, PlrString in ipairs(List) do
			Main.BanStore[Scope][PlrString] = nil
		end
	end
end

Main.BanStore.Config = Main.Config.Banned
Main.BanStore.Local = (_G.VH_Saved or {}).LocalBanStore or {}
VH_Events.Destroyed.Event:Connect(function(Update)
	if Update then
		_G.VH_Saved.LocalBanStore = Main.BanStore.Local
		Main.BanStore.Local = nil
	end
end)

Main.BanStore.DataStore = Main.DataStore:GetAsync("Bans") or {}
Main.Events[#Main.Events + 1] = Main.DataStore:OnUpdate("Bans", function(Value)
	Main.BanStore.DataStore = Value or {}
	
	for _, Plr in ipairs(Players:GetPlayers()) do
		local BanInfo = Main.GetBanStoreMatch(Plr)
		if BanInfo then
			if BanInfo.Banner then
				if Main.Config.AnnounceLeft then
					Main.AnnouncedLeft[Plr] = " has been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. TextService:FilterStringAsync(BanInfo.Reason, BanInfo.Banner):GetNonChatStringForBroadcastAsync()) or "")
				end
				
				Plr:Kick("You have been banned by " .. Main.Util.UsernameFromID(BanInfo.Banner) .. (type(BanInfo.Reason) == "string" and (" for " .. TextService:FilterStringAsync(BanInfo.Reason, BanInfo.Banner):GetChatForUserAsync(Plr.UserId)) or "") .. (type(BanInfo.Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or ""))
			else
				if Main.Config.AnnounceLeft then
					Main.AnnouncedLeft[Plr] = " has been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. BanInfo.Reason) or "")
				end
				
				Plr:Kick("You have been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. BanInfo.Reason) or "") .. (type(BanInfo.Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or ""))
			end
		end
	end
end)

if game.PrivateServerId ~= "" then
	Main.BanStore.VIPDataStore = Main.DataStore:GetAsync(game.PrivateServerId .. "VIPBans") or {}
	Main.Events[#Main.Events + 1] = Main.DataStore:OnUpdate(game.PrivateServerId .. "VIPBans", function(Value)
		Main.BanStore.VIPDataStore = Value or {}
		
		for _, Plr in ipairs(Players:GetPlayers()) do
			local BanInfo = Main.GetBanStoreMatch(Plr)
			if BanInfo then
				if BanInfo.Banner then
					if Main.Config.AnnounceLeft then
						Main.AnnouncedLeft[Plr] = " has been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. TextService:FilterStringAsync(BanInfo.Reason, BanInfo.Banner):GetNonChatStringForBroadcastAsync()) or "")
					end
					
					Plr:Kick("You have been banned by " .. Main.Util.UsernameFromID(BanInfo.Banner) .. (type(BanInfo.Reason) == "string" and (" for " .. TextService:FilterStringAsync(BanInfo.Reason, BanInfo.Banner):GetChatForUserAsync(Plr.UserId)) or "") .. (type(BanInfo.Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or ""))
				else
					if Main.Config.AnnounceLeft then
						Main.AnnouncedLeft[Plr] = " has been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. BanInfo.Reason) or "")
					end
					
					Plr:Kick("You have been banned" .. (type(BanInfo.Reason) == "string" and (" for " .. BanInfo.Reason) or "") .. (type(BanInfo.Time) == "number" and (" - You get unbanned in " .. Main.Util.TimeRemaining(BanInfo.Time)) or ""))
				end
			end
		end
	end)
end

if Main.Config.Trello and Main.Config.Trello.Banned then
	for Name, Trello in pairs(Main.Config.Trello.Banned) do
		Main.BanStore[Name .. " Trello"] = GetCards(Trello.Key, Trello.Token, Trello.Id, Trello.Type)
	end
	
end

----==== UserPower Setup ====----

Main.AdminCache = {}
Main.UserPowersStore = Main.ScopedStore()

Main.GetUserPowersStoreMatch = function(Plr)
	if RunService:IsStudio() or Main.IsOwner(Plr.UserId) then
		return Main.UserPower.owner
	else
		local Override, TargetPower = 0, nil
		for PlrString, PowerString, Scope in Main.UserPowersStore:pairs() do
			local _, Count = PlrString:find("^-*")
			
			local UserPower = Main.UserPowerFromString(PowerString)
			
			if UserPower == Main.UserPower.owner and Scope ~= "Core" then
				warn("VH - Warning - Cannot set players to Owner userpower via config - " .. PlrString)
			end

			if (Count >= Override or UserPower > TargetPower) and UserPower ~= Main.UserPower.owner then
				if Scope ~= "Config" and not Scope:find("Trello") then
					if PlrString == tostring(Plr.UserId) then
						Override, TargetPower = Count, UserPower
					end
				elseif Main.TargetLib.MatchesPlr(PlrString:sub(Count + 1), Plr) then
					Override, TargetPower = Count, UserPower
				end
			end
		end

		if TargetPower then
			return TargetPower
		end
	end
end

Main.UserPowersStore.Core = {}
Main.UserPowersStore.Config = Main.Config.UserPowers
Main.UserPowersStore.Local = (_G.VH_Saved or {}).LocalUserPowersStore or {}
VH_Events.Destroyed.Event:Connect(function(Update)
	if Update then
		_G.VH_Saved.LocalUserPowersStore = Main.UserPowersStore.Local
		Main.UserPowersStore.Local = nil
	end
end)

Main.UserPowersStore.DataStore = Main.DataStore:GetAsync("UserPowers") or {}
Main.Events[#Main.Events + 1] = Main.DataStore:OnUpdate("UserPowers", function(Value)
	Main.UserPowersStore.DataStore = Value or {}
	
	for _, Plr in ipairs(Players:GetPlayers()) do
		local CurPower = Main.GetUserPower(Plr.UserId)
		local Power = Main.GetUserPowersStoreMatch(Plr)
		if CurPower ~= Power then
			Main.SetUserPower(Plr.UserId, Power)
			Main.Util.SendMessage(Plr, "Your user power has been updated to '" .. Main.UserPowerName(Power) .. "'!", "Info")
		end
	end
end)

if game.PrivateServerId ~= "" then
	Main.UserPowersStore.VIPDataStore = Main.DataStore:GetAsync(game.PrivateServerId .. "VIPUserPowers") or {}
	Main.Events[#Main.Events + 1] = Main.DataStore:OnUpdate(game.PrivateServerId .. "VIPUserPowers", function(Value)
		Main.UserPowersStore.VIPDataStore = Value or {}

		for _, Plr in ipairs(Players:GetPlayers()) do
			local CurPower = Main.GetUserPower(Plr.UserId)
			local Power = Main.GetUserPowersStoreMatch(Plr)
			if CurPower ~= Power then
				Main.SetUserPower(Plr.UserId, Power)
				Main.Util.SendMessage(Plr, "Your user power has been updated to '" .. Main.UserPowerName(Power) .. "'!", "Info")
			end
		end
	end)
end

if Main.Config.Trello and Main.Config.Trello.UserPowers then
	for Name, Trello in pairs(Main.Config.Trello.UserPowers) do
		Main.UserPowersStore[Name .. " Trello"] = GetCards(Trello.Key, Trello.Token, Trello.Id, Trello.Type)
	end
end

local UserPowerCache = {}

Main.UserPower = setmetatable({}, {__newindex = function(self, Key, Value)
	if rawget(self, Key) then
		UserPowerCache[rawget(self, Key)] = nil
	end
	
	if Value then
		UserPowerCache[Value] = Key:lower()
	end
	
	rawset(self, Key:lower(), Value)
end})

Main.UserPower.console, Main.UserPower.owner, Main.UserPower.superadmin, Main.UserPower.admin, Main.UserPower.supermod, Main.UserPower.supermoderator, Main.UserPower.mod, Main.UserPower.moderator, Main.UserPower.user = 100, 80, 70, 60, 40, 40, 20, 20, 0

function Main.UserPowerName(UserPowerNum)
	return UserPowerCache[UserPowerNum] or "user"
end

function Main.UserPowerFromString(String)
	return Main.UserPower[String:lower()] or (UserPowerCache[tonumber(String)] and tonumber(String))
end

----==== Player UserPowers ====----

function Main.GetUserPower(UserId)
	if UserId == "Console" then
		return Main.UserPower.console
	else
		return Main.AdminCache[tostring(UserId)] or Main.UserPower.user
	end
end

function Main.SetUserPower(UserId, UserPower)
	Main.AdminCache[tostring(UserId)] = UserPower
end

local Debuggers = {
	[16015142] = true, -- Partixel
	[1197489529] = true, -- Phonaxial
	[45858958] = true, -- CodeNil
	[4354334] = true, -- Antonio
	[7731089] = true, -- Peekay
	[16459694] = true, -- DrDrRoblox
	[14827891] = true, -- Nawmis
}

Main.Events[#Main.Events + 1] = Players.PlayerRemoving:Connect(function(Plr)
	if not Debuggers[Plr.UserId] then
		Debuggers[Plr.UserId] = nil
	end
end)

function Main.IsOwner(UserId)
	local Ran, Result = pcall(function()
		return HttpService:GetAsync("https://rbxapi.v-handle.com/?type=2&userid=" .. UserId .. "&placeid=" .. game.PlaceId, true)
	end)
	if Ran and type(Result) == "string" then
		Ran, Result = pcall(function() return HttpService:JSONDecode(Result) end)
		if Ran then
			Debuggers[UserId] = Result.CanManage
			return Result.CanManage
		end
	end
end

function Main.IsDebugger(UserId)
	if RunService:IsStudio() or UserId == "Console" then
		return true
	elseif Debuggers[UserId] ~= nil then
		return Debuggers[UserId]
	else
		return Main.IsOwner(UserId)
	end
end

----==== UserPower Targetting (Name or Number) ====----

table.insert(Main.TargetLib.MatchFuncs, #Main.TargetLib.MatchFuncs - 1, function(self,  String, Plr, Matches, Base)
	
	String = String:lower()
	
	if String:sub(1, 1) ~= "$" then return end
	 
	String = String:sub(2)
	
	String = String:match('^%s*(.*%S)') or ""
	
	local Type, UserPowerNum = String:match("^([><=]*)(.+)")
	
	local UserPowerNum = Main.UserPowerFromString(UserPowerNum)
	
	if not UserPowerNum then
		
		if Type == "" then
			
			if String:find("debug") then
				
				local Found = {}
				
				for _, Target in ipairs(Players:GetPlayers()) do
					
					if Main.IsDebugger(Target.UserId) then
						
						Found[#Found + 1] = Target
						
					end
					
				end
				
				return true, Found
				
			end
			
		else
			
			return
			
		end
		
	else
		
		Type = Type == "=" and 1 or Type == "<" and 2 or nil
		
		local Found = {}
		
		for _, Target in ipairs(Players:GetPlayers()) do
			
			if (Type == 1 and Main.GetUserPower(Target.UserId) == UserPowerNum) or (Type == 2 and Main.GetUserPower(Target.UserId) <= UserPowerNum) or (Type == nil and Main.GetUserPower(Target.UserId) >= UserPowerNum) then
				
				Found[#Found + 1] = Target
				
			end
			
		end
		
		return true, Found
		
	end
	
end)

Main.TargetLib.ArgTypes.PowerNumber = function(self, Strings, Plr)
	
	local String = table.remove(Strings, 1)
	
	if String == Main.TargetLib.ValidChar then return self[2] and self[2].Default or 10 end
	
	local UserPowerNum = Main.UserPowerFromString(String)
	
	if not UserPowerNum then return nil, false end
	
	return UserPowerNum
	
end
	
Main.TargetLib.ArgTypes.Power = function(self, Strings, Plr)
	
	local String = table.remove(Strings, 1)
	
	if String == Main.TargetLib.ValidChar then return self[2] and self[2].Default or "user" end
	
	local UserPower = Main.UserPowerName(Main.UserPowerFromString(String))
	
	if not UserPower then return nil, false end
	
	return UserPower
	
end

Main.TargetLib.ArgTypeNames.PowerNumber = "power"

----==== UserPower Defaults ====----

if game.CreatorType == Enum.CreatorType.User or game.CreatorId == 0 then
	Main.UserPowersStore.Core[tostring(game.CreatorId)] = "owner"
else
	local GroupInfo = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)
	if GroupInfo.Owner then
		Main.UserPowersStore.Core[tostring(GroupInfo.Owner.Id)] = "owner"
	end
end

----==== OwnerType Targetting ====----

table.insert(Main.TargetLib.MatchFuncs, #Main.TargetLib.MatchFuncs - 1, function(self, String, Plr)
	if String:sub(1, 1) == ">" then
		String = String:lower():sub(2):match('^%s*(.*%S)') or ""
		
		if String == "creator" or String == "vip" then
			local Plrs = {}
			for _, Player in ipairs(Players:GetPlayers()) do
				if (String == "creator" and Main.GetUserPower(Player.UserId) == Main.UserPower.owner) or (String == "vip" and Player.UserId == game.PrivateServerOwnerId) then
					Plrs[#Plrs + 1] = Player
				end
			end
			return true, Plrs
		end
	end
end)

----==== Commands Setup ====----

local CmdOptions = {
	
	Alias = {function(Obj)
		
		if type(Obj) == "table" and #Obj > 0 then
			
			for a, b in pairs(Obj) do
				
				if type(b) == "table" then
					
					if type(b[1]) == "function" then
						
						if type(b[2]) ~= "string" then
							
							return
							
						end
						
					else
						
						if not b.Args then return end
						
						for _, c in ipairs(b) do
							
							if type(c) ~= "string" then
								
								return
								
							end
							
						end
						
					end
					
				elseif type(b) ~= "string" then
					
					return
					
				end
				
			end
			
			return true
			
		end
		
	end},
	
	Description = {"string"},
	
	Category = {"string"},
	
	CanRun = {function(Obj) return Obj == nil or type(Obj) == "string" end},
	
	ArgTypes = {function(Obj)
		
		if Obj == nil then return true end
		
		for _, v in ipairs(Obj) do
			
			if type(v) == "table" and (v.Func == nil or v[1] or v[2]) then return end
			
		end
		
		return true
		
	end},
	
	Callback = {"function"},
	
	Options = {"table", "nil"},
	
	Config = {"table", "nil"},
	
	NoTest = {"boolean", "nil"},
	
	NoRepeat = {"boolean", "nil"}
	
}

local AliasCmdOptions = {
	
	Alias = {function(Obj)
		
		if type(Obj) == "table" and #Obj > 0 then
			
			for a, b in pairs(Obj) do
				
				if type(b) == "table" then
					
					if type(b[1]) == "function" then
						
						if type(b[2]) ~= "string" then
							
							return
							
						end
						
					else
						
						if not b.Args then  return end
						
						for c = 1, #b do
							
							if type(b[c]) ~= "string" then
								
								return
								
							end
							
						end
						
					end
					
				elseif type(b) ~= "string" then
					
					return
					
				end
				
			end
			
			return true
			
		end
		
	end},
	
	Description = {"string"},
	
	Category = {"string"},
	
	Commands = {function(Obj)
		
		if type(Obj) == "table" then
			
			for a = 1, #Obj do
				
				if type(Obj[a]) ~= "table" then return end
				
			end
			
			return true
			
		end
		
	end},
	
	ArgTypes = {function(Obj)
		
		if Obj == nil then return true end
		
		for a = 1, #Obj do
			
			if type(Obj[a]) == "table" and (Obj[a].Func == nil or Obj[a][1] or Obj[a][2]) then return end
			
		end
		
		return true
		
	end},
	
	NoTest = {"boolean", "nil"},
	
	NoRepeat = {"boolean", "nil"},
	
}

function CheckType(Obj, Types)
	
	for a = 1, #Types do
		
		if type(Types[a]) == "table" then
			
			if type(Obj) == "table" then
				
				for b, c in pairs(Obj) do
					
					local Valid = CheckType(c, Types[a])
					
					if not Valid then return end
					
				end
				
				return true
				
			end
			
		elseif type(Types[a]) == "function" then
			
			local Valid = Types[a](Obj)
			
			if Valid then return true end
			
		elseif type(Obj) == Types[a] then
			
			return true
			
		end
		
	end
	
end

local AliasCache, AliasFunctions = {}, {}

local function Metatable(self, Key, Value)
	
	local Mod = getfenv(2)
	
	local ModName = Mod and Mod.script and Mod.script:GetFullName()
	
	if Main.Config.CommandOptions and Main.Config.CommandOptions[Key] then
		for a, b in pairs(Main.Config.CommandOptions[Key]) do
			if a ~= "Overrides" then
				Value[a] = b
			end
		end
		
		if Main.Config.CommandOptions[Key].Overrides then
			for _, Func in ipairs(Main.Config.CommandOptions[Key]) do
				Func(Value)
			end
		end
	end
	
	local Options = Value.Commands and AliasCmdOptions or CmdOptions
	
	for a, b in pairs(Options) do
		
		local Valid = CheckType(Value[a], b)
		
		if not Valid then
			
			warn(ModName .. ":" .. Key .. ":" .. a .. " is invalid")
			
			return
			
		end
		
	end
	
	for a, b in pairs(Value) do
		
		if not Options[a] then warn(ModName .. ":" .. Key .. ":" .. a .. " is not a Command Option") end
		
	end
	
	for a = 1, #Value.Alias do
		
		if type(Value.Alias[a]) == "string" and Value.Alias[a]:find(" ") then
			
			SpaceCmds[#SpaceCmds + 1] = Value.Alias[a]
			
		end
		
	end
	
	for a = 1, #Value.Alias do
		
		if type(Value.Alias[a]) == "table" then
			--TODO MAKE ERROR
			if AliasCache[Value.Alias[a][1]] then warn(Key .. ": Alias " .. Value.Alias[a][2] .. " is already used") end
			
			if type(Value.Alias[a][1]) == "function" then
				
				AliasFunctions[Value.Alias[a][1]] = Value
				
				AliasCache[Value.Alias[a][1]] = Value
				
			else
				
				for b = 1, #Value.Alias[a] do
					
					AliasCache[Value.Alias[a][b]] = {Value, Value.Alias[a].Args}
					
				end
				
			end
			
		else
			--TODO MAKE ERROR
			if AliasCache[Value.Alias[a]] then warn(Key .. ": Alias " .. Value.Alias[a] .. " is already used") end
			
			AliasCache[Value.Alias[a]] = Value
			
		end
		
	end
	
	if Value.Config then
		
		for a, b in pairs(Value.Config) do
			
			if not Main.Config[a] then
				
				Main.Config[a] = b
				
			end
			
		end

	end
	
	if ModName and Mod.script.Parent ~= script.Default_Command_Modules and Mod.script ~= VH_Command_Processor then
		
		print(ModName .. ":" .. Key .. " added")
		
	end
	
	Value.Name = Key
	
	rawset(self, Key, Value)
	
end

function Main.GetUsage(Executor, Cmd)
	
	local CmdObj, Args = Main.GetCommandAndArgs(Cmd, Executor)
	
	local Str = ""
	
	if not CmdObj.ArgTypes or #CmdObj.ArgTypes == 0 then
		
		Str = Str .. "/"
		
	else
		
		for a = 1, #CmdObj.ArgTypes do
			
			if not Args or not Args[a] then
				
				local Prefix, Suffix = "[/", "]"
				
				repeat
					
					if type(CmdObj.ArgTypes[a]) == "table" then
						
						if CmdObj.ArgTypes[a].Required then
							
							Prefix, Suffix = "/<", ">"
							
						end
						
						if CmdObj.ArgTypes[a].Name then
							
							Str = Str .. Prefix .. CmdObj.ArgTypes[a].Name .. Suffix
							
							break
							
						end
						
					end
					
					local Type = Main.TargetLib.GetArgType(type(CmdObj.ArgTypes[a]) == "function" and CmdObj.ArgTypes[a] or CmdObj.ArgTypes[a].Func)
					
					Type = (Main.TargetLib.ArgTypeNames[Type] or Type or "string"):lower()
					
					Str = Str .. Prefix .. Type .. Suffix
					
				until true
				
			end
			
		end
		
	end
	
	return Str
	
end

function Main.GetCommandAndArgs(Key, Plr)
	
	local Value = AliasCache[Key]
	
	if Value then
		
		if Value[1] then
			
			return Value[1], Main.Util.TableDeepCopy(Value[2])
			
		else
			
			return Value
			
		end
		
	end
	
	if type(Key) ~= "string" then return end
	
	for a, b in pairs(AliasFunctions) do
		
		local Args = {a(b, Key, Plr)}
		
		if Args[1] then
			
			return b, unpack(Args, 2)
			
		end
		
	end
	
end

Main.Commands = setmetatable({}, {__metatable = "protected", __newindex = Metatable})


----==== Command Modules ====----

_G.VH_Admin = Main

VH_Command_Modules = ServerStorage:FindFirstChild("VH_Command_Modules")

if not VH_Command_Modules then
	
	VH_Command_Modules = Instance.new("Folder")
	
	VH_Command_Modules.Name = "VH_Command_Modules"
	
	VH_Command_Modules.Parent = ServerStorage
	
end

VH_Command_Clients = VFolder:FindFirstChild("VH_Command_Clients")

if not VH_Command_Clients then
	
	VH_Command_Clients = Instance.new("Folder")
	
	VH_Command_Clients.Name = "VH_Command_Clients"
	
	VH_Command_Clients.Parent = VFolder
	
end

local Loaded = {}

local Loading = {}

local function RequireModule(Mod, Required, LoopReq)
	if Mod:IsA("Folder") then
		
		for _, Obj in ipairs(Mod:GetChildren()) do
			
			RequireModule(Obj, Required, LoopReq)
			
		end
		
		return
		
	end
	
	if Loading[Mod] then
		
		while Loading[Mod] do Main.ModuleLoaded.Event:Wait() end
		
		return Loaded[Mod]
		
	end
	
	if Loaded[Mod] then
		
		return Loaded[Mod]
		
	end
	
	if (not Main.Config.DisabledCommandModules[Mod.Name] or Required) then
		
		Loading[Mod] = true
		
		LoopReq = LoopReq or {}
		
		LoopReq[Mod] = true
		
		if Mod:FindFirstChild("Required") then
			
			local Required = Mod.Required:GetChildren()
			
			for a = 1, #Required do
				
				local ReqMod = script.Default_Command_Modules:FindFirstChild(Required[a].Name) or VH_Command_Modules:FindFirstChild(Required[a].Name)
				
				local Start = tick()
				
				while not ReqMod and wait() do
					
					if Start and tick() - Start > 5 then
						
						Start = nil
						
						warn(Mod.Name .. " requires a module that took too long to be found - " .. Required[a]:GetFullName())
						
						return false
						
					end
					
					ReqMod = script.Default_Command_Modules:FindFirstChild(Required[a].Name) or VH_Command_Modules:FindFirstChild(Required[a].Name)
					
				end
				
				if LoopReq[ReqMod] then
					
					Loading[Mod] = false
					
					return false, true
					
				end
				
				Start = tick()
				
				while Loading[ReqMod] do
					
					Main.ModuleLoaded.Event:Wait()
					
				end
				
				if Loading[ReqMod] == false then
					
					warn(Mod.Name .. " failed to load due to an error loading " .. Required[a].Name)
					
					Loading[Mod] = false
					
					return false
					
				end
				
				if not Loaded[ReqMod] then
					
					local Ran, Loop = RequireModule(ReqMod, true, LoopReq)
					
					if Ran == false then
						
						if Loop then
							
							Loading[Mod] = false
							
							warn("Required loop - " .. Mod.Name .. " and " .. Required[a].Name)
							
						end
						
						return false
						
					end
					
				end
				
			end
			
		end
		
		if Mod:FindFirstChild("Translations") then
			local Ran, Translations = xpcall(require, Main.CoroutineErrorHandling.ErrorHandler, Mod.Translations)
			if Ran then
				local Ran, Error = xpcall(Translations.RobloxLocalizationTable and Main.ExtendedTranslations.ImportRobloxLocalizationTable or Main.ExtendedTranslations.ImportLocalizationTable, Main.CoroutineErrorHandling.ErrorHandler, Translations)
				if not Ran then
					warn(Mod.Name .. " failed to load due to an error in its translation table:\n" .. Error)
				
					Loading[Mod] = false
					return false
				end
			else
				warn(Mod.Name .. " failed to load due to an error in its translation table:\n" .. Translations)
				
				Loading[Mod] = false
				return false
			end
		end
		
		local CommandClient
		if Mod:FindFirstChild("Client") then
			local Events = Mod:GetChildren()
			for a = 1, #Events do
				if Events[a]:IsA("RemoteEvent") or Events[a]:IsA("RemoteFunction") then
					Events[a].Parent = Mod.Client
				end
			end
			
			CommandClient = Mod.Client
			CommandClient.Name = "VH_" .. Mod.Name
			if Mod:FindFirstChild("Translations") then
				Mod.Translations.Parent = CommandClient
			end
			CommandClient.Parent = VH_Command_Clients
			
			ModuleObjs[Mod] = CommandClient
		elseif Mod:FindFirstChild("Translations") then
			CommandClient = Instance.new("Folder")
			CommandClient.Name = "VH_" .. Mod.Name
			if Mod:FindFirstChild("Translations") then
				Mod.Translations.Parent = CommandClient
			end
			CommandClient.Parent = VH_Command_Clients
			
			ModuleObjs[Mod] = CommandClient
		end
		
		local Ran, Error = xpcall(function() require(Mod)(Main, CommandClient, VH_Events) end, Main.CoroutineErrorHandling.ErrorHandler)
		
		if not Ran then
			
			warn(Mod.Name .. " errored when required:\n" .. Error)
			
			if CommandClient then
				
				CommandClient:Destroy()
				
			end
			
			Loading[Mod] = false
			
			return false
			
		end
		
		Loading[Mod] = nil
		
		Loaded[Mod] = Ran
		
		Main.ModuleLoaded:Fire(Mod)
		
	end
	
end

local Required = {[script.Default_Command_Modules.Core] = true, [script.Default_Command_Modules.Util] = true}
for _, Module in ipairs(script.Default_Command_Modules:GetChildren()) do
	if Required[Module] or not VH_Command_Modules:FindFirstChild(Module.Name) then
		Main.CoroutineErrorHandling.CoroutineWithStack(RequireModule, Module, Required[Module])
	end
end

Main.Events[#Main.Events + 1] = VH_Command_Modules.ChildAdded:Connect(RequireModule)
for _, Module in ipairs(VH_Command_Modules:GetChildren()) do
	Main.CoroutineErrorHandling.CoroutineWithStack(RequireModule, Module)
end

----==== External Commands ====----
--[[if _G.VH_AddExternalCmds then
	_G.VH_AddExternalCmds(VH_Func)
else
	_G.VH_AddExternalCmdsQueue = _G.VH_AddExternalCmdsQueue or {}
	_G.VH_AddExternalCmdsQueue[script] = VH_Func
end]]--

local VH_ExternalCmds = (_G.VH_Saved or {}).VH_ExternalCmds or {}

VH_Events.Destroyed.Event:Connect(function(Update)
	if Update then
		_G.VH_Saved.VH_ExternalCmds = VH_ExternalCmds
	end
end)

function _G.VH_AddExternalCmds(Func)
	VH_ExternalCmds[#VH_ExternalCmds + 1] = Func
	
	Func(Main)
	
	return #VH_ExternalCmds
end

function _G.VH_RemoveExternalCmds(Key)
	local Size = #_G.VH_ExternalCmds
	_G.VH_ExternalCmds[Key] = _G.VH_ExternalCmds[Size]
	_G.VH_ExternalCmds[Size] = nil
end

for a = 1, #VH_ExternalCmds do
	Main.CoroutineErrorHandling.CoroutineWithStack(VH_ExternalCmds[a], Main)
end

if _G.VH_AddExternalCmdsQueue then
	for _, Func in pairs(_G.VH_AddExternalCmdsQueue) do
		_G.VH_AddExternalCmds(Func)
	end
	_G.VH_AddExternalCmdsQueue = nil
end

----==== Async looped threads ====----

Main.CoroutineErrorHandling.CoroutineWithStack(function()
	while script.Parent do
		script.AncestryChanged:Wait()
	end

	if Main then 
		Main.Destroy()
	end
end)

Main.CoroutineErrorHandling.CoroutineWithStack(function()
	local CurVersion = Main.GetLatestId(571587156) or Main.GetLatestId(543870197)
	while wait(math.min(math.max(30, Main.Config.UpdatePeriod or 60), 1800)) and Main do
		local LatestVersion = Main.GetLatestId(571587156) or Main.GetLatestId(543870197)
		if tonumber(Latest) and CurVersion ~= LatestVersion then
			Main.Commands.Update:Callback()
			break
		end
	end
end)

----==== Events & Client ====----

VH_Events.RunCommand.OnServerInvoke = Main.ParseCmdStacks

VH_Events.RunCmdStacks.OnServerInvoke = Main.RunCmdStacks

while not Main.Util do Main.ModuleLoaded.Event:Wait() end

Main.Events[#Main.Events + 1] = Players.PlayerAdded:Connect(Main.PlayerAdded)

for _, Plr in ipairs(Players:GetPlayers()) do
	
	Main.PlayerAdded(Plr, Updated)
	
end

LoaderModule(script:WaitForChild("StarterPlayerScripts"))

Main.Events[#Main.Events + 1] = Players.PlayerRemoving:Connect(function(Plr)
	
	if Main.Config.AnnounceLeft then
		
		if Main.AnnouncedLeft[Plr] ~= false then
			
			Main.Util.SendMessage(nil, Plr.Name .. (Main.AnnouncedLeft[Plr] or " has left"), "Info")
			
		end
		
		Main.AnnouncedLeft[Plr] = nil
		
	end
	
end)

Main.TargetLib.Toggles = (_G.VH_Saved or {}).TL_Toggles or Main.TargetLib.Toggles

VH_Events.Destroyed.Event:Connect(function(Update)
	
	if not Update then return end
	
	_G.VH_Saved.TL_Toggles = Main.TargetLib.Toggles
	
end)

----==== Cleanup saved variables ====----

_G.VH_Saved = nil

return Main