return function(Tab)
	local Global = getgenv()
	local CloneReference = function(Object)
		if cloneref and typeof(cloneref) == "function" then
			return cloneref(Object)
		else
			return Object
		end
	end

	local Players = CloneReference(game:GetService("Players"))
	local LocalPlayer = Players.LocalPlayer
	local UserInfo = Tab:AddLeftGroupbox("User Info")
	local UserIcon = UserInfo:AddImage("UserIcon", {
		Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
		Transparency = 0,
		Color = Color3.new(1, 1, 1),
		RectOffset = Vector2.zero,
		RectSize = Vector2.zero,
		ScaleType = Enum.ScaleType.Fit,
		Height = 200,
	})

	UserInfo:AddLabel("User: " .. LocalPlayer.DisplayName .. " (" .. LocalPlayer.Name .. ")")
	UserInfo:AddLabel("Total Executions: " .. shared.DataManager:GetData("TotalExecutions"))
	UserInfo:AddButton({
		Text = "Copy Server Join Code",
		DoubleClick = false,
		Tooltip = 'Copies a script that others can run in their executor to join your server.',
		Func = function()
			local Success, Error = pcall(function()
				toclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game:GetService("Players").LocalPlayer)')
			end)
			if Success then
				Library:Notify("Link copied!")
			else
				Library:Notify("Failed to copy link: " .. Error)
			end
		end,
	})

	local ExecutorInfo = Tab:AddLeftGroupbox("Executor Info")
	local FunctionSupport = Tab:AddRightGroupbox("Function Support")
	ExecutorInfo:AddLabel("Executor: " .. Global.ExecutorSupport_Executor)
	ExecutorInfo:AddLabel("Time Taken: " .. Global.ExecutorSupport_TimeTaken .. " seconds")
	ExecutorInfo:AddLabel("Tests Passed: " .. Global.ExecutorSupport_TestsPassed)
	
	local Failed = {}
	local Passed = {}
	
	for Index, Value in pairs(Global.ExecutorSupport) do
		if Value then
			table.insert(Passed, Index)
		else
			table.insert(Failed, Index)
		end
	end

	for Index, Value in pairs(Passed) do
		FunctionSupport:AddLabel("✅ " .. Value)
		task.wait()
	end
	task.wait()
	for Index, Value in pairs(Failed) do
		FunctionSupport:AddLabel("❌ " .. Value)
		task.wait()
	end
end
