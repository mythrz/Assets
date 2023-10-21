
-- Observer001 to report the changes, state, messages
-- Printing messages to the console! Do not add any kind of calculations here!
-- TODO: improve and add event messages and responses here.
-- TODO: messages should appear when deployed too, if opted in. Not just Debug.Log()

local ObserverConsole001  =
{
	Properties  =
	{
		ScriptIsActive =
		{
			default = true,
			description = "Set it to false to stop the script from running"
		},
		ShowMessages =
		{
			default = true,
			description = "Set it to false to prevent messages from appearing in the console"
		},
		ThisFileName =
		{
			default = "Default",
			description = "File name of this script"
		}
	}
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- call SetAllParameters first, then activate!
function ObserverConsole001:OnActivate()
	-- -- If the SetAllParameters function was not called, ObserverConsole001.ScriptIsActive will be nil
	if (ObserverConsole001.ScriptIsActive == true) then
		-- -- Console message:
		if (ObserverConsole001.ShowMessages == true) then
			ObserverConsole001:PrintActiveScript1(ObserverConsole001.FileName, ObserverConsole001.ScriptIsActive);
		end
	-- elseif (ObserverConsole001.ScriptIsActive == nil) then
	-- 	Debug.Log("SetAllParameters() was not called before OnActivate()");
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- call SetAllParameters should be done only once, before calling OnActivate. Deactivate is the last
function ObserverConsole001:OnDeactivate()
	if (ObserverConsole001.ShowMessages == true) then
		ObserverConsole001:PrintDeactivatedScript1(ObserverConsole001.FileName);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- Call this function first. 
function ObserverConsole001:SetAllParameters(fileName, ShowMessages, ScriptIsActive)
	ObserverConsole001.FileName = fileName;
	ObserverConsole001.ShowMessages = ShowMessages;
	ObserverConsole001.ScriptIsActive = ScriptIsActive;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#region Helpers!
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- Lua script was successful deactivated should show this message
-- --
function ObserverConsole001:PrintDeactivatedScript1(fileNameMotion)
	Debug.Log("Lua "..tostring(fileNameMotion).." deactivated");
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- debug.getinfo(2) gets the info from where the PrintActiveScript3 was called, which is another lua file!
-- --
function ObserverConsole001:PrintDeactivatedScript3()
	local scriptName = debug.getinfo(2).source:match("@?(.*/)([^/]-)%.?([^/]*)$");
	scriptName = scriptName:sub(scriptName:find("[^/]*$"));
	
	local fileName = debug.getinfo(2).source:match("@?(.*)$");
	Debug.Log("Lua "..tostring(fileName .. scriptName).." deactivated");
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- usual message that prints the name of the script and if it is active or not!
function ObserverConsole001:PrintActiveScript1(fileNameMotion, ScriptIsActive)

--	Debug.Log(" -- // -- ");
	Debug.Log("Lua "..tostring(fileNameMotion) .." is Active: ".. tostring(ScriptIsActive));
--	Debug.Log(" -- // -- ");
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- --
-- function ObserverConsole001:PrintActiveScriptSpell(scriptSpell)
-- 	-- Console message:
-- 	if (ObserverConsole001.ShowMessages == true) then
-- 		Debug.Log(" -- // -- ");
-- 		Debug.Log("Lua "..tostring(scriptSpell.fileNameMotion) .." is Active: ".. tostring(ObserverConsole001.ScriptIsActive)..
-- 		"! Character088 ID is: ".. tostring(scriptSpell.Properties.Character088));
-- 		Debug.Log(" -- // -- ");
-- 	end
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- debug.getinfo(2) gets the info from where the PrintActiveScript3 was called, which is another lua file!
-- 
function ObserverConsole001:PrintActiveScript3()
	local scriptName = debug.getinfo(2).source:match("@?(.*/)([^/]-)%.?([^/]*)$");
	scriptName = scriptName:sub(scriptName:find("[^/]*$"));
	local fileName = debug.getinfo(2).source:match("@?(.*)$");
	Debug.Log("Lua Active: "..tostring(fileName .. scriptName)); 
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--Not used
function ObserverConsole001:GetFileName(file)
--	local scriptName = debug.getinfo(1).source:match("@?(.*/)([^/]-)%.?([^/]*)$")

      local file_name = file:match("[^/]*.lua$")
      return file_name:sub(0, #file_name - 4)
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#endregion
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return ObserverConsole001;
