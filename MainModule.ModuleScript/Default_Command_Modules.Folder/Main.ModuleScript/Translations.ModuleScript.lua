return {
	RobloxLocalizationTable = true,
	{
		Key = "KillSuccess",
		Source = "{Adjective:set:killed}{PlayerSucceeded:lookup}",
		Values = {
		},
	},
	{
		Key = "KillPartiallyFailed",
		Source = "{PartiallyFailedMissingCharacter:lookup}",
		Values = {
		},
	},
	{
		Key = "KillFailed",
		Source = "{FailedMissingCharacter:lookup}",
		Values = {
		},
	},
	{
		Key = "RespawnSuccess",
		Source = "{Adjective:set:respawned}{PlayerSucceeded:lookup}",
		Values = {
		},
	},
	{
		Key = "HealSuccess",
		Source = "{Adjective:set:healed}{PlayerSucceeded:lookup}",
		Values = {
		},
	},
	{
		Key = "HealPartiallyFailed",
		Source = "{PartiallyFailedMissingCharacter:lookup}",
		Values = {
		},
	},
	{
		Key = "HealFailed",
		Source = "{FailedMissingCharacter:lookup}",
		Values = {
		},
	},
	{
		Key = "Blinded",
		Source = "blinded",
		Values = {
		},
	},
	{
		Key = "Unblinded",
		Source = "unblinded",
		Values = {
		},
	},
	{
		Key = "BlindSuccess",
		Source = "{Adjective:set:{Blind:if:Blinded?Unblinded}}{PlayerSucceeded:lookup}",
		Values = {
		},
	},
	{
		Key = "BlindPartiallyFailed",
		Source = "{PlayerPartiallyFailed:lookup} are already {Blind:if:Blinded?Unblinded}",
		Values = {
		},
	},
	{
		Key = "BlindFailed",
		Source = "{GenericFailed:lookup} are already {Blind:if:Blinded?Unblinded}",
		Values = {
		},
	},
	{
		Key = "JumpPowerSuccess",
		Source = "{Adjective:set:JumpPowered}{PlayerSetValueSucceeded:lookup}",
		Values = {
		},
	},
	{
		Key = "JumpPowerPartiallyFailed",
		Source = "{PartiallyFailedMissingCharacter:lookup}",
		Values = {
		},
	},
	{
		Key = "JumpPowerFailed",
		Source = "{FailedMissingCharacter:lookup}",
		Values = {
		},
	},
}