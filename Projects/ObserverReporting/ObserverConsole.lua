-- Observer to report the changes, state, messages
-- It is just printing messages to the console!!
-- TODO: improve and add event messages and responses here.
-- TODO: messages should appear when deployed too, if opted in.

local ObserverConsole  =
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
function ObserverConsole:OnActivate()
	if (self.Properties.ScriptIsActive == true) then
		-- setting parameters:
		self:SetAllParameters(self.Properties.ThisFileName);

		-- Console message:
		if (self.Properties.ShowMessages == true) then
			ObserverConsole:PrintActiveScript1(self.fileNameMotion, self.Properties.ScriptIsActive)
		end
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ObserverConsole:OnDeactivate()
	if (self.Properties.ShowMessages == true) then
		ObserverConsole:PrintDeactivatedScript1(self.fileNameMotion)
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Helpers!
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ObserverConsole:SetAllParameters(ThisFileName)
	-- -- this file name 
	self.fileNameMotion = ThisFileName;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 
function ObserverConsole:PrintDeactivatedScript1(fileNameMotion)
	Debug.Log("Lua "..tostring(fileNameMotion).." deactivated");
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- debug.getinfo(2) gets the info from where the PrintActiveScript3 was called, which is another lua file!
-- 
function ObserverConsole:PrintDeactivatedScript3()
	local scriptName = debug.getinfo(2).source:match("@?(.*/)([^/]-)%.?([^/]*)$");
	scriptName = scriptName:sub(scriptName:find("[^/]*$"));
	local fileName = debug.getinfo(2).source:match("@?(.*)$");
	Debug.Log("Lua "..tostring(fileName .. scriptName).." deactivated");
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- usual message that prints the name of the script and if it is active or not!
function ObserverConsole:PrintActiveScript1(fileNameMotion, ScriptIsActive)
--	Debug.Log(" -- // -- ");
	Debug.Log("Lua "..tostring(fileNameMotion) .." is Active: ".. tostring(ScriptIsActive));
--	Debug.Log(" -- // -- ");
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 
function ObserverConsole:PrintActiveScriptSpell(scriptSpell)
	-- Console message:
	if (self.Properties.ShowMessages == true) then
		Debug.Log(" -- // -- ");
		Debug.Log("Lua "..tostring(scriptSpell.fileNameMotion) .." is Active: ".. tostring(self.Properties.ScriptIsActive)..
		"! Character088 ID is: ".. tostring(scriptSpell.Properties.Character088));
		Debug.Log(" -- // -- ");
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- debug.getinfo(2) gets the info from where the PrintActiveScript3 was called, which is another lua file!
-- 
function ObserverConsole:PrintActiveScript3()
	local scriptName = debug.getinfo(2).source:match("@?(.*/)([^/]-)%.?([^/]*)$");
	scriptName = scriptName:sub(scriptName:find("[^/]*$"));
	local fileName = debug.getinfo(2).source:match("@?(.*)$");
	Debug.Log("Lua Active: "..tostring(fileName .. scriptName)); 
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--Not used
function ObserverConsole:GetFileName(file)
--	local scriptName = debug.getinfo(1).source:match("@?(.*/)([^/]-)%.?([^/]*)$")

      local file_name = file:match("[^/]*.lua$")
      return file_name:sub(0, #file_name - 4)
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return ObserverConsole;
