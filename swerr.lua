-- MainUI.lua
-- واجهة باستخدام RedzLib

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "Demo Hub",
    SubTitle = "By ابراهيم",
    SaveFolder = "MyHub"
})

-- زر تصغير/خروج
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- أول ما يشتغل السكربت
game.StarterGui:SetCore("SendNotification", {
    Title = "تنبيه",
    Text = "ابراهيم عمك لك 😎",
    Duration = 5
})

-- تبويب رئيسي
local Tab = Window:MakeTab({"Main","🛠️"})

-------------------------------
-- زر الطيران
-------------------------------
local flying = false
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

Tab:AddButton({
    Name = "تشغيل/إيقاف الطيران",
    Callback = function()
        flying = not flying
    end
})

RS.RenderStepped:Connect(function(delta)
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = player.Character.HumanoidRootPart
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end
        HRP.CFrame = HRP.CFrame + moveDir * 50 * delta
    end
end)

-------------------------------
-- زر إخفاء/إظهار
-------------------------------
local hidden = false

Tab:AddButton({
    Name = "إخفاء/إظهار اللاعب",
    Callback = function()
        hidden = not hidden
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.HumanoidRootPart.Transparency = hidden and 1 or 0
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = hidden and 1 or 0
                end
            end
        end
    end

})
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)

-- زر لفتح قائمة اللاعبين
local openButton = Instance.new("TextButton", gui)
openButton.Size = UDim2.new(0,150,0,50)
openButton.Position = UDim2.new(0,10,0,10)
openButton.Text = "Players List"

-- إطار للاعبين
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,300)
frame.Position = UDim2.new(0,10,0,70)
frame.Visible = false

openButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- تحديث قائمة اللاعبين
local function updatePlayers()
    frame:ClearAllChildren()
    for i, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(1,0,0,30)
            btn.Position = UDim2.new(0,0,0,(i-1)*35)
            btn.Text = plr.Name

            btn.MouseButton1Click:Connect(function()
                -- نقل اللاعب إليك
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                end
            end)
        end
    end
end

-- حدث لإعادة تحديث القائمة عند دخول لاعب جديد
game.Players.PlayerAdded:Connect(updatePlayers)
game.Players.PlayerRemoving:Connect(updatePlayers)

-- التحديث الأولي
updatePlayers()

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)

-- زر لاختيار الأغنية
local songButton = Instance.new("TextButton", gui)
songButton.Size = UDim2.new(0,200,0,50)
songButton.Position = UDim2.new(0,10,0,10)
songButton.Text = "Play Song"

-- إطار للاختيار
local songId = "rbxassetid://معرف_الأغنية" -- استبدل بالـ ID الخاص بالأغنية
local startTime = 30  -- وقت البداية بالثواني
local endTime = 60    -- وقت النهاية بالثواني

local function playSongForAll()
    -- نحذف أي صوت موجود سابقًا
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Sound") and obj.Name == "GlobalSong" then
            obj:Destroy()
        end
    end

    -- نضيف الصوت للـ workspace
    local sound = Instance.new("Sound", workspace)
    sound.Name = "GlobalSong"
    sound.SoundId = songId
    sound.Looped = true
    sound.TimePosition = startTime
    sound:Play()

    -- نعمل تحديث وقت النهاية
    sound:GetPropertyChangedSignal("TimePosition"):Connect(function()
        if sound.TimePosition >= endTime then
            sound.TimePosition = startTime
        end
    end)
end

songButton.MouseButton1Click:Connect(playSongForAll)
