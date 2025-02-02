getgenv().autoPickCard = true
getgenv().focusCardPriority = {
    "New Path",
    "Enemy Shield III",
    "Enemy Health III",
    "Enemy Regen III",
    "Range III",
    "Random Curses III",
    "Enemy Health II",
    "Enemy Shield II",
    "Enemy Regen II",
    "Attack III",
    "Random Curses II",
    "Random Curses I",
    "Enemy Health I",
    "Range II",
    "Enemy Regen I",
    "Enemy Speed II",
    "Enemy Shield I",
    "Enemy Speed I",
    "Attack II",
    "Enemy Speed III",
    "Range I",
    "Cooldown III",
    "Attack I",
    "Cooldown II",
    "Cooldown I",
    "Boss Damage III",
    "Boss Damage II",
    "Boss Damage I",
    "Yen II",
    "Yen I",
    "Double Range",
    "Double Attack",
    "Double Cooldown",
    "Random Blessings III",
    "Random Blessings II",
    "Random Blessings I",
    "Explosive Deaths I",
    "Explosive Deaths II",
    "Explosive Deaths III",
    "Active Cooldown II",
    "Active Cooldown I"
}

repeat task.wait() until game:IsLoaded()
repeat wait(0.25) until game:IsLoaded() 
    and game.Players.LocalPlayer.Character 
    and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") 
    and game.Players.LocalPlayer:FindFirstChild("PlayerGui") 
    and pcall(function() return game.Players.LocalPlayer.Idled end)

if game.gameId == 3183403065 and game.PlaceId ~= 8304191830 then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    repeat task.wait(1)
        for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.VoteStart.Holder.ButtonHolder.Yes.Activated)) do
            v.Function()
            wait(1)
        end
    until playerGui:FindFirstChild("VoteStart").Enabled == false
    print("passed vote start")

    local function findPriorityCard(roguelikeSelect, focusCardPriority)
        local mainFrame = roguelikeSelect:FindFirstChild("Main")
        if mainFrame then
            local itemsFrame = mainFrame:WaitForChild("Main"):FindFirstChild("Items")
            if itemsFrame then

                local optionFrames = {}
                for _, child in ipairs(itemsFrame:GetChildren()) do
                    if child:IsA("Frame") and child:FindFirstChild("bg") then
                        table.insert(optionFrames, child)
                    end
                end

                for _, cardName in ipairs(focusCardPriority) do
                    for index, optionFrame in ipairs(optionFrames) do
                        if optionFrame:IsA("Frame") and optionFrame:FindFirstChild("bg") then
                            local bgFrame = optionFrame:FindFirstChild("bg")
                            local main = bgFrame:FindFirstChild("Main")
                            if main then
                                local title = main:FindFirstChild("Title")
                                if title then
                                    local textLabel = title:FindFirstChild("TextLabel")
                                    if textLabel and string.match(textLabel.Text, cardName) then
                                        print("Found:", cardName, "at OptionFrame", index)
                                        return index, cardName 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil, nil
    end

    task.spawn(function()
        while true do task.wait(1)
            if getgenv().autoPickCard then
                local roguelikeSelect = playerGui:WaitForChild("RoguelikeSelect", 5)
                if roguelikeSelect and roguelikeSelect.Enabled then
                    local index, cardName = findPriorityCard(roguelikeSelect, focusCardPriority)
                    if index then
                        -- print(index, cardName, typeof(index))
                        if index == 2 then
                            index = 3
                        elseif index == 3 then
                            index = 2
                        end
                        repeat task.wait(0.5)
                            game:GetService("ReplicatedStorage").endpoints.client_to_server.select_roguelike_option:InvokeServer(tostring(index))
                        until not roguelikeSelect or not roguelikeSelect.Enabled or not getgenv().autoPickCard
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do task.wait(1)
            if game:GetService("Workspace")["_DATA"].GameFinished.Value == true then
                if game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.Visible == true then
                    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Holder.Buttons.Next.Activated)) do
                        v.Function()
                        wait(1)
                    end  
                else
                    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ResultsUI.Finished.NextRetry.Activated)) do
                        v.Function()
                        wait(1)
                    end
                end
            end
        end
    end)
end

local antiafk = getconnections or get_signal_cons;
if antiafk then
	for i, v in pairs(antiafk(game.Players.LocalPlayer.Idled)) do
		if v["Disable"] then
			v["Disable"](v);
		elseif v["Disconnect"] then
			v["Disconnect"](v);
		end;
	end;
	for i, v in next, antiafk(game.Players.LocalPlayer.Idled) do
		v:Disable();
	end;
    warn("Anti AFK Already Loaded");
else
	game.Players.LocalPlayer:Kick("Missing getconnections() functions executer not supported");
end;
