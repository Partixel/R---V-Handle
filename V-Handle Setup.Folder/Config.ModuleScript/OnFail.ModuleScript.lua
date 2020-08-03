local Players, InsertService = game:GetService("Players"), game:GetService("InsertService")

local Hint = Instance.new("Hint", workspace)
Hint.Text = "Admin failed to load, reverting to emergency functions - Say update/ to attempt a fix"

function GetLatestId(AssetId)
	local Ran, Id = pcall(InsertService.GetLatestAssetVersionAsync, InsertService, AssetId)
	if Ran then
		return Id
	else
		Ran, Id = pcall(game.HttpService.GetAsync, game.HttpService, "https://rbxapi.v-handle.com/?type=1&id=" .. AssetId)
		if Ran then
			return tonumber(Id)
		else
			return Id
		end
	end
end

local Ids = {543870197, 571587156}
function GetLatest()
	local Error
	for _, ID in ipairs(Ids) do
		local LatestID = GetLatestId(ID)
		if type(LatestID) == "number" then
			local Ran, Mod = pcall(InsertService.LoadAssetVersion, InsertService, LatestID)
			if Ran and Mod then
				local ModChild = Mod:GetChildren()[1]
				ModChild.Parent = nil
				Mod:Destroy()
				
				return ModChild
			else
				Error = "Couldn't insert latest version of " .. ID .. "\n" .. Mod
			end
		else
			Error = "Couldn't get latest version of " .. ID .. "\n" .. LatestID
		end
	end
	
	return Error
end

local Events = {}
local Updated = false
local function Update()
	local NewMain = GetLatest()
	if not NewMain or type(NewMain) == "string" then return end
	
	if pcall(function() require(NewMain) end) then
		Updated = true
		
		for _, Event in ipairs(Events) do
			Event:Disconnect()
		end
		
		Hint:Destroy()
	end
end

coroutine.wrap(function()
	while not Updated and wait(30) do
		Update()
	end
end)()

function Chatted(Msg, Plr)
	if Msg == "shutdown/" then
		Players.PlayerAdded:Connect(function(Plr) Plr:Kick("Shutdown") end)
		
		for _, Plr in ipairs(Players:GetPlayers()) do
			Plr:Kick("Shutdown")
		end
	elseif Msg == "update/" then
		Update()
	end
end

Events[#Events + 1] = Players.PlayerAdded:Connect(function(Plr)
	Events[#Events + 1] = Plr.Chatted:Connect(function(Msg)
		Chatted(Msg, Plr)
	end)
end)

for _, Plr in ipairs(Players:GetPlayers()) do
	Events[#Events + 1] = Plr.Chatted:Connect(function(Msg)
		Chatted(Msg, Plr)
	end)
end

return nil