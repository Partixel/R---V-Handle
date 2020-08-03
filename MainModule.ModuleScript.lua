return {
	Get = function()
		return script:WaitForChild("V-Handle")
	end,
	Run = function(self)
		return require(self:Get())
	end,
}