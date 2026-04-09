return function(Text, PlaySound)
	if typeof(PlaySound) ~= "boolean" then
		PlaySound = true
	end
	    local CaptionValue = Instance.new("NumberValue", game:GetService("CoreGui"))
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local TweenService = game:GetService("TweenService")
		local MainUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI")
		local Caption = MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
		local CaptionSound = MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")
		Caption.Destroying:Connect(function()
        CaptionValue:Destroy()
        end)
        for i,Child in pairs(MainUI:GetChildren()) do
			if Child.Name == "LiveCaption" then
				Child:Destroy()
			end
		end
		Caption.Parent = MainUI
		Caption.Visible = true
		Caption.Name = "LiveCaption"
		Caption.Text = Text
		if PlaySound then
			CaptionSound:Play()
		end
		local HolderTween = TweenService:Create(CaptionValue, TweenInfo.new(3), {Value = 100})
		HolderTween:Play()
		HolderTween.Completed:Connect(function()
			CaptionValue:Destroy()
            TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
			TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
		end)
end
