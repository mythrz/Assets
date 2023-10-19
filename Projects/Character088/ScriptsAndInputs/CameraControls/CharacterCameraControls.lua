
-- Docs multiple types of properties.: https://development--o3deorg.netlify.app/docs/user-guide/scripting/lua/properties/
-- Property definitions. These are exposed to the Engine Editor. Input params

local CameraControlsCharacter088 =
{
	Properties =
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
		Camera3PP =
		{
			default = EntityId(),
			description = "Third-Person Perspective Camera"
		},
		CameraFPS =
		{
			default = EntityId(),
			description = "First-Person Perspective Camera"
		},
		HorizontalSensitivity =
		{
			default = 0.001,
			min = 0.00001,
			max = 10,
			-- type = "number",
			description = "Mouse sensitivity of mouse_delta_x. Left and right"
		},
		VerticalSensitivity =
		{
			default = 0.001,
			min = 0.00001,
			max = 10,
			description = "Mouse sensitivity of mouse_delta_y. Down and up"
		},
		InvertMouseLeftRight =
		{
			default = false,
			description = "Set it to true to invert horizontal mouse input"
		},
		InvertMouseUpDown =
		{
			default = false,
			description = "Set it to true to invert vertical mouse input"
		},
		ShowMouseCursor =
		{
			default = false,
			description = "Set it to false to hide the default cursor"
		},
		Character088 =
		{
			default = EntityId(),
			description = "Entity of the character. Used to match the rotations of the camera"
		},
		ThisFileName =
		{
			default = "CharacterCameraControls",
			description = "File name of this script"
		},
		ObserverConsole =
		{
			require = "Assets.Projects.ObserverReporting.ObserverConsole",
			description = "Observer to print to console "
		}
	}
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- When the script becomes active, this is the first thing to run
function CameraControlsCharacter088:OnActivate()
	CameraControlsCharacter088.ScriptIsActive = self.Properties.ScriptIsActive;

	-- if (self.Properties.ScriptIsActive == true) then
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		-- Console message:
		if (self.Properties.ShowMessages == true) then
			Debug.Log("Lua Script Called CharacterCameraControls. OnActivate Began");
			Debug.Log("HorizontalSensitivity: ".. tostring(self.Properties.HorizontalSensitivity));
			Debug.Log("VerticalSensitivity: ".. tostring(self.Properties.VerticalSensitivity));
			Debug.Log("InvertMouseLeftRight: ".. tostring(self.Properties.InvertMouseLeftRight));
			Debug.Log("InvertMouseUpDown: ".. tostring(self.Properties.InvertMouseUpDown));
		end

		-- ChangeCamera (F4) 
		self.ChangeCameraInputBusId = InputEventNotificationId("ChangeCamera");
		self.ChangeCameraInputBus = InputEventNotificationBus.Connect(self, self.ChangeCameraInputBusId);
		CameraControlsCharacter088:SetAllParameters(0, self.Properties.Camera3PP,
		self.Properties.Character088,
		self.Properties.InvertMouseLeftRight, self.Properties.InvertMouseUpDown,
		self.Properties.VerticalSensitivity, self.Properties.HorizontalSensitivity);
		-- NOTE: When you set variables, do it in a method like the one above

		-- CameraFPS 
		self.CameraFPSInputBusId = InputEventNotificationId("CameraFPS");
		self.CameraFPSInputBus = InputEventNotificationBus.Connect(self, self.CameraFPSInputBusId);

		-- MouseXXX
		self.MouseXXXInputBusId = InputEventNotificationId("MouseXXX");
		self.MouseXXXInputBus = InputEventNotificationBus.Connect(self, self.MouseXXXInputBusId);
		-- g_MouseXXXInputBusId = self.MouseXXXInputBus.GetInstance().value

		-- MouseYYY
		self.MouseYYYInputBusId = InputEventNotificationId("MouseYYY");
		self.MouseYYYInputBus = InputEventNotificationBus.Connect(self, self.MouseYYYInputBusId);
		-- g_MouseYYYInputBusId = self.MouseYYYInputBus.GetInstance().value
		
--		-- OnTick function
--		-- https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/AutomatedTesting/Levels/AWS/Metrics/Script/Metrics.lua#L37
--		-- self.tickTime = 0
		self.tickBusHandler = TickBus.Connect(self, self.entityId) 
		
		-- Show the cursor. Unsure if I should add a third camera from the top!
		LyShineLua.ShowMouseCursor(self.Properties.ShowMouseCursor) 
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function CameraControlsCharacter088:OnDeactivate()
	self.tickBusHandler:Disconnect()
	self.ChangeCameraInputBus:Disconnect()
	self.CameraFPSInputBus:Disconnect()
	self.MouseXXXInputBus:Disconnect()
	self.MouseYYYInputBus:Disconnect()
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- a button or mouse was pressed or moved! Tracks delta x and y mouse movement too
function CameraControlsCharacter088:OnPressed(floatValue)
	-- if (self.Properties.ScriptIsActive == true) then
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		self:HandleInputs(floatValue, false);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- a button or mouse was released or stopped moving! Tracks delta x and y mouse movement too
function CameraControlsCharacter088:OnReleased(floatValue)
	-- if (self.Properties.ScriptIsActive == true) then
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		self:HandleInputs(floatValue, true);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- a button or mouse is held or moving! Tracks delta x and y mouse movement too
function CameraControlsCharacter088:OnHeld(floatValue)
	-- if (self.Properties.ScriptIsActive == true) then
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		-- Working. No more rolling of Y
		CameraControlsCharacter088:RotationAroundLocal(floatValue, self.MouseXXXInputBusId,
		self.MouseYYYInputBusId)
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Helper Methods. Main Code:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- what buttons are hold and/or pressed. Filter the logic:
-- https://github.com/o3de/o3de/blob/20aaa7de7a99a93ebc80f10e596a4afca2ec4999/Gems/AtomLyIntegration/AtomBridge/Code/Source/FlyCameraInputComponent.cpp#L250
function CameraControlsCharacter088:HandleInputs(floatValue, wasReleased)
	-- F4 changes the camera
	if (InputEventNotificationBus.GetCurrentBusId() == self.ChangeCameraInputBusId) and (wasReleased) then
		self:HandleChangeCamera(floatValue);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- https://github.com/o3de/o3de.org/blob/main/content/docs/user-guide/components/reference/camera/camera.md
-- ChangeCamera was pressed. F4. Shift between FPS and 3PP cameras
function CameraControlsCharacter088:HandleChangeCamera(floatValue)
	if (CameraRequestBus.Event.IsActiveView(self.Properties.CameraFPS) == true) then
		CameraRequestBus.Event.MakeActiveView(self.Properties.Camera3PP)
		CameraControlsCharacter088:SetAllParameters(0, self.Properties.Camera3PP,
		self.Properties.Character088,
		self.Properties.InvertMouseLeftRight, self.Properties.InvertMouseUpDown,
		self.Properties.VerticalSensitivity, self.Properties.HorizontalSensitivity)
		
		-- Console message:
		if (self.Properties.ShowMessages == true) then
			Debug.Log("Camera3PP is Active")
		end
	else 
		CameraRequestBus.Event.MakeActiveView(self.Properties.CameraFPS)
		CameraControlsCharacter088:SetAllParameters(1, self.Properties.CameraFPS,
		self.Properties.Character088,
		self.Properties.InvertMouseLeftRight, self.Properties.InvertMouseUpDown,
		self.Properties.VerticalSensitivity, self.Properties.HorizontalSensitivity)
		
		-- Console message:
		if (self.Properties.ShowMessages == true) then
			Debug.Log("CameraFPS is Active")
		end
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- isCamera: 0 is Camera3PP (Third-Person Perspective); 1 is CameraFPS (First-Person-Shooter); 2 is CameraTD (Top-Down)
-- Setting and accessing of values works better if isolated into a function like this
function CameraControlsCharacter088:SetAllParameters(isCamera, camera, char088,
InvertMouseLeftRight, InvertMouseUpDown, VerticalSensitivity, HorizontalSensitivity)
	if (isCamera == 0) then -- 3PP
		self.MinUDpitchLimit = -20
		self.MaxUDpitchLimit = 10
		self.activeCam = camera
	elseif (isCamera == 1) then -- FPS
		self.MinUDpitchLimit = -40
		self.MaxUDpitchLimit = 40
		self.activeCam = camera
	end

	self.verticalSens = VerticalSensitivity
	self.horizontalSens = HorizontalSensitivity
	self.invertMouseLR = InvertMouseLeftRight and 1 or -1 -- Invert Left Right?
	self.invertMouseUD = InvertMouseUpDown and 1 or -1 -- -Invert Up Down?
	self.activeCharacter = char088 -- self.Properties.Character088
	return self.activeCam
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Simpler rotation. Not rolling anymore:
function CameraControlsCharacter088:RotationAroundLocal(floatValue, MouseXXXInputBusId, MouseYYYInputBusId)
	if (InputEventNotificationBus.GetCurrentBusId() == MouseXXXInputBusId) then
		--TransformBus.Event.RotateAroundLocalZ(self.activeCam, -floatValue * self.horizontalSens)
		TransformBus.Event.RotateAroundLocalZ(self.activeCharacter, self.invertMouseLR * floatValue * self.horizontalSens) -- rotate character
	end

	if (InputEventNotificationBus.GetCurrentBusId() == MouseYYYInputBusId) then
		-- Check current angle  TODO: Needs improvement
		local currentR2 = math.deg(TransformBus.Event.GetWorldRotationQuaternion(self.activeCam).x)
		if currentR2 >= self.MaxUDpitchLimit then
			TransformBus.Event.RotateAroundLocalX(self.activeCam, -5 * 0.001) -- clamp TODO: Needs improvement
		elseif currentR2 <= self.MinUDpitchLimit then
			TransformBus.Event.RotateAroundLocalX(self.activeCam, 5 * 0.001) -- clamp TODO: Needs improvement
		else
			TransformBus.Event.RotateAroundLocalX(self.activeCam, self.invertMouseUD * floatValue * self.verticalSens) -- rotate camera
		end
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- attempt to re-use FlyCameraComponent
-- Flycamera e.g.,: https://github.com/o3de/o3de/blob/20aaa7de7a99a93ebc80f10e596a4afca2ec4999/Gems/AtomLyIntegration/AtomBridge/Code/Source/FlyCameraInputComponent.cpp#L15
-- OnTick e.g.,: https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/AutomatedTesting/Levels/AWS/Metrics/Script/Metrics.lua#L37
-- Transform: https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/Gems/StartingPointMovement/Assets/Scripts/Components/EntityLookAt.lua#L39
-- Cry Engine Quaternion: https://docs.cryengine.com/display/CS/CryEngine.Quaternion
-- O3DE library: https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/Code/Framework/AzCore/AzCore/Math/Quaternion.h#L201
-- function CameraControlsCharacter088:OnTick(deltaTime)
	-- -- TODO: Quaternion
	-- CameraControlsCharacter088:QuaternionRotation(deltaTime, self.entityId)

	-- -- TODO: Angles. Euler. Best so far. But still not working properly!!
	-- CameraControlsCharacter088:RotationOnTick(deltaTime, self.entityId)
	
	-- TODO:
	-- CameraControlsCharacter088:MyRotationA2(deltaTime, self.entityId)
	
	-- TODO:
	-- CameraControlsCharacter088:MyRotationA3(deltaTime, self.entityId)
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return CameraControlsCharacter088
