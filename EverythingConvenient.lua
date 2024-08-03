--!strict
--[[

https://github.com/BoredDynasty/BoredDynasty.Convenience/tree/main
Please don't copy this
Dynasty here!

This script is used to make almost everything convenient! 
What I mean is you dont have to write so much, 
you can require this module and call any function and write a few variables yourself. 
	Simple, right?
If you don't create the things required to run this module script, somethings won't work. tostring("And some things will not work!")

Ill comment my script if you have to make something in a certain area of your Roblox Game.

Used for making everything convenient so you don't have to write too many scripts for your game

Over [tonumber(400)] Lines of Code! [Thats alot for me!]


                                                    >THIS IS NOT OPTIMIZED<

Module Script
Place in ReplicatedStorage
--]]

-- Variables
local Convenience = {}
local ConvenienceSettings = {
	PrintingEnabled = true, -- We'll sometimes ignore this for your own benefit.
	CustomCode = false,
}

do
	return ConvenienceSettings -- So you can set your own settings in a different script!
end

local ReplicatedStorage = game:GetService('ReplicatedStorage');
local HttpService = game:GetService('HttpService');
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

local cachedInputs = {} -- So we don't have so much changed events going on

local keyToVibration = { -- Left Stick and Right Stick Vibrations
	[Enum.KeyCode.ButtonL2] = Enum.VibrationMotor.Small, -- Maybe for running
	[Enum.KeyCode.ButtonR2] = Enum.VibrationMotor.Large, -- Maybe for Driving
}

local TInfo = TweenInfo.new( -- Default TweenInfo
	1,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut
)

-- Things
local OnGameLoaded = ReplicatedStorage:WaitForChild("GameLoaded") -- Make a remote event called "GameLoaded" within ReplicatedStorage
if not OnGameLoaded then
	local OGL = Instance.new("RemoteEvent", ReplicatedStorage)
	OGL.Name = "GameLoaded"
	if ConvenienceSettings.PrintingEnabled == true then
		print("We've created a Remote Event in ReplicatedStorage called - " .. OGL.Name)
	end
end
local Connection -- For Disconnecting heartbeats. Don't try this in real life!

-- Module Script Functions
Convenience.OnGameLoaded = function(
	CustomCode,
	GUIFrame: Frame,
	WaitTime: number,
	TweenInf: TweenInfo,
	FirstPosition: UDim2,
	LastPosition: UDim2
) -- Make the frame fit the entire screen atleast. If you encounter positioning problems, add your own position arguements
	-- The first position is the frame outside the screen.
	-- Everything is self explanatory
	if ConvenienceSettings.CustomCode == false then
		if not TweenInf then
			TweenService:Create(GUIFrame, TInfo, { Position = LastPosition })
		else
			TweenService:Create(GUIFrame, TweenInf, { Position = LastPosition })
		end
		-- Gee, there sure are a lot of "if" statements!
		if WaitTime then
			task.wait(tonumber(WaitTime))
			if TweenInf then
				TweenService:Create(GUIFrame, TweenInf, { Position = FirstPosition })
			else
				TweenService:Create(GUIFrame, TInfo, { Position = FirstPosition })
			end
		end
	else
		if not CustomCode then
			if ConvenienceSettings.PrintingEnabled == true then
				warn("You must input a function within the parameter if you want custom code!")
			end
		end
		CustomCode()
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
-- I think this is optimized since I got it from the docs. https://create.roblox.com/docs/reference/engine/classes/HapticService#SetMotor
Convenience.StickRumble = function(input)
	if not cachedInputs[input] then
		local inputType = input.UserInputType
		if inputType.Name:find("Gamepad") then
			local vibrationMotor = keyToVibration[input.KeyCode]
			if vibrationMotor then
				local function onChanged(property)
					if property == "Position" then
						HapticService:SetMotor(inputType, vibrationMotor, input.Position.Z)
					end
				end
				cachedInputs[input] = input.Changed:Connect(onChanged)
			end
		end
	end
end

Convenience.DisplayPlayerHeight = function(TextLabel: TextLabel)
	if TextLabel then
		Connection = RunService.Heartbeat:Connect(function() -- Not optimal
			local rootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 20)
			if not rootPart then
				if ConvenienceSettings.PrintingEnabled == true then
					print("The Player has no HumanoidRootPart?")
				end
			end
			local Y_Level = rootPart.CFrame.Position.Y
			TextLabel.Text = "You are" .. tonumber(Y_Level) .. "studs high."
			-- print(tonumber(Y_Level))
			return Y_Level
		end)
	else
		while true do
			task.wait(4) -- So we don't exhaust the script
			print(tonumber(LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.Position.Y)) -- If you don't provide that, we'll just print it!
		end
	end
end

Players.PlayerRemoving:Connect(function()
	Connection:Disconnect() -- so no memory leak
	if ConvenienceSettings.PrintingEnabled == true then
		print("Disconnecting Heartbeat... - " .. LocalPlayer.DisplayName)
	end
end)

-- You can reward the player!
-- Make your own datastore if ya want. Theres other modules scripts that do that better than mines
Convenience.MakeRewards = function(Modifier: string)
	local newReward = RewardsModifier[Modifier] * Rewards
	if ConvenienceSettings.PrintingEnabled == true then
		print("Made new player reward... - x" .. Modifier)
	end
	return newReward
end

Convenience.ChangeLighting = function(NewClockTime: number, GeographicLocation: number) -- use TweenLighting if you want it to be smoother!
	Lighting.ClockTime = NewClockTime
	Lighting.GeographicLatitude = GeographicLocation
	if not NewClockTime then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("Did you forget to provide the New Clock Time?")
		end
	end
	if not GeographicLocation then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("Did you forget to provide the new Geographic Latitude?")
		end
	end
end

Convenience.TweenLighting = function(TweenInf: TweenInfo, NewClockTime: number, GeographicLocation: number) -- use TweenLighting if you want it to be smoother!
	if not TweenInf then
		TweenService:Create(Lighting, TInfo, { ClockTime = NewClockTime })
		TweenService:Create(Lighting, TInfo, { GeographicLocation = NewClockTime })
	else
		TweenService:Create(Lighting, TweenInf, { ClockTime = NewClockTime })
		TweenService:Create(Lighting, TweenInf, { GeographicLatitude = GeographicLocation })
	end

	if not NewClockTime then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("Did you forget to provide the New Clock Time? [Tween]")
		end
	end
	if not GeographicLocation then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("Did you forget to provide the new Geographic Latitude? [Tween]")
		end
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
		if ConvenienceSettings.PrintingEnabled == true then
			print("Theres no player User Input. This script uses -- :GetLastInputType()")
		end
	end
	return PlayerInput
end

Convenience.DeleteSomething = function(args) -- Could just do it yourself but, might as well!
	if args then
		args:Destroy()
	end
	if not args then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("You can't Destroy() nothing")
		end
	end
end

Convenience.AddElement = function(Element: any, Parent: any, Properties: any) -- Make an Element. Almost anything infact
	if not Parent then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("You did not add a Parent to the newly created Element.")
		end
		return
	end
	if not Element then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("Theres no new Element to be created.")
		end
	end
	if not Properties then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("No properties to be inputted.")
		end
	end
	local NewElement = Instance.new(Element, Parent) -- Make sure to parent it to something.
	NewElement.Properties = Properties -- Make sure it has properties! Like Size, Position etc...
end

Convenience.AddNewImage = function(ImageID: any, ImagePosition: UDim2)
	local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
	local NewImage = Instance.new("ImageLabel", gui)
	gui.Name = "NewImage_Convenience"
	NewImage.Image = ImageID
	NewImage.Position = ImagePosition
end

Convenience.TweenElement = function(Element: GuiObject, Tween: TweenInfo, Position: UDim2, Size: UDim2)
	if Position and Size and Tween then
		TweenService:Create(Element, Tween, { Position = Position })
		TweenService:Create(Element, Tween, { Size = Size })
	end
	-- are you serious ._.
	if not Tween and Size then
		TweenService:Create(Element, TInfo, { Position = Position })
	end
	if not Tween and Position then
		TweenService:Create(Element, TInfo, { Size = Size })
	end
	if not Position then
		TweenService:Create(Element, Tween, { Size = Size })
	end
	if not Size then
		TweenService:Create(Element, Tween, { Size = Size })
	end

	if not Position and Size and Tween then
		if ConvenienceSettings.PrintingEnabled == true then
			warn("You have to input something to Tween " .. Element.Name)
		end
	end
end

Convenience.AddNewTag = function(TagName: string, TaggedObject: any)
	if not TagName then
		if ConvenienceSettings.PrintingEnabled == true then
			error("Theres no Tag Name inputted!", 2)
		end
	end
	CollectionService:AddTag(TaggedObject, TagName)
	if ConvenienceSettings.PrintingEnabled == true then
		print("Added new Tag to - " .. TaggedObject)
	end
end

-- We can't do GetSecret() for security reasons...

Convenience.NewHTTP = function(URL: string, NewFunction: any, ErrorHandling: any) -- Becareful when using HTTP Service. Anything can happen. Becareful.
	if not NewFunction then
		error("THERE WAS NO CUSTOM FUNCTION INPUTTED FOR HTTP", 3)
	end
	local function MakeNewHTTP()
		local response
		local data

		pcall(function()
			response = HttpService:GetAsync(URL)
			data = HttpService:JSONDecode(response)
		end)

		if not data then
			return false
		end

		if data.message == "succes" then
			NewFunction()
		end
		MakeNewHTTP()
		return MakeNewHTTP()
	end
end

Convenience.MakeNewPasteBinPost = function(URL_PASTEBIN_NEW_PASTE: string, dataFields: table) -- BECAREFUL WHEN USING HTTP ANYTHING COULD HAPPEN
	if not URL_PASTEBIN_NEW_PASTE then
		error("Your new paste has no string?", 3)
	end
	if not dataFields then
		error("How can we Encode your dataFields if there is nothing in it?", 3)
	end
	local data = ""

	for k, v in pairs(dataFields) do
		data = data .. ("&%s=%s"):format(HttpService:UrlEncode(k), HttpService:UrlEncode(v))
	end
	data:sub(2) -- Remove the first "&"

	if ConvenienceSettings.PrintingEnabled == true then
		print(tostring(data))
	end

	local response =
		HttpService:PostAsync(URL_PASTEBIN_NEW_PASTE, data, Enum.HttpContentType.ApplicationUrlEncoded, false)
	if ConvenienceSettings.PrintingEnabled == true then
		print(tostring(response))
	end
end

if Convenience.NewHTTP() then
	if ConvenienceSettings.PrintingEnabled == true then
		print("HTTP Request Success.")
	else
		error("HTTP REQUEST FAILED", 3)
	end
end

Convenience.MakeNewGUID = function(CurlyBraces: boolean) -- Curly Braces are {} <-- those were curly braces
	local result = HttpService:GenerateGUID(CurlyBraces)
	if ConvenienceSettings.PrintingEnabled == true then
		print(tostring(result))
	end
	return result
end

Convenience.JSONDecode = function(jsonString: string, NewFunction: any)
	if not jsonString then
		error("JSON string is nil!", 3)
	end
	if not NewFunction then
		error("You must have a function if (data) is success!")
	end
	local data = HttpService:JSONDecode(jsonString)

	if data.message == "success" then
		NewFunction()
	end
end

Convenience.JSONEncode = function(tab: table)
	local JSON = HttpService:JSONEncode(tab)
	if ConvenienceSettings.PrintingEnabled == true then
		print(tostring(JSON))
	end
end

Convenience.URLEncode = function(URL: string, NewFunction: any)
	if not NewFunction then
		local result = HttpService:UrlEncode(URL)
		print(result)
	end
	local result = HttpService:UrlEncode(URL)
	NewFunction(result)
	return result
end
-- You should've figured out Headers yourself
-- The body you should've encoded yourself
Convenience.NewHTTPRequest = function(URL: string, Method: string, Headers: any, Body: any)
	local function request()
		local response = HttpService:RequestAsync({
			URL,
			Method,
			Headers,
			Body,
		})
		if response.Success then
			print("Status code:", response.StatusCode, response.StatusMessage)
			print("Response body:\n", response.Body)
		else
			print("The request failed:", response.StatusCode, response.StatusMessage)
		end
	end

	local success, message = pcall(request) -- wrap in a pcall so it doesn't break that would be bad.
	if not success then
		print("Http Request failed:", message)
	end
end



return Convenience
