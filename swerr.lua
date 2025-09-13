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