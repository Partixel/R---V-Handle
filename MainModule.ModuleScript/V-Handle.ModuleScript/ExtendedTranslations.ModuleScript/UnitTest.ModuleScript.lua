return function(Group)
	local ExtendedTranslations = require(script.Parent:Clone())
	
	local function ClearTranslations()
		ExtendedTranslations.Translations = {}
	end
	
	local function ImportLocalizationTable()
		return ExtendedTranslations.ImportLocalizationTable{
			Sentence = {
				Source = "Nice sentence.",
				Values = {
				},
			},
			Test = {
				Source = "{X} and {Y}",
				Values = {
					["es-es"] = "{X} ci {Y}",
				},
			},
			NumericalTest = {
				Source = "{1} and {2:num}",
				Values = {
					["es-es"] = "{X} ci {Y}",
				},
			},
			LookupTest = {
				Source = "{XYZ:lookup} and {Z}",
			},
			NestedTest = {
				Source = "{Test:lookup} and {Z}",
			},
			NestedTest2 = {
				Source = "{NestedTest3:lookup} and {X}",
			},
			NestedTest3 = {
				Source = "{NestedTest2:lookup} and {Y}",
			},
			TranslateTest = {
				Source = "{Str:translate} and {Str2:translate}",
			},
			InvalidType = {
				Source = "{XYZ:zyx}",
			},
			FormatTest = {
				Source = "{Num:format}",
			},
			int = {
				Source = "{Num:int}",
				Values = {
					["es-es"] = "{Num:int}"
				}
			},
			fixed = {
				Source = "{Num:fixed}",
			},
			num = {
				Source = "{Num:num}",
			},
			HEX = {
				Source = "{Num:HEX}",
			},
			hex = {
				Source = "{Num:hex}",
			},
			datetime = {
				Source = "{Num:datetime}",
			},
			iso8601 = {
				Source = "{Num:iso8601}",
			},
			shorttime = {
				Source = "{Num:shorttime}",
			},
			shortdatetime = {
				Source = "{Num:shortdatetime}",
			},
			shortdate = {
				Source = "{Num:shortdate}",
			},
			PrecedingZeros = {
				Source = "{Num:format:%05d}",
			},
			True = {
				Source = "True!"
			},
			False = {
				Source = "False!"
			},
			If = {
				Source = "Test is {Test:if:True?False}",
			},
			IfFalse = {
				Source = "Test is {Test:if:True?}",
			},
			IfTrue = {
				Source = "Test is {Test:if:?False}",
			},
			IfInvalid = {
				Source = "Test is {Test:if:True}",
			},
			SetTrue = {
				Source = "Test is {Test:set:True}{Test}",
			},
			SetBlank = {
				Source = "Test is {Test:set:}{Test}",
			},
			SetAfter = {
				Source = "Test is {Test} and now it's {Test:set:true}{Test}",
			},
			SetEmbedded = {
				Source = "Test is {Test:set:{True:lookup}}{Test}",
			},
			SetEmbedError = {
				Source = "Test is {Test:set:{True}}{Test}",
			},
		}
	end
	
	local function ImportRobloxLocalizationTable()
		return ExtendedTranslations.ImportRobloxLocalizationTable{
			{
				Key = "PlaySoundFor",
				Source = "{Executor} played {SoundId} for {Targets}",
				Values = {
					["es-es"] = "{Executor} jugó {SoundId} para {Targets}",
				},
			},
		}
	end
	
	local ImportTests = Group:AddGroup{
		Name = "Import",
	}
	ImportTests:AddTest{
		Name = "ImportLocalizationTable",
		Function = ImportLocalizationTable,
		BeforeRun = ClearTranslations,
		AfterRun = ClearTranslations,
		Args = {},
		ExpectedResult = function()
			return ExtendedTranslations.Translations.SetBlank
		end,
		FailMsg = "Didn't correctly import a localization table"
	}
	ImportTests:AddTest{
		Name = "ImportRobloxLocalizationTable",
		BeforeRun = ClearTranslations,
		AfterRun = ClearTranslations,
		Function = ImportRobloxLocalizationTable,
		Args = {},
		ExpectedResult = function()
			return ExtendedTranslations.Translations.PlaySoundFor
		end,
		FailMsg = "Didn't correctly import a roblox localization table"
	}
	
	local TranslationTests = Group:AddGroup{
		Name = "Translation Tests",
		BeforeRun = function()
			ImportLocalizationTable()
			ImportRobloxLocalizationTable()
		end,
		AfterRun = ClearTranslations,
	}
	TranslationTests:AddTest{Name = "en-us", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test", {X = 5, Y = 3}}, ExpectedResult = "5 and 3", FailMsg = "Didn't correctly translate to en-us with argument"}
	TranslationTests:AddTest{Name = "es-es", Function = ExtendedTranslations.Translate, Args = {"es-es", "Test", {X = 5, Y = 3}}, ExpectedResult = "5 ci 3", FailMsg = "Didn't correctly translate to es-es with argument"}
	TranslationTests:AddTest{Name = "roblox_import_translation", Function = ExtendedTranslations.Translate, Args = {"en-us", "PlaySoundFor", {Executor = "You", SoundId = 1234, Targets = "You my man"}}, ExpectedResult = "You played 1234 for You my man", FailMsg = "Didn't correctly translate imported roblox translations"}
	TranslationTests:AddTest{Name = "numerical", Function = ExtendedTranslations.Translate, Args = {"en-us", "NumericalTest", {5, 3}}, ExpectedResult = "5 and 3.00", FailMsg = "Didn't correctly translate with numerical arguments"}
	TranslationTests:AddTest{Name = "lookup", Function = ExtendedTranslations.Translate, Args = {"en-us", "NestedTest", {X = 5, Y = 3, Z = 7}}, ExpectedResult = "5 and 3 and 7", FailMsg = "Didn't correctly translate lookup"}
	TranslationTests:AddTest{Name = "argument_embed", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test", {X = "{Y:num}", Y = 3}}, ExpectedResult = "3.00 and 3", FailMsg = "Didn't correctly translate argument with argument embedded translation"}
	TranslationTests:AddTest{Name = "argument_embedded_lookup", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test", {X = "{Sentence:lookup}", Y = 3}}, ExpectedResult = "Nice sentence. and 3", FailMsg = "Didn't correctly translate argument with argument embedded lookup"}
	TranslationTests:AddTest{Name = "translate_and_lookup", Function = ExtendedTranslations.Translate, Args = {"en-us", "TranslateTest", {Str = "Test", Str2 = "NestedTest", X = 5, Y = 3, Z = 7}}, ExpectedResult = "5 and 3 and 5 and 3 and 7", FailMsg = "Didn't correctly translate translate and lookup"}
	TranslationTests:AddTest{Name = "es-es_int", Function = ExtendedTranslations.Translate, Args = {"es-es", "int", {Num = 5000}}, ExpectedResult = "5000", FailMsg = "Didn't correctly translate int"}
	TranslationTests:AddTest{Name = "int", Function = ExtendedTranslations.Translate, Args = {"en-us", "int", {Num = 5000}}, ExpectedResult = "5000", FailMsg = "Didn't correctly translate int"}
	TranslationTests:AddTest{Name = "round_down_int", Function = ExtendedTranslations.Translate, Args = {"en-us", "int", {Num = 5000.4}}, ExpectedResult = "5000", FailMsg = "Didn't correctly translate int"}
	TranslationTests:AddTest{Name = "round_up_int", Function = ExtendedTranslations.Translate, Args = {"en-us", "int", {Num = 4999.5}}, ExpectedResult = "5000", FailMsg = "Didn't correctly translate int"}
	TranslationTests:AddTest{Name = "negative_int", Function = ExtendedTranslations.Translate, Args = {"en-us", "int", {Num = -5000}}, ExpectedResult = "-5000", FailMsg = "Didn't correctly translate int"}
	TranslationTests:AddTest{Name = "fixed", Function = ExtendedTranslations.Translate, Args = {"en-us", "fixed", {Num = 3000}}, ExpectedResult = "3000.00", FailMsg = "Didn't correctly translate fixed"}
	TranslationTests:AddTest{Name = "round_up_fixed", Function = ExtendedTranslations.Translate, Args = {"en-us", "fixed", {Num = 3000.356}}, ExpectedResult = "3000.36", FailMsg = "Didn't correctly translate fixed"}
	TranslationTests:AddTest{Name = "round_down_fixed", Function = ExtendedTranslations.Translate, Args = {"en-us", "fixed", {Num = 3000.354}}, ExpectedResult = "3000.35", FailMsg = "Didn't correctly translate fixed"}
	TranslationTests:AddTest{Name = "negative_fixed", Function = ExtendedTranslations.Translate, Args = {"en-us", "fixed", {Num = -3000.356}}, ExpectedResult = "-3000.36", FailMsg = "Didn't correctly translate fixed"}
	TranslationTests:AddTest{Name = "num", Function = ExtendedTranslations.Translate, Args = {"en-us", "num", {Num = 2000}}, ExpectedResult = "2,000.00", FailMsg = "Didn't correctly translate num"}
	TranslationTests:AddTest{Name = "round_up_num", Function = ExtendedTranslations.Translate, Args = {"en-us", "num", {Num = 2000.356}}, ExpectedResult = "2,000.36", FailMsg = "Didn't correctly translate num"}
	TranslationTests:AddTest{Name = "round_down_num", Function = ExtendedTranslations.Translate, Args = {"en-us", "num", {Num = 2000.354}}, ExpectedResult = "2,000.35", FailMsg = "Didn't correctly translate num"}
	TranslationTests:AddTest{Name = "negative_num", Function = ExtendedTranslations.Translate, Args = {"en-us", "num", {Num = -2000.356}}, ExpectedResult = "-2,000.36", FailMsg = "Didn't correctly translate num"}
	TranslationTests:AddTest{Name = "HEX", Function = ExtendedTranslations.Translate, Args = {"en-us", "HEX", {Num = 300}}, ExpectedResult = "12C", FailMsg = "Didn't correctly translate HEX"}
	TranslationTests:AddTest{Name = "hex", Function = ExtendedTranslations.Translate, Args = {"en-us", "hex", {Num = 300}}, ExpectedResult = "12c", FailMsg = "Didn't correctly translate hex"}
	TranslationTests:AddTest{Name = "datetime", Function = ExtendedTranslations.Translate, Args = {"en-us", "datetime", {Num = 1585697281.9284}}, ExpectedResult = "2020-03-31 23:28:02", FailMsg = "Didn't correctly translate datetime"}
	TranslationTests:AddTest{Name = "iso8601", Function = ExtendedTranslations.Translate, Args = {"en-us", "iso8601", {Num = 1585697281.9284}}, ExpectedResult = "2020-03-31T23:28:02Z", FailMsg = "Didn't correctly translate iso8601"}
	TranslationTests:AddTest{Name = "shorttime", Function = ExtendedTranslations.Translate, Args = {"en-us", "shorttime", {Num = 1585697281.9284}}, ExpectedResult = "12:28 AM", FailMsg = "Didn't correctly translate shorttime"}
	TranslationTests:AddTest{Name = "shortdatetime", Function = ExtendedTranslations.Translate, Args = {"en-us", "shortdatetime", {Num = 1585697281.9284}}, ExpectedResult = "4/1/2020 12:28 AM", FailMsg = "Didn't correctly translate shortdatetime"}
	TranslationTests:AddTest{Name = "shortdate", Function = ExtendedTranslations.Translate, Args = {"en-us", "shortdate", {Num = 1585697281.9284}}, ExpectedResult = "4/1/2020", FailMsg = "Didn't correctly translate shortdate"}
	TranslationTests:AddTest{Name = "format", Function = ExtendedTranslations.Translate, Args = {"en-us", "PrecedingZeros", {Num = 5}}, ExpectedResult = "00005", FailMsg = "Didn't correctly translate format"}
	TranslationTests:AddTest{Name = "if", Function = ExtendedTranslations.Translate, Args = {"en-us", "If", {Test = true}}, ExpectedResult = "Test is True!", FailMsg = "Didn't correctly translate if type"}
	TranslationTests:AddTest{Name = "if_false", Function = ExtendedTranslations.Translate, Args = {"en-us", "If", {Test = false}}, ExpectedResult = "Test is False!", FailMsg = "Didn't correctly translate if type"}
	TranslationTests:AddTest{Name = "if_truthy", Function = ExtendedTranslations.Translate, Args = {"en-us", "If", {Test = 5}}, ExpectedResult = "Test is True!", FailMsg = "Didn't correctly translate if type for truthy if"}
	TranslationTests:AddTest{Name = "if_falsey", Function = ExtendedTranslations.Translate, Args = {"en-us", "If", {Test = nil}}, ExpectedResult = "Test is False!", FailMsg = "Didn't correctly translate if type for falsey if"}
	TranslationTests:AddTest{Name = "if_no_false", Function = ExtendedTranslations.Translate, Args = {"en-us", "IfFalse", {Test = false}}, ExpectedResult = "Test is ", FailMsg = "Didn't correctly translate if type without false result"}
	TranslationTests:AddTest{Name = "if_no_false_true", Function = ExtendedTranslations.Translate, Args = {"en-us", "IfFalse", {Test = true}}, ExpectedResult = "Test is True!", FailMsg = "Didn't correctly translate if type without false result"}
	TranslationTests:AddTest{Name = "if_no_true", Function = ExtendedTranslations.Translate, Args = {"en-us", "IfTrue", {Test = true}}, ExpectedResult = "Test is ", FailMsg = "Didn't correctly translate if type without true result"}
	TranslationTests:AddTest{Name = "if_no_true_false", Function = ExtendedTranslations.Translate, Args = {"en-us", "IfTrue", {Test = false}}, ExpectedResult = "Test is False!", FailMsg = "Didn't correctly translate if type without true result"}
	TranslationTests:AddTest{Name = "set", Function = ExtendedTranslations.Translate, Args = {"en-us", "SetTrue", {Test = "false"}}, ExpectedResult = "Test is True", FailMsg = "Didn't correctly translate set type"}
	TranslationTests:AddTest{Name = "set_blank", Function = ExtendedTranslations.Translate, Args = {"en-us", "SetBlank", {Test = "false"}}, ExpectedResult = "Test is ", FailMsg = "Didn't correctly translate set type with blank value"}
	TranslationTests:AddTest{Name = "set_after", Function = ExtendedTranslations.Translate, Args = {"en-us", "SetAfter", {Test = "false"}}, ExpectedResult = "Test is false and now it's true", FailMsg = "Didn't translate set type in correct order"}
	TranslationTests:AddTest{Name = "set_without_initial", Function = ExtendedTranslations.Translate, Args = {"en-us", "SetTrue", {}}, ExpectedResult = "Test is True", FailMsg = "Didn't correctly translate set type without initial value"}
	TranslationTests:AddTest{Name = "set_embedded", Function = ExtendedTranslations.Translate, Args = {"en-us", "SetEmbedded", {Test = "false"}}, ExpectedResult = "Test is True!", FailMsg = "Didn't correctly translate set type"}
	
	local ErrorTests = Group:AddGroup{
		Name = "Errors",
		BeforeRun = function()
			ImportLocalizationTable()
			ImportRobloxLocalizationTable()
		end,
		AfterRun = ClearTranslations,
	}
	ErrorTests:AddTest{Name = "no_key", Function = ExtendedTranslations.Translate, Args = {"en-us", "FakeKey"}, ExpectedError = "Couldn't translate key 'FakeKey' because no translations exist", FailMsg = "Didn't error for missing translations"}
	ErrorTests:AddTest{Name = "no_es-es", Function = ExtendedTranslations.Translate, Args = {"es-es", "NestedTest"}, ExpectedError = "Couldn't translate key 'NestedTest' because translation doesn't exist for 'es-es'", FailMsg = "Didn't error for missing es-es translation"}
	ErrorTests:AddTest{Name = "missing_ez-ez", Function = ExtendedTranslations.Translate, Args = {"ez-ez", "Sentence"}, ExpectedError = "Couldn't translate key 'Sentence' because translation doesn't exist for 'ez-ez'", FailMsg = "Didn't error for missing ez-ez translation"}
	ErrorTests:AddTest{Name = "missing_arg", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test"}, ExpectedError = "Couldn't translate key 'Test' because argument 'X' is missing", FailMsg = "Didn't error for missing arguments"}
	ErrorTests:AddTest{Name = "missing_arg_2", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test", {X = 5}}, ExpectedError = "Couldn't translate key 'Test' because argument 'Y' is missing", FailMsg = "Didn't error for missing argument"}
	ErrorTests:AddTest{Name = "invalid_arg", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test", {X = true}}, ExpectedError = "Couldn't translate key 'Test' because argument 'X' is not a string - true", FailMsg = "Didn't error for non-string/non-number argument"}
	ErrorTests:AddTest{Name = "missing_translation_for_embedded", Function = ExtendedTranslations.Translate, Args = {"en-us", "Test", {X = "{Y:num}"}}, ExpectedError = "Couldn't translate {Y:num} because argument 'Y' is missing for num argument 'Y:num'", FailMsg = "Didn't error for argument embedded translation without translation for embed"}
	ErrorTests:AddTest{Name = "invalid_type", Function = ExtendedTranslations.Translate, Args = {"en-us", "InvalidType", {X = 5, Y = 3, Z = 7}}, ExpectedError = "Couldn't translate key 'InvalidType' because the type of argument 'XYZ:zyx' is not a valid type", FailMsg = "Didn't error for invalid type"}
	ErrorTests:AddTest{Name = "missing_arg_roblox_type", Function = ExtendedTranslations.Translate, Args = {"en-us", "shortdate", {}}, ExpectedError = "Couldn't translate shortdate because argument 'Num' is missing for shortdate argument 'Num:shortdate'", FailMsg = "Didn't error for missing argument for roblox type"}
	ErrorTests:AddTest{Name = "missing_arg_format", Function = ExtendedTranslations.Translate, Args = {"en-us", "PrecedingZeros", {}}, ExpectedError = "Couldn't translate key 'PrecedingZeros' because argument 'Num' is missing for format argument 'Num:format'", FailMsg = "Didn't error for missing argument for format type"}
	ErrorTests:AddTest{Name = "missing_option_format", Function = ExtendedTranslations.Translate, Args = {"en-us", "FormatTest", {Num = 123}}, ExpectedError = "Couldn't translate key 'FormatTest' because the format is missing for format argument 'Num:format'", FailMsg = "Didn't error for missing option for format type"}
	ErrorTests:AddTest{Name = "missing_translate", Function = ExtendedTranslations.Translate, Args = {"en-us", "TranslateTest", {X = 5, Y = 3, Z = 7}}, ExpectedError = "Couldn't translate key 'TranslateTest' because argument 'Str' is missing for translation argument 'Str:translate'", FailMsg = "Didn't error for missing argument for translate type"}
	ErrorTests:AddTest{Name = "missing_lookup", Function = ExtendedTranslations.Translate, Args = {"en-us", "LookupTest", {X = 5, Y = 3, Z = 7}}, ExpectedError = "Couldn't translate key 'XYZ' because no translations exist", FailMsg = "Didn't error for missing translation for lookup type"}
	ErrorTests:AddTest{Name = "invalid_arg_format", Function = ExtendedTranslations.Translate, Args = {"en-us", "PrecedingZeros", {Num = "Fake"}}, ExpectedError = "bad argument #2 (number expected, got string)", FailMsg = "Didn't error for invalid argument for format type"}
	ErrorTests:AddTest{Name = "invalid_if", Function = ExtendedTranslations.Translate, Args = {"en-us", "IfInvalid", {Test = true}}, ExpectedError = "Couldn't translate key 'IfInvalid' because the false result is missing for if argument 'Test:if' (Key:if:ResultTrueKey?ResultFalseKey)", FailMsg = "Didn't error for invalid if type"}
	ErrorTests:AddTest{Name = "missing_translation_embedded_set", Function = ExtendedTranslations.Translate, Args = {"en-us", "SetEmbedError", {Test = "false"}}, ExpectedError = "Couldn't translate key '{True}' because argument 'True' is missing", FailMsg = "Didn't error for set type with an embedded translation that doesn't exist"}
end