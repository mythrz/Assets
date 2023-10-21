
-- script responsible for controlling the camera 
-- Here is some documentation that explains how rotations could work:
-- https://quaternions.online/
-- https://learn.unity.com/tutorial/quaternions#
-- https://docs.unity3d.com/Manual/class-Quaternion.html
-- https://docs.cryengine.com/display/CS/CryEngine.Quaternion
-- https://docs.unrealengine.com/4.27/en-US/API/Runtime/Core/Math/FQuat/
-- https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/Code/Framework/AzCore/AzCore/Math/Quaternion.h#L201
-- https://github.com/Porcupine-Factory/FirstPersonController/blob/main/Code/Source/Clients/FirstPersonControllerComponent.cpp#L916
-- https://github.com/o3de/o3de/blob/20aaa7de7a99a93ebc80f10e596a4afca2ec4999/Gems/AtomLyIntegration/AtomBridge/Code/Source/FlyCameraInputComponent.cpp#L15
-- https://github.com/drburton/Lua-for-Lumberyard/tree/master
-- https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/AutomatedTesting/Levels/AWS/Metrics/Script/Metrics.lua#L37
-- https://github.com/o3de/o3de/blob/20aaa7de7a99a93ebc80f10e596a4afca2ec4999/Gems/AtomLyIntegration/AtomBridge/Code/Source/FlyCameraInputComponent.cpp#L250

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
		ChangeCameraKey =
		{
			default = "ChangeCamera",
			description = "Input Binding that shifts the active camera. Default is F4"
		},
		MouseXXXKey =
		{
			default = "MouseXXX",
			description = "Input Binding that controls left and right mouse movement. Yaw. Default is mouseXXX"
		},
		MouseYYYKey =
		{
			default = "MouseYYY",
			description = "Input Binding that controls up and down mouse movement. Pitch. Default is mouseYYY"
		},
		ObserverConsole001 =
		{
			default = "Assets.Projects.ObserverReporting.ObserverConsole001",
			description = "Observer to print messages on the console"
		},
	}
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- When the script becomes active, this is the first thing to run
function CameraControlsCharacter088:OnActivate()
	-- -- passing some of the values from table:
	CameraControlsCharacter088.ScriptIsActive = self.Properties.ScriptIsActive;
	CameraControlsCharacter088.ShowMessages = self.Properties.ShowMessages;

	if (CameraControlsCharacter088.ScriptIsActive == true) then
		-- -- Load/require/Activate other Lua Scripts:
		CameraControlsCharacter088:OtherRequiredScripts(self.Properties.ObserverConsole001, CameraControlsCharacter088.ScriptIsActive, CameraControlsCharacter088.ShowMessages, self.Properties.ThisFileName);

		-- -- Show Messages, when verbose is on:
		CameraControlsCharacter088:ShowMessageonStart(self.Properties.HorizontalSensitivity, self.Properties.VerticalSensitivity, self.Properties.InvertMouseLeftRight, self.Properties.InvertMouseUpDown);

		-- -- Bus, tickets:
		CameraControlsCharacter088:SetInputBuses(self, self.Properties.ChangeCameraKey, self.Properties.MouseXXXKey, self.Properties.MouseYYYKey, self.Properties.ShowMouseCursor);

		-- -- Setting of some params:
		CameraControlsCharacter088:SetAllParameters(0, self.Properties.Camera3PP, self.Properties.Character088, self.Properties.InvertMouseLeftRight, self.Properties.InvertMouseUpDown, self.Properties.VerticalSensitivity, self.Properties.HorizontalSensitivity);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function CameraControlsCharacter088:OnDeactivate()
	-- CameraControlsCharacter088.tickBusHandler:Disconnect();
	CameraControlsCharacter088.ChangeCameraInputBus:Disconnect();
	CameraControlsCharacter088.MouseXXXInputBus:Disconnect();
	CameraControlsCharacter088.MouseYYYInputBus:Disconnect();
	CameraControlsCharacter088.ObserverConsole001.OnDeactivate();
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- Bus and BusId setting:
function CameraControlsCharacter088:SetInputBuses(selfEntity, ChangeCameraKey, MouseXXXKey, MouseYYYKey, ShowMouseCursor)
	-- -- ChangeCamera (F4). From FPS to 3PP and vice-versa. Default Keybind is F4
	CameraControlsCharacter088.ChangeCameraInputBusId = InputEventNotificationId(ChangeCameraKey);
	CameraControlsCharacter088.ChangeCameraInputBus = InputEventNotificationBus.Connect(selfEntity, CameraControlsCharacter088.ChangeCameraInputBusId);

	-- -- MouseXXX. Right and Left movement. Yaw
	CameraControlsCharacter088.MouseXXXInputBusId = InputEventNotificationId(MouseXXXKey);
	CameraControlsCharacter088.MouseXXXInputBus = InputEventNotificationBus.Connect(selfEntity, CameraControlsCharacter088.MouseXXXInputBusId);

	-- -- MouseYYY. Up and Down movement. Pitch
	CameraControlsCharacter088.MouseYYYInputBusId = InputEventNotificationId(MouseYYYKey);
	CameraControlsCharacter088.MouseYYYInputBus = InputEventNotificationBus.Connect(selfEntity, CameraControlsCharacter088.MouseYYYInputBusId);

	-- -- https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/AutomatedTesting/Levels/AWS/Metrics/Script/Metrics.lua#L37
	-- -- OnTick function. self.tickTime = 0. Uncomment the function called: CameraControlsCharacter088:OnTick(deltaTime)
	-- CameraControlsCharacter088.tickBusHandler = TickBus.Connect(selfEntity, selfEntity.entityId);

	-- -- Show the cursor. Unsure if I should add a third camera from the top!
	LyShineLua.ShowMouseCursor(ShowMouseCursor);
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- isCamera: 0 is Camera3PP (Third-Person Perspective); 1 is CameraFPS (First-Person-Shooter); 2 is CameraTD (Top-Down); 3 ...
-- -- Setting and accessing of values works better if isolated into a function like this. when you change camera, call this function
-- -- TODO: clamping not working as expected
function CameraControlsCharacter088:SetAllParameters(isCamera, camera, char088,
	InvertMouseLeftRight, InvertMouseUpDown, VerticalSensitivity, HorizontalSensitivity)
		if (isCamera == 0) then -- 3PP
			self.MinUDpitchLimit = -20;
			self.MaxUDpitchLimit = 10;
			self.activeCam = camera;
		elseif (isCamera == 1) then -- FPS
			self.MinUDpitchLimit = -40;
			self.MaxUDpitchLimit = 40;
			self.activeCam = camera;
		end

		self.verticalSens = VerticalSensitivity;
		self.horizontalSens = HorizontalSensitivity;
		self.invertMouseLR = InvertMouseLeftRight and 1 or -1; -- Invert Left Right?
		self.invertMouseUD = InvertMouseUpDown and 1 or -1; -- -Invert Up Down?
		self.activeCharacter = char088; -- self.Properties.Character088
		return self.activeCam;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- Require other scripts here:
function CameraControlsCharacter088:OtherRequiredScripts(ObserverConsole001, ScriptIsActive, ShowMessages, ThisFileName)
	-- CameraControlsCharacter088.ObserverConsole = require(ObserverConsole);
	CameraControlsCharacter088.ObserverConsole001 = require(ObserverConsole001);
	CameraControlsCharacter088.ObserverConsole001:SetAllParameters(ThisFileName, ShowMessages, ScriptIsActive, tostring(ScriptIsActive));
	CameraControlsCharacter088.ObserverConsole001.OnActivate();
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#region Events exposed by the bus/handlers
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- a button or mouse was pressed or moved! Tracks delta x and y mouse movement too
function CameraControlsCharacter088:OnPressed(floatValue)
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		self:HandleInputs(floatValue, false);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- a button or mouse was released or stopped moving! Tracks delta x and y mouse movement too
function CameraControlsCharacter088:OnReleased(floatValue)
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		self:HandleInputs(floatValue, true);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- a button or mouse is held or moving! Tracks delta x and y mouse movement too
function CameraControlsCharacter088:OnHeld(floatValue)
	if (CameraControlsCharacter088.ScriptIsActive == true) then
		-- Working. No more rolling
		self:RotationAroundLocal(floatValue, CameraControlsCharacter088.MouseXXXInputBusId, CameraControlsCharacter088.MouseYYYInputBusId);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#endregion
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#region Helper Functions. Main Code:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- what buttons are hold and/or pressed. Filter the logic:
function CameraControlsCharacter088:HandleInputs(floatValue, wasReleased)
	-- F4 changes the camera
	if (InputEventNotificationBus.GetCurrentBusId() == CameraControlsCharacter088.ChangeCameraInputBusId) and (wasReleased) then
		self:HandleChangeCamera(floatValue);
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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
		self.Properties.VerticalSensitivity, self.Properties.HorizontalSensitivity);

		-- -- Console message:
		if (CameraControlsCharacter088.ShowMessages == true) then
			Debug.Log("Camera3PP is Active");
		end
	else
		CameraRequestBus.Event.MakeActiveView(self.Properties.CameraFPS)
		CameraControlsCharacter088:SetAllParameters(1, self.Properties.CameraFPS,
		self.Properties.Character088,
		self.Properties.InvertMouseLeftRight, self.Properties.InvertMouseUpDown,
		self.Properties.VerticalSensitivity, self.Properties.HorizontalSensitivity);

		-- -- Console message:
		if (CameraControlsCharacter088.ShowMessages == true) then
			Debug.Log("CameraFPS is Active");
		end
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- Rotation of the camera using the mouse_delta_x and mouse_delta_y:
-- -- TODO: Clamping is needed here! The camera is rotating beyond what is expected
function CameraControlsCharacter088:RotationAroundLocal(floatValue, MouseXXXInputBusId, MouseYYYInputBusId)
	if (InputEventNotificationBus.GetCurrentBusId() == MouseXXXInputBusId) then
		-- -- rotate character
		TransformBus.Event.RotateAroundLocalZ(self.activeCharacter, self.invertMouseLR * floatValue * self.horizontalSens);
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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- attempt to re-use FlyCameraComponent
-- Flycamera e.g.,: https://github.com/o3de/o3de/blob/20aaa7de7a99a93ebc80f10e596a4afca2ec4999/Gems/AtomLyIntegration/AtomBridge/Code/Source/FlyCameraInputComponent.cpp#L15
-- OnTick e.g.,: https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/AutomatedTesting/Levels/AWS/Metrics/Script/Metrics.lua#L37
-- Transform: https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/Gems/StartingPointMovement/Assets/Scripts/Components/EntityLookAt.lua#L39
-- Cry Engine Quaternion: https://docs.cryengine.com/display/CS/CryEngine.Quaternion
-- O3DE library: https://github.com/o3de/o3de/blob/70946e11a792dce7a966ca83ed3a3d3e2525df1b/Code/Framework/AzCore/AzCore/Math/Quaternion.h#L201
-- function CameraControlsCharacter088:OnTick(deltaTime)
-- 	-- -- TODO: Quaternion
-- 	-- CameraControlsCharacter088:QuaternionRotation(deltaTime, self.entityId)

-- 	-- -- TODO: Angles. Euler. Best so far. But still not working properly!!
-- 	-- CameraControlsCharacter088:RotationOnTick(deltaTime, self.entityId)

-- 	-- TODO:
-- 	-- CameraControlsCharacter088:MyRotationA2(deltaTime, self.entityId)

-- 	-- TODO:
-- 	-- CameraControlsCharacter088:MyRotationA3(deltaTime, self.entityId)

-- 	-- Debug.Log("OnTick function is online!");
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#endregion
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#region Custom Messages to console:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- Show a message at the start of the script, when verbose is on
function CameraControlsCharacter088:ShowMessageonStart(HorizontalSensitivity, VerticalSensitivity, InvertMouseLeftRight, InvertMouseUpDown)
	if (CameraControlsCharacter088.ShowMessages == true) then
		Debug.Log(" -- // -- ");
		-- Debug.Log("Lua Script Called CharacterCameraControls. OnActivate Began");
		Debug.Log("Horizontal Sensitivity: ".. tostring(HorizontalSensitivity));
		Debug.Log("Vertical Sensitivity: ".. tostring(VerticalSensitivity));
		Debug.Log("Invert Mouse Left-Right (Yaw): ".. tostring(InvertMouseLeftRight));
		Debug.Log("Invert Mouse Up-Down (Pitch): ".. tostring(InvertMouseUpDown));
		Debug.Log(" -- // -- ");
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#endregion 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return CameraControlsCharacter088;



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#region DEPRECATED OR NOT WORKING AS EXPECTED:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--#endregion
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
