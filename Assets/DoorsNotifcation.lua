-- thx to the mspaint devs for this
return function(OptionsTable)
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local NotifcationSettings = {
		Title = OptionsTable.Title,
		Description = OptionsTable.Description,
		Reason = OptionsTable.Reason,
		NotificationType = OptionsTable.NotificationType,
		Image = OptionsTable.Image,
		Color = nil,
		Time = OptionsTable.Time,
		TweenDuration = 0.8
	}

	if NotifcationSettings.NotificationType == nil then
		NotifcationSettings.NotificationType = "NOTIFICATION"
	end
	local Achievement = LocalPlayer.PlayerGui.MainUI["AchievementsHolder"].Achievement:Clone()
	Achievement.Size = UDim2.new(0, 0, 0, 0)
	Achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	Achievement.Name = "LiveAchievement"
	Achievement.Visible = true
	Achievement.Frame.TextLabel.Text = NotifcationSettings.NotificationType
	if NotifcationSettings.NotificationType == "WARNING" then
		Achievement.Frame.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		Achievement.Frame.UIStroke.Color = Color3.fromRGB(255, 0, 0)
		Achievement.Frame.Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
	end
	Achievement.Frame.Details.Desc.Text = tostring(NotifcationSettings.Description)
	Achievement.Frame.Details.Title.Text = NotifcationSettings.Title
	Achievement.Frame.Details.Reason.Text = tostring(NotifcationSettings.Reason or "")
	Achievement.Frame.ImageLabel.BackgroundTransparency = 0
	if NotifcationSettings.Image ~= nil then
		if NotifcationSettings.Image:match("rbxthumb://") or NotifcationSettings.Image:match("rbxassetid://") then
			Achievement.Frame.ImageLabel.Image = tostring(NotifcationSettings.Image or "rbxassetid://0")
		else
			Achievement.Frame.ImageLabel.Image = NotifcationSettings.Image
		end
	else
		Achievement.Frame.ImageLabel.Image = "rbxassetid://6023426923"
	end
	Achievement.Parent = LocalPlayer.PlayerGui.MainUI["AchievementsHolder"]
	Achievement.Sound.SoundId = "rbxassetid://10469938989"
	Achievement.Sound.Volume = Options.NotificationSoundVolume.Value/3
	Achievement.Sound:Play()
	task.spawn(function()
		Achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", NotifcationSettings.TweenDuration, true)
		task.wait(0.8)
		Achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
		TweenService:Create(Achievement.Frame.Glow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
			ImageTransparency = 1
		}):Play()
		if NotifcationSettings.Time ~= nil then
			if typeof(NotifcationSettings.Time) == "number" then
				task.wait(NotifcationSettings.Time)
			elseif typeof(NotifcationSettings.Time) == "Instance" then
				NotifcationSettings.Time.Destroying:Wait()
			end
		else
			task.wait(8)
		end
		Achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:Destroy()
	end)
end
