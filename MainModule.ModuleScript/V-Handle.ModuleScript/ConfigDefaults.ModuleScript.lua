return {
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
	{
		"Trello",
		{},
		[[Add tables into either a "Banned" or "UserPowers" sub table to allow fetching bans/userpowers from trello
Example:
Trello = {
	Banned = {
		Exploiters = {
			Key = "Your Trello Key",
			Token = "Your Trello Token",
			Id = "Your Trello List or Board Id",
			Type = 'lists' or 'boards' depending on the above,
	},
},]]
	},

	
	
	SetupVersion = "2.1.0",
}