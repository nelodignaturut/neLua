-- Very Beautiful Ui Lib :D
local library =
    loadstring(game:HttpGet "https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua")()
local venyx = library.new "//Sword Blox Online: Rebirth// //test phase//"
-- //Variables
local User, RepStor = game:GetService "Players".LocalPlayer, game:GetService "ReplicatedStorage"
local MobHolder, LastMobCFrame, HighestPartY, TempDisable, CurrentTarget = {}, {}, {}

-- //Functions
local function IsAlive(Char)
    return Char and Char:IsA "Model" and Char:FindFirstChild "Humanoid" and Char.Humanoid.Health > 0
end

local function spawnloop(func, Delay)
    spawn(
        function()
            while true do
                func()
                task.wait(Delay)
            end
        end
    )
end

-- Anti Mod
do
    for GroupID, Rank in next, {
        ["5683480"] = 212,
        ["5754032"] = 130,
        ["5928691"] = 1,
        ["7171494"] = 1
    } do
        local function PlayerRankCheck(Player)
            repeat
                local d =
                    pcall(
                    function()
                        return Player.GetRankInGroup
                    end
                )
            until task.wait() and d
            if Player:GetRankInGroup(tonumber(GroupID)) >= Rank then
                User:Kick "\nAdmin Detected!"
            end
        end

        game:GetService "Players".PlayerAdded:Connect(PlayerRankCheck)
        for _, player in next, game:GetService "Players":GetChildren() do
            task.spawn(PlayerRankCheck, player)
        end
    end
end
-- 10 Fish Every 4 Mins
do
    spawnloop(
        function()
            game.ReplicatedStorage.CatchFish:FireServer(10)
        end,
        5
    )
end

-- Anti Fling (stole it from the game itself LMFAO)
do
    spawnloop(
        function()
            pcall(
                function()
                    local RooPart = User.Character.HumanoidRootPart
                    if
                        workspace.GameLoader.Options.Floor.Value ~= 14 and
                            User.Character.Humanoid.MoveDirection.Magnitude <= 0 and
                            (RooPart.RotVelocity.Magnitude >= 100 or RooPart.Velocity.Magnitude >= 100)
                     then
                        RooPart.AssemblyLinearVelocity = Vector3.new(1, 1, 1)
                        RooPart.RotVelocity = Vector3.new(1, 1, 1)
                        RooPart.Velocity = Vector3.new(5, 5, 5)
                    end
                end
            )
        end
    )
end
-- Main
do
    local MainPage = venyx:addPage "Main"
    -- Main Section
    do
        local MainSection = MainPage:addSection "Main"
        -- Infinite Stamina
        do
            local Enabled
            MainSection:addToggle(
                "Infinite Stamina",
                nil,
                function(value)
                    Enabled = value
                end
            )
            spawnloop(
                function()
                    pcall(
                        function()
                            if Enabled then
                                User.PlayerGui.GameGui.Stamina.Value = User.PlayerStats.MaxStamina.Value
                            end
                        end
                    )
                end
            )
        end
    -- Collect Materials
    do
        local AutoCollectSection, Enabled = MainPage:addSection "Collect Materials", {}
        if workspace.Materials:GetChildren()[1] then
            for i, v in next, workspace.Materials:GetChildren() do
                if not Enabled[v.Name] then
                    AutoCollectSection:addToggle(
                        v.Name,
                        nil,
                        function(value)
                            Enabled[v.Name] = value
                        end
                    )
                    Enabled[v.Name] = "Added"
                end
            end
            spawnloop(
                function()
                    for i, v in next, workspace.Materials:GetChildren() do
                        pcall(
                            function()
                                if task.wait() and Enabled[v.Name] == true and Enabled and v.Owner.Value == "" then
                                    pcall(
                                        function()
                                            RepStor.ClaimMaterial:InvokeServer(v.Id.Value)
                                        end
                                    )
                                    task.wait(7)
                                end
                            end
                        )
                    end
                end
            )
        else
            AutoCollectSection:addButton(
                "No Materials Found in this Floor",
                function()
                end
            )
        end
    end
    -- Stats
    do
        local StatSection, Stats, Enabled =
            MainPage:addSection "Auto Stat - MIGHT WORK, UNTESTED",
            ("Vitality,Agility,Luck,Strength,Defense"):split ",",
            {}
        for __, Stat in next, Stats do
            StatSection:addToggle(
                Stat,
                nil,
                function(value)
                    Enabled[Stat] = value
                end
            )
        end
        -- Stat Reset
        do
            StatSection:addButton(
                "Reset Stats - WORKS, BUT LOGGED BY ADMIN",
                function()
                    for __, Stat in next, Stats do
                        RepStor.StatsEvent:FireServer(Stat, 0)
                    end
                end
            )
        end
        spawnloop(
            function()
                pcall(
                    function()
                        for Name, IsTrue in next, Enabled do
                            if IsTrue and User.PlayerStats.LevelPoints.Value > 0 then
                                RepStor.StatsEvent:FireServer(Name, User.PlayerStats[Name].Value + 1)
                            end
                        end
                    end
                )
            end
        )
    end
end
-- Auto Craft
do
    local AutoCraftPage = venyx:addPage "Auto Craft"
    -- Items
    do
        local Enabled, Sections, NameHolder, Lvls = {}, {}, {}, {}
        local Stuff = RepStor.CraftingRecipes:GetChildren()
        table.sort(
            Stuff,
            function(a, b)
                return a.CraftingSkill.Value < b.CraftingSkill.Value
            end
        )

        local function IsExcluded(Item)
            for _, name in next, {
                "Easter Egg",
                "Refined Egg",
                "Turkey Feather",
                "Candy Corn",
                "Mage Robe Smooth White",
                "Mage Robe Crinkled White",
                "Mage Hat Crinkled White",
                "Mage Hat Smooth White",
                "Bunny Tail",
                "Antlers Overlay",
                "Top Hat White Overlay",
                "Winter White Scarf Overlay",
                "Santa White Hat Overlay",
                "Rabbit Pelt Pink Overlay",
                "White Bunny Ears",
                "Sickly Beak"
            } do
                if Item:FindFirstChild(name) or Item.Name == name then
                    return true
                end
            end
        end

        for _, v in next, Stuff do
            if not IsExcluded(v) then
                local lvl = tostring(v.CraftingSkill.Value)
                if not Sections[lvl] then
                    Sections[lvl] = AutoCraftPage:addSection("Lvl Requirement: " .. lvl)
                end
                if not NameHolder[lvl] then
                    NameHolder[lvl] = {}
                end
                table.insert(NameHolder[lvl], v.Name)
                if not table.find(Lvls, v.CraftingSkill.Value) then
                    table.insert(Lvls, v.CraftingSkill.Value)
                end
            end
        end
        table.sort(Lvls)
        venyx:Notify("Notification", "Loading Auto Craft...")
        for _, Lvl in next, Lvls do
            Lvl = tostring(Lvl)
            table.sort(NameHolder[Lvl])
            for _, Name in next, NameHolder[Lvl] do
                print(Lvl, Name)
                Sections[Lvl]:addToggle(
                    Name,
                    nil,
                    function(value)
                        Enabled[Name] = value
                    end
                )
            end
        end
        venyx:Notify("Notification", "Auto Craft Loaded!")
        local Stats = User.PlayerStats
        local Inven, SmitSkill = Stats.Inventory, Stats.SmithingSkill

        local function GetItemData(item)
            return RepStor.CraftingRecipes:FindFirstChild(item)
        end

        local function EnoughMaterials(Material)
            for i, v in next, Inven.Value:split "," do
                if v:split "|"[1] == Material.Name and Material.Value <= tonumber(v:split "|"[2]) then
                    return true
                end
            end
        end

        local function GotMaterials(item)
            for i, Material in next, GetItemData(item):GetChildren() do
                if
                    Material.Name ~= "CraftingSkill" and Material:IsA "NumberValue" and
                        (not string.find(Inven.Value, Material.Name) or not EnoughMaterials(Material))
                 then
                    return false
                end
            end
            return true
        end

        local function CanCraft(item)
            if GetItemData(item) and GetItemData(item).CraftingSkill.Value <= SmitSkill.Value and GotMaterials(item) then
                return true
            end
        end

        spawnloop(
            function()
                pcall(
                    function()
                        for item, IsTrue in next, Enabled do
                            if IsTrue and task.wait() and CanCraft(item) then
                                RepStor.CraftingStart:InvokeServer()
                                task.wait(0.1)
                                RepStor.CraftingEnded:InvokeServer("SmithingSkill", item, true)
                            end
                        end
                    end
                )
            end
        )
    end
end
-- Theme
do
    local colors = venyx:addPage "Theme":addSection "Colors"
    for theme, color in pairs {
        Background = Color3.fromRGB(24, 24, 24),
        Glow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(10, 10, 10),
        LightContrast = Color3.fromRGB(20, 20, 20),
        DarkContrast = Color3.fromRGB(14, 14, 14),
        TextColor = Color3.fromRGB(255, 255, 255)
    } do
        colors:addColorPicker(
            theme,
            color,
            function(color3)
                venyx:setTheme(theme, color3)
            end
        )
    end
end
venyx:Notify("EXPERIMENTAL SCRIPT", "trying to add toggle UI")
venyx:SelectPage(venyx.pages[1], true)
