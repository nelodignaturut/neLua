local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
getgenv().Theme = "Serpent"
--[[
Themes:
LightTheme
DarkTheme
GrapeTheme
BloodTheme
Ocean
Midnight
Sentinel
Synapse
Serpent
]]--
local Window = Library.CreateLib("//nelo's custom//		//turu, tangi, ngecit, repeat//		//內洛//", getgenv().Theme)
local Tab = Window:NewTab("Change Log")
local Section = Tab:NewSection("26/07/2023")
Section:NewLabel("Added sections for each commands")
Section:NewLabel("Changed UI color")
Section:NewLabel("Added InfJump and NoClip scripts")
local Tab = Window:NewTab("Universal Scripts")
local Section = Tab:NewSection("WalkSpeed")
Section:NewTextBox("WalkSpeed", "Input the walkspeed you desire", function(fast_af)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = fast_af
end)
Section:NewDropdown("WalkSpeed Quickchanger", "Walkspeed with preset for certain games", {"16", "30", "40", "50", "75", "90", "100", "200"}, function(suck)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = suck
end)
Section:NewSlider("Walkspeed Slider", "Same thing but slider", 500, 0, function(iShowPeed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = iShowPeed
end)
Section:NewKeybind("30 WalkSpeed", "Keybind for said WalkSpeed", Enum.KeyCode.F1, function()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
end)
Section:NewKeybind("50 WalkSpeed", "Keybind for said WalkSpeed ", Enum.KeyCode.F2, function()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)
Section:NewKeybind("100 WalkSpeed", "Keybind for said WalkSpeed", Enum.KeyCode.F3, function()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)
local Section = Tab:NewSection("CameraZoomDistance")
Section:NewSlider("Zoom Distance", "Increase or decrease max zoom distance", 10000, 500, function(cum)
	game.Players.LocalPlayer.CameraMaxZoomDistance = cum
end)
local Section = Tab:NewSection("AutoJumpEnabled")
Section:NewButton("Disable AutoJumpEnabled", "Disables autojump feature for mobile", function()
	game.Players.LocalPlayer.Character.Humanoid.AutoJumpEnabled = false
end)
Section:NewKeybind("AutoJumpEnabled Keybind", "Keybind for AutoJumpEnabled", Enum.KeyCode.F4, function()
	game.Players.LocalPlayer.Character.Humanoid.AutoJumpEnabled = false
end)
local Section = Tab:NewSection("Scripts")
Section:NewButton("Client-sided Resizable Platform", "Forced on function, Insert to create platform, F4 to resize", function()
	local UIS = game:GetService("UserInputService")
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	local holdingMouse = false
	
	UIS.InputBegan:Connect(function(input)
	    if input.UserInputType==Enum.UserInputType.MouseButton4 then
	        holdingMouse = true
	    end
	end)
	
	UIS.InputEnded:Connect(function(input)
	    if input.UserInputType==Enum.UserInputType.MouseButton4 then
	        holdingMouse = false
	    end
	end)
	
	local function clearAllParts()
	    for _,object in pairs(workspace:GetChildren()) do
	        if object.Name=="PLATFORM" then
	            object:Destroy()
	        end
	    end
	end
	
	local function createPart()
	    local part = Instance.new("Part",workspace)
	    part.Name = "PLATFORM"
	    
	    part.Size = Vector3.new(20,0.5,20)
	    part.Transparency = 0.5
	    
	    part.Anchored = true
	    part.CanCollide = true
	    
	    part.Material = Enum.Material.SmoothPlastic
	    part.TopSurface = Enum.SurfaceType.Smooth
	    part.BottomSurface = Enum.SurfaceType.Smooth
	    
	    part.Position = player.Character.Humanoid.RootPart.Position - Vector3.new(0,1,0)
	    
	    local faces = {
	        {'Front',part.CFrame.LookVector},
	        {'Back',-part.CFrame.LookVector},
	        {'Left',-part.CFrame.RightVector},
	        {'Right',part.CFrame.RightVector},
	        {'Top',part.CFrame.UpVector},
	        {'Bottom',-part.CFrame.UpVector}
	    }
	    for _,face in pairs(faces) do
	        local ball = Instance.new("Part",part)
	        ball.Name = "BALL-".. face[1]
	        
	        ball.Shape = Enum.PartType.Ball
	        
	        ball.Size = Vector3.new(2.5,2.5,2.5)
	        ball.Color = Color3.fromRGB(255,180,0)
	        
	        ball.Anchored = true
	        ball.CanCollide = false
	        
	        ball.Material = Enum.Material.SmoothPlastic
	        ball.TopSurface = Enum.SurfaceType.Smooth
	        ball.BottomSurface = Enum.SurfaceType.Smooth
	        
	        local function updateCFrame(cord)
	            ball.CFrame = part.CFrame + face[2]*(part.Size[cord])/2 + face[2]*2
	            part:GetPropertyChangedSignal("Size"):Connect(function()
	                ball.CFrame = part.CFrame + face[2]*(part.Size[cord])/2 + face[2]*2
	            end)
	        end
	        
	        if face[1]=="Front" or face[1]=="Back" then
	            updateCFrame("Z")
	        end
	        if face[1]=="Left" or face[1]=="Right" then
	           updateCFrame("X")
	        end
	        if face[1]=="Top" or face[1]=="Bottom" then
	            updateCFrame("Y")
	        end
	    end
	    
	    local lastTarget = nil
	    mouse.Move:Connect(function()
	        if mouse.Target then
	            if mouse.Target:IsDescendantOf(part) then
	                lastTarget = mouse.Target
	                mouse.Target.Color = Color3.fromRGB(255,120,0)
	                
	                spawn(function()
	                    while mouse.Target==lastTarget do wait() end
	                    lastTarget.Color = Color3.fromRGB(255,180,0)
	                end)
	            end
	        end
	        if holdingMouse and lastTarget then
	            local ballType = lastTarget.Name:gsub("BALL-","")
	            
	            if ballType=='L-Front' then
	                local distance = ((part.Position.Z+part.Size.Z/2)-mouse.Hit.p.Z)
	                part.Position = part.Position - Vector3.new(0,0,distance-part.Size.Z)/2
	                part.Size = Vector3.new(part.Size.X,part.Size.Y,distance)
	            end
	            if ballType=='L-Back' then
	                local distance = (mouse.Hit.p.Z-(part.Position.Z-part.Size.Z/2))
	                part.Position = part.Position + Vector3.new(0,0,distance-part.Size.Z)/2
	                part.Size = Vector3.new(part.Size.X,part.Size.Y,distance)
	            end
	            if ballType=='L-Left' then
	                local distance = ((part.Position.X+part.Size.X/2)-mouse.Hit.p.X)
	                part.Position = part.Position - Vector3.new(distance-part.Size.X,0,0)/2
	                part.Size = Vector3.new(distance,part.Size.Y,part.Size.Z)
	            end
	            if ballType=='L-Right' then
	                local distance = (mouse.Hit.p.X-(part.Position.X-part.Size.X/2))
	                part.Position = part.Position + Vector3.new(distance-part.Size.X,0,0)/2
	                part.Size = Vector3.new(distance,part.Size.Y,part.Size.Z)
	            end
	            if ballType=='L-Bottom' then
	                local distance = ((part.Position.Y+part.Size.Y/2)-mouse.Hit.p.Y)
	                part.Position = part.Position - Vector3.new(0,distance-part.Size.Y,0)/2
	                part.Size = Vector3.new(part.Size.X,distance,part.Size.Z)
	            end
	            if ballType=='L-Top' then
	                local distance = (mouse.Hit.p.Y-(part.Position.Y-part.Size.Y/2))
	                part.Position = part.Position + Vector3.new(0,distance-part.Size.Y,0)/2
	                part.Size = Vector3.new(part.Size.X,distance,part.Size.Z)
	            end
	        end
	    end)
	end
	
	UIS.InputBegan:Connect(function(input)
	    if input.UserInputType==Enum.UserInputType.MouseButton3 then
	        clearAllParts()
	        createPart()
	    end
	end)
end)
Section:NewButton("InfJump Activate", "Forced on function, press V to toggle on and off", function()
	local infiniteJumpButton = Instance.new("TextButton")
	local function setInfinityJumpButton()
	    local script = Instance.new("LocalScript", infiniteJumpButton)
	
	    infiniteJumpButton.Parent = tab_1
	    infiniteJumpButton.Name = "infinityJumpButton"
	    infiniteJumpButton.Text = "Infinity Jump [V]"
	    infiniteJumpButton.TextScaled = true
	    infiniteJumpButton.Font = Enum.Font.Ubuntu
	    infiniteJumpButton.BackgroundColor3 = Color3.new(1, 0, 0)
	    infiniteJumpButton.Position = UDim2.new(0, 10, 0, 190)
	    infiniteJumpButton.Size = UDim2.new(0.9, 0, 0.05, 0)
	    infiniteJumpButton.BorderColor3 = Color3.new(1, 1, 1)
	
	    local Mouse = game.Players.LocalPlayer:GetMouse()
	    local InfiniteJump = false
	
	    script.Parent.MouseButton1Click:Connect(function()
	        if InfiniteJump == false then
	            InfiniteJump = true
	            script.Parent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	        else
	            InfiniteJump = false
	            script.Parent.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	        end
	    end)
	
	    Mouse.KeyDown:Connect(function(k)
	        if k == "v" then
	            if InfiniteJump == false then
	                InfiniteJump = true
	                script.Parent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	            else
	                InfiniteJump = false
	                script.Parent.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	            end
	        end
	    end)
	
	    game:GetService("UserInputService").JumpRequest:Connect(function()
	        if InfiniteJump == true then
	            game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass 'Humanoid'
	                :ChangeState("Jumping")
	        end
	    end)
	end
	coroutine.wrap(setInfinityJumpButton)()
end)
Section:NewButton("NoClip by KingLuna", "Activates script by KingLuna with toggle function", function()
	local Workspace = game:GetService("Workspace")
	local CoreGui = game:GetService("CoreGui")
	local Players = game:GetService("Players")
	local Noclip = Instance.new("ScreenGui")
	local BG = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Toggle = Instance.new("TextButton")
	local StatusPF = Instance.new("TextLabel")
	local Status = Instance.new("TextLabel")
	local Credit = Instance.new("TextLabel")
	local Plr = Players.LocalPlayer
	local Clipon = false
	
	Noclip.Name = "Noclip"
	Noclip.Parent = game.CoreGui
	
	BG.Name = "BG"
	BG.Parent = Noclip
	BG.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
	BG.BorderColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
	BG.BorderSizePixel = 2
	BG.Position = UDim2.new(0.149479166, 0, 0.82087779, 0)
	BG.Size = UDim2.new(0, 210, 0, 127)
	BG.Active = true
	BG.Draggable = true
	
	Title.Name = "Title"
	Title.Parent = BG
	Title.BackgroundColor3 = Color3.new(0.266667, 0.00392157, 0.627451)
	Title.BorderColor3 = Color3.new(0.180392, 0, 0.431373)
	Title.BorderSizePixel = 2
	Title.Size = UDim2.new(0, 210, 0, 33)
	Title.Font = Enum.Font.Highway
	Title.Text = "Noclip"
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.FontSize = Enum.FontSize.Size32
	Title.TextSize = 30
	Title.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
	Title.TextStrokeTransparency = 0
	
	Toggle.Parent = BG
	Toggle.BackgroundColor3 = Color3.new(0.266667, 0.00392157, 0.627451)
	Toggle.BorderColor3 = Color3.new(0.180392, 0, 0.431373)
	Toggle.BorderSizePixel = 2
	Toggle.Position = UDim2.new(0.152380958, 0, 0.374192119, 0)
	Toggle.Size = UDim2.new(0, 146, 0, 36)
	Toggle.Font = Enum.Font.Highway
	Toggle.FontSize = Enum.FontSize.Size28
	Toggle.Text = "Toggle"
	Toggle.TextColor3 = Color3.new(1, 1, 1)
	Toggle.TextSize = 25
	Toggle.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
	Toggle.TextStrokeTransparency = 0
	
	StatusPF.Name = "StatusPF"
	StatusPF.Parent = BG
	StatusPF.BackgroundColor3 = Color3.new(1, 1, 1)
	StatusPF.BackgroundTransparency = 1
	StatusPF.Position = UDim2.new(0.314285725, 0, 0.708661377, 0)
	StatusPF.Size = UDim2.new(0, 56, 0, 20)
	StatusPF.Font = Enum.Font.Highway
	StatusPF.FontSize = Enum.FontSize.Size24
	StatusPF.Text = "Status:"
	StatusPF.TextColor3 = Color3.new(1, 1, 1)
	StatusPF.TextSize = 20
	StatusPF.TextStrokeColor3 = Color3.new(0.333333, 0.333333, 0.333333)
	StatusPF.TextStrokeTransparency = 0
	StatusPF.TextWrapped = true
	
	Status.Name = "Status"
	Status.Parent = BG
	Status.BackgroundColor3 = Color3.new(1, 1, 1)
	Status.BackgroundTransparency = 1
	Status.Position = UDim2.new(0.580952346, 0, 0.708661377, 0)
	Status.Size = UDim2.new(0, 56, 0, 20)
	Status.Font = Enum.Font.Highway
	Status.FontSize = Enum.FontSize.Size14
	Status.Text = "off"
	Status.TextColor3 = Color3.new(0.666667, 0, 0)
	Status.TextScaled = true
	Status.TextSize = 14
	Status.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
	Status.TextWrapped = true
	Status.TextXAlignment = Enum.TextXAlignment.Left
	
	Credit.Name = "Credit"
	Credit.Parent = BG
	Credit.BackgroundColor3 = Color3.new(1, 1, 1)
	Credit.BackgroundTransparency = 1
	Credit.Position = UDim2.new(0.195238099, 0, 0.866141737, 0)
	Credit.Size = UDim2.new(0, 128, 0, 17)
	Credit.Font = Enum.Font.SourceSans
	Credit.FontSize = Enum.FontSize.Size18
	Credit.Text = "Created by KingLuna"
	Credit.TextColor3 = Color3.new(1, 1, 1)
	Credit.TextSize = 16
	Credit.TextStrokeColor3 = Color3.new(0.196078, 0.196078, 0.196078)
	Credit.TextStrokeTransparency = 0
	Credit.TextWrapped = true
	
	Toggle.MouseButton1Click:connect(function()
		if Status.Text == "off" then
			Clipon = true
			Status.Text = "on"
			Status.TextColor3 = Color3.new(0,185,0)
			Stepped = game:GetService("RunService").Stepped:Connect(function()
				if not Clipon == false then
					for a, b in pairs(Workspace:GetChildren()) do
	                if b.Name == Plr.Name then
	                for i, v in pairs(Workspace[Plr.Name]:GetChildren()) do
	                if v:IsA("BasePart") then
	                v.CanCollide = false
	                end end end end
				else
					Stepped:Disconnect()
				end
			end)
		elseif Status.Text == "on" then
			Clipon = false
			Status.Text = "off"
			Status.TextColor3 = Color3.new(170,0,0)
		end
	end)
end)
Section:NewButton("Click Teleport", "Hold left control + left mouse click to TP", function()
local Plr = game:GetService("Players").LocalPlayer
local Mouse = Plr:GetMouse()
 
Mouse.Button1Down:connect(
    function()
        if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
            return
        end
        if not Mouse.Target then
            return
        end
        Plr.Character:MoveTo(Mouse.Hit.p)
    end)
end)
Section:NewButton("anti afk", "experimental", function()
	local VirtualUser=game:service'VirtualUser'
	game:service('Players').LocalPlayer.Idled:connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
	end)
end)
local Tab = Window:NewTab("World of Aincrad")
local Section = Tab:NewSection("WalkSpeed")
Section:NewDropdown("WalkSpeed Quickchanger", "Walkspeed with preset for certain games", {"16", "22", "25"}, function(gay_ass_aincrad)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = gay_ass_aincrad
end)
Section:NewSlider("Walkspeed Slider", "Same thing but slider", 25, 0, function(slowaf)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = slowaf
end)
Section:NewLabel("WoA used to have a hard limit of 25, sometimes 22")
local Tab = Window:NewTab("Sword Blox Online")
local Section = Tab:NewSection("Scripts")
Section:NewButton("Script for fishing and mining", "ONLY FOR MINING AND FISHING", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/nelodignaturut/neLua/main/sbor.lua"))()
end)
Section:NewLabel("ONLY MINING AND FISHING WORKS UNDETECTED")
local Tab = Window:NewTab("Settings")
local Section = Tab:NewSection("more to be added (custom ui color and more)")
Section:NewKeybind("Toggle UI Keybind", "Rebind user interface toggle, press bound key again to toggle", Enum.KeyCode.F5, function()
	Library:ToggleUI()
end)
local Tab = Window:NewTab("Credits")
local Section = Tab:NewSection("KavoUI Library by xHeptc")
Section:NewLabel("VenyxUI Library by GreenDeno")
Section:NewLabel("NoClip by KingLuna")
Section:NewLabel("SBO:R Script by michaeplays")
Section:NewLabel("nelo's custom by nelodignaturut")
Section:NewButton("All in one button", "Activates all important scripts", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/nelodignaturut/neLua/main/essentials.lua"))()
end)
Section:NewTextBox("TextboxText", "TextboxInfo", function(txt)
	print(txt)
end)
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	print("You just clicked the bind")
end)
Section:NewButton("ButtonText", "ButtonInfo", function()
    print("Clicked")
end)
Section:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
Section:NewButton("rejoin", "ButtonInfo", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)
Section:NewButton("ButtonText", "ButtonInfo", function()
    print("Clicked")
Notify("tap deez", "how many lines?", "yes")
end)
