local ExtendedTranslations; ExtendedTranslations = {
	Translations = {},
	FormatTypes = {
		lookup = function(LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			assert(Circular[MatchKey] ~= true, "Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. ":" .. MatchType .. "' is attempting a circular lookup")
			
			if Circular and Circular[MatchKey] then
				return Circular[MatchKey]
			else
				Circular[Key] = true
				Circular[Key] = ExtendedTranslations.Translate(LocaleId, MatchKey, Args, Circular)
				return Circular[Key]
			end
		end,
		translate = function(LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			assert(Circular[MatchKey] ~= true, "Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. ":" .. MatchType .. "' is attempting a circular translate")
			assert(Args[MatchKey], "Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. "' is missing for translation argument '" .. MatchKey .. ":" .. MatchType .. "'")
			
			if Circular and Circular[Args[MatchKey]] then
				return Circular[Args[MatchKey]]
			else
				Circular[Key] = true
				Circular[Key] = ExtendedTranslations.Translate(LocaleId, Args[MatchKey], Args, Circular)
				return Circular[Key]
			end
		end,
		format = function(LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			assert(Args[MatchKey], "Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. "' is missing for " .. MatchType .. " argument '" .. MatchKey .. ":" .. MatchType .. "'")
			assert(Option ~= "", "Couldn't translate key '" .. Key .. "' because the format is missing for " .. MatchType .. " argument '" .. MatchKey .. ":" .. MatchType .. "'")
			
			return Option:format(Args[MatchKey])
		end,
		set = function(LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			Args[MatchKey] = Option
			return ""
		end,
		["if"] = function(LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			assert(Option ~= "", "Couldn't translate key '" .. Key .. "' because the result keys are missing for " .. MatchType .. " argument '" .. MatchKey .. ":" .. MatchType .. "' (Key:if:ResultTrueKey?ResultFalseKey)")
			
			local Split = Option:split("?")
			
			assert(#Split == 2, "Couldn't translate key '" .. Key .. "' because the false result is missing for " .. MatchType .. " argument '" .. MatchKey .. ":" .. MatchType .. "' (Key:if:ResultTrueKey?ResultFalseKey)")
			
			local ResultKey = Args[MatchKey] and Split[1] or Split[2]
			if ResultKey == "" then
				return ResultKey
			elseif Circular[MatchKey] ~= true then
				if Circular and Circular[MatchKey] then
					return Circular[MatchKey]
				else
					Circular[Key] = true
					Circular[Key] = ExtendedTranslations.Translate(LocaleId, ResultKey, Args, Circular)
					return Circular[Key]
				end
			else
				error("Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. ":" .. MatchType .. "' is attempting a circular lookup")
			end
		end,
	},
	Translate = function(LocaleId, Key, Args, Circular, KeyIsTranslation)
		local Translation = ExtendedTranslations.Translations[Key]
		
		assert(KeyIsTranslation or Translation, "Couldn't translate key '" .. tostring(Key) .. "' because no translations exist")
		assert(KeyIsTranslation or LocaleId == "en-us" or Translation.Values, "Couldn't translate key '" .. Key .. "' because translation doesn't exist for '" .. LocaleId .. "'")
		
		Translation = KeyIsTranslation and Key or LocaleId == "en-us" and Translation.Source or Translation.Values[LocaleId]
		
		assert(Translation, "Couldn't translate key '" .. Key .. "' because translation doesn't exist for '" .. LocaleId .. "'")
		
		Circular = Circular or {}
		Translation = (Translation:gsub("%b{}", function(MatchKey)
			local MatchKey, MatchType, Option = MatchKey:sub(2, -2):match("(%w*):?([%w]*):?(.*)")
			
			assert(Args, "Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. "' is missing")
			
			MatchKey = tonumber(MatchKey) or MatchKey
			if MatchType ~= "" then
				assert(ExtendedTranslations.FormatTypes[MatchType], "Couldn't translate key '" .. Key .. "' because the type of argument '" .. MatchKey .. ":" .. MatchType .. "' is not a valid type")
				
				return ExtendedTranslations.FormatTypes[MatchType](LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			elseif Args[MatchKey] ~= nil then
				if type(Args[MatchKey]) == "string" then
					return ExtendedTranslations.Translate(LocaleId, Args[MatchKey], Args, Circular, true)
				elseif type(Args[MatchKey]) == "number" then
					return Args[MatchKey]
				else
					error("Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. "' is not a string - " .. tostring(Args[MatchKey]))
				end
			else
				error("Couldn't translate key '" .. Key .. "' because argument '" .. MatchKey .. "' is missing")
			end
		end))
		
		return Translation
	end,
	TranslateFallback = function(LocaleId, Key, ...)
		if LocaleId == "en-us" then
			return ExtendedTranslations.Translate(LocaleId, Key, ...)
		else
			local Ran, Translation = pcall(ExtendedTranslations.Translate, LocaleId, Key, ...)
			if Ran then
				return Translation
			else
				warn("Failed to translate key '" .. Key .. "' for locale '" .. LocaleId .. "' because:\n" .. Translation)
				return ExtendedTranslations.Translate("en-us", Key, ...)
			end
		end
	end,
	AddTranslation = function(Key, Translation)
		assert(not ExtendedTranslations.Translations[Key], "Couldn't add translation for key '" .. Key .. "' as it already exists")
		assert(type(Translation) == "table", "Couldn't add translation for key '" .. Key .. "' as the translations provided are not a table")
		assert(Translation.Source, "Couldn't add translation for key '" .. Key .. "' as the translation provided has no Source translation")
		
		ExtendedTranslations.Translations[Key] = Translation
	end,
	RemoveTranslation = function(Key)
		assert(ExtendedTranslations.Translations[Key], "Couldn't remove translation for key '" .. Key .. "' as it doesn't exist")
		
		ExtendedTranslations.Translations[Key] = nil
	end,
	ImportLocalizationTable = function(LocalizationTable)
		for Key, Translation in pairs(LocalizationTable) do
			ExtendedTranslations.AddTranslation(Key, Translation)
		end
	end,
	ImportRobloxLocalizationTable = function(LocalizationTable)
		for _, Translation in ipairs(LocalizationTable) do
			ExtendedTranslations.AddTranslation(Translation.Key, {Source = Translation.Source, Values = Translation.Values})
		end
	end,
}

do
	local TranslatorEntries = {}
	local LocalizationTable = Instance.new("LocalizationTable")
	local Translator = LocalizationTable:GetTranslator("en-us")
	for Type, _ in pairs{int = true, fixed = true, num = true, HEX = true, hex = true, datetime = true, iso8601 = true, shorttime = true, shortdatetime = true, shortdate = true,} do
		ExtendedTranslations.FormatTypes[Type] = function(LocaleId, Key, Args, Circular, MatchKey, MatchType, Option)
			assert(Args[MatchKey], "Couldn't translate " .. Key .. " because argument '" .. MatchKey .. "' is missing for " .. MatchType .. " argument '" .. MatchKey .. ":" .. MatchType .. "'")
			print(LocalizationTable, Translator)
			return Translator:FormatByKey(MatchType, {Args[MatchKey]})
			--return LocalizationTable:GetTranslator(LocaleId):FormatByKey(MatchType, {Args[MatchKey]})
		end
		
		TranslatorEntries[#TranslatorEntries + 1] = {
			Key = Type,
			Source = "{1:" .. Type .. "}",
			Values = {},
		}
	end
	LocalizationTable:SetEntries(TranslatorEntries)
end

return ExtendedTranslations