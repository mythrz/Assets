
-- -- Object rotation tests
-- -- TODO: If you create two different objects with Lua Script Components calling this same script, it will only rotate 1!
-- -- It is not reusable, and it should be

local ObjectRotations = 
{
	Properties =
	{
		RotationVector3 = 
		{
			default = Vector3(0, 0, 45), 
			description = "Rotation is defined herey",
			suffix = " degrees/sec"
		},
		ObjectToRotate = 
		{
			default = EntityId(),
			description = "Object to rotate"
		}
--		MyTransform = {}, -- ?! https://github.com/o3de/o3de/blob/74f49c880d6e9a36f2e7dde5683e1a4b83fbbadb/Gems/StartingPointMovement/Assets/Scripts/Components/EntityLookAt.lua
	}
}
-- ObjectRotations.__index = ObjectRotations

-- function ObjectRotations.new(RotationVector3, ObjectToRotate)
-- 	local instance = setmetatable(
-- 	{
-- 		RotationVector3 = RotationVector3,
-- 		ObjectToRotate = ObjectToRotate,
-- 	}, Default001);
-- 	return instance;
-- end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ObjectRotations:OnActivate()
	-- OnTick 
	self.tickBusHandler = TickBus.Connect(self) --, self.entityId) 

	-- Set the values here:
	ObjectRotations:SetTempValues(self.Properties.RotationVector3, self.Properties.ObjectToRotate)
	-- local thisInstance = ObjectRotations.new(self.Properties.RotationVector3, self.Properties.ObjectToRotate)
	-- ObjectRotations:SetTempValues(thisInstance.RotationVector3, thisInstance.ObjectToRotate)
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ObjectRotations:OnDeactivate()
	self.tickBusHandler:Disconnect()
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ObjectRotations:OnTick(deltaTime) --, timePoint)
	-- Rotate:
	self:OnTickSimpleRotate(deltaTime)
	-- ObjectRotations:OnTickSimpleRotate(deltaTime) 
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- HELPER functions:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Passing the values from the component to accessible values in this class
function ObjectRotations:SetTempValues(RotationVector3, ObjectToRotate)
	self.rotationRadians = Vector3(0,0,0)
	self.rotationRadians = RotationVector3 -- Vector3(0, 0, 90)
	self.rotationRadians.x = Math.DegToRad(self.rotationRadians.x)
	self.rotationRadians.y = Math.DegToRad(self.rotationRadians.y)
	self.rotationRadians.z = Math.DegToRad(self.rotationRadians.z)
	self.object2rotate = ObjectToRotate
end 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- This is a fixed and constant rotation defined in a vector:
function ObjectRotations:OnTickSimpleRotate(deltaTime)
	
--	Debug.Log("Working: "..tostring(self).. " deltaTime: " ..tostring(deltaTime) .. "object2rotate" ..tostring(self.object2rotate) .. "self.rotationRadians" ..tostring(self.rotationRadians))

-- Only works on one component lua script. Why?!
	TransformBus.Event.RotateAroundLocalX(self.object2rotate, self.rotationRadians.x * deltaTime) 
	TransformBus.Event.RotateAroundLocalY(self.object2rotate, self.rotationRadians.y * deltaTime)
	TransformBus.Event.RotateAroundLocalZ(self.object2rotate, self.rotationRadians.z * deltaTime)
	
	-- same result. Only works on one component lua script
--	local worldOrientation = TransformBus.Event.GetWorldRotationQuaternion(self.object2rotate)
--	local turningLR = Quaternion.CreateFromAxisAngle(Vector3(0,0,1), self.rotationRadians.z * deltaTime) -- LR left right -- yaw
--	local newRotaInZ = worldOrientation * turningLR
--	local temp = TransformBus.Event.SetWorldRotationQuaternion(self.object2rotate, newRotaInZ)
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


return ObjectRotations;

