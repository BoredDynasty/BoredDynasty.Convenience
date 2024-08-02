--!strict

--[[
Dynasty here!
If you don't create the things required to run this module script, somethings won't work.
Ill comment my script if you have to make something in a certain area of your Roblox Game.
Used for making everything convenient so you don't have to write too many scripts for your game
Very small script as of right now
                                                    >THIS IS NOT OPTIMIZED<

Module Script
--]]

-- Variables
local Convenience = {}

local ReplicatedStorage = game:GetService('ReplicatedService');
local UserInputService = game:GetService('UserInputService');
local Lighting = game:GetService('Lighting');
local ContextActionService = game:GetService('ContextActionService');
local ContentProvider = game:GetService('ContentProvider');
local ControllerService = game:GetService('ControllerService');
local CollectionService = game:GetService('CollectionService');
local GamePassService = game:GetService('GamePassService');
local GamepadService = game:GetService('GamepadService');
local HapticService = game:GetService('HapticService');
local RunService = game:GetService('RunService');
local Players = game:GetService('Players');
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService") -- One of the most important!

-- Custom
local Rewards = 50
local RewardsModifier = { -- Remember these. Add your own if you want!
	Small = 0.5,
	Normal = 1,
	Large = 2,
	Ultimate = 5,
}

local TInfo = TweenInfo.new( -- Default TweenInfo
	1,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

-- Things
local OnGameLoaded = ReplicatedStorage:WaitForChild("GameLoaded") -- Make a remote event called "GameLoaded" within ReplicatedStorage
local Connection -- For Disconnecting heartbeats. Don't try this in real life!

-- Module Script Functions

Convenience.OnGameLoaded = function(
	GUIFrame: Frame,
	WaitTime: number,
	TweenInf: TweenInfo,
	FirstPosition: UDim2,
	LastPosition: UDim2
) -- Make the frame fit the entire screen atleast. If you encounter positioning problems, add your own position arguements
	-- The first position is the frame outside the screen.
	-- Everything is self explanatory
	if not TweenInf then
		TweenService:Create(GUIFrame, TInfo, { Position = FirstPosition })
	else
		TweenService:Create(GUIFrame, TweenInf, { Position = FirstPosition })
	end
	-- Gee, there sure are a lot of "if" statements!
	if WaitTime then
		wait(tonumber(WaitTime))
		if TweenInf then
			TweenService:Create(GUIFrame, TweenInf, { Position = FirstPosition })
		else
			TweenService:Create(GUIFrame, TInfo, { Position = FirstPosition })
		end
	end
end

-- Now probably don't use these. These arent optimized!

Convenience.ControllerRumble = function(
	VibrationInstensity: number,
	InputType: Enum.UserInputType,
	VibrationMotorSize: Enum.VibrationMotor
)
	HapticService:SetMotor(InputType, VibrationMotorSize, VibrationInstensity)
end

Convenience.StopRumble = function(InputType: Enum.UserInputType, VibrationMotorSize: Enum.VibrationMotor) -- Always remember to stop rumbling!
	HapticService:SetMotor(InputType, VibrationMotorSize, 0)
end

Convenience.DisplayPlayerHeight = function(TextLabel: TextLabel)
	RunService.RenderStepped:Connect(function() -- Not optimal
		local rootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 20)
		if not rootPart then
			error("The Player has literally no HumanoidRootPart! or you could be running the game...")
		end
		local Y_Level = rootPart.CFrame.Position.Y
		TextLabel.Text = "You are" .. tonumber(Y_Level) .. "studs high."
		-- print(tonumber(Y_Level))
		return Y_Level
	end)
end
-- You can reward the player!
Convenience.MakeRewards = function(Modifier: string)
	local newReward = RewardsModifier[Modifier] * Rewards
	return newReward
end

Convenience.ChangeLighting = function(NewClockTime: number, GeographicLocation: number) -- use TweenLighting if you want it to be smoother!
	Lighting.ClockTime = NewClockTime
	Lighting.GeographicLatitude = GeographicLocation
	if not NewClockTime then
		error("Did you forget to specify the ClockTime to change?", 1)
	end
	if not GeographicLocation then
		warn("No Geographic Latitude inputted.")
	end
end

Convenience.DetectPlayerInput = function()
	local PlayerInput
	local LastInput = UserInputService:GetLastInputType()
	-- I know "if" and "elseif" statements are bad but, it should work.
	if LastInput == Enum.UserInputType.Keyboard then
		PlayerInput = LastInput
	elseif LastInput == Enum.UserInputType.Accelerometer then
		PlayerInput = LastInput
	elseif LastInput == Enum.UserInputType.Touch then
		PlayerInput = LastInput
	end
	if not PlayerInput then
		warn("? Theres no player input...")
	end

	return PlayerInput
end

return Convenience
