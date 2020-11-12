return {
	--[[If true the admin will print when a player joins to the chat]]
	AnnounceJoin = true, -- Default - true
	
	--[[If true the admin will print when a player leaves to the chat]]
	AnnounceLeft = true, -- Default - true
	
	--[[How often the admin checks for updates in seconds ( Must be at least 30 and at most 1800 )]]
	UpdatePeriod = 60, -- Default - 60
	
	--[[Override properties of commands like CanRun or Category
	--Examples--
	Config.CommandOptions = { Kill = { CanRun = "all" } } - Allows everyone to use the Kill command]]
	CommandOptions = { }, -- Default - { }
	
	--[[Preceed users with "-" to override any other ranks they are given with the specified ran ( More minuses means higher priority )
	e.g. [ "-partixel" ] = "user" - will force Partixel to have the rank "user" even if other UserPowers match him
	--Examples--
	Config.UserPowers = { ["1234"] = "admin" } - This gives admin to the player with a userid equal to "1234"
	Config.UserPowers = { ["^4321^50"] = "admin" } - This gives admin to anyone in the group "4321" and have a rank above "50"
	Config.UserPowers = { ["^4321&!^1234^12"] = "admin" } - This gives admin to anyone in the group "4321" and don't have a rank of 12 or above in the group "1234"]]
	UserPowers = {}, -- Default - { }
	
	--[[Players matching a string on this list is prevented from joining the game with the reason being the value or a default message if true
	--Examples--
	Config.Banned = { ["partixel"] = true }
	Config.Banned = { ["1234"] = "Hacking", ["^1059575"] = "Bad group" }]]
	Banned = {}, -- Default - { }
	
	--[[If true the specified command module will not load
	Use this if you don't want commands from said command module ( e.g. if you don't want 'Fun' commands do [ "VH_Fun" ] = true]]
	DisabledCommandModules = { 
		
		VH_Fun = false,
		
		VH_Main = false,
		
	}, -- Default - { VH_Fun = false, VH_Main = false, }
	
	Trello = {},
	
	SetupVersion = "2.1.0", -- DO NOT CHANGE THIS
}