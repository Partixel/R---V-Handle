local ScopedStoreMeta = {
	["pairs"] = function(self)
		local CurTable, Key, Value = next(self), nil, nil
		local Table = self[CurTable]
		return function()
			repeat
				Key, Value = next(Table, Key)
				if Key == nil then
					CurTable = next(self, CurTable)
					Table = self[CurTable]
				end
			until Key ~= nil or not Table

			return Key, Value, CurTable
		end
	end,
	["__newindex"] = function(self, Key, Value)
		assert(Key ~= "pairs", "Cannot set the value of 'pairs' in ScopedStores")
		rawset(self, Key, Value)
	end,
}
ScopedStoreMeta.__index = ScopedStoreMeta

return function()
	local self = setmetatable({}, ScopedStoreMeta)
	return self
end