--[[
Visual Player Hub - Roblox Lua Script
Autor: nickainzn (github.com/nickainzn)
Imagem do botão: 131149676605839
Imagem jumpscare: 107299502228775
Para uso apenas local (LocalScript), efeitos visuais aparecem só para quem executa.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PREFIX = "!hub" -- Prefixo usado para chat

-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VisualPlayerHub"
ScreenGui.Parent = game:GetService("CoreGui")

-- Estilos
local BLACK = Color3.fromRGB(0,0,0)
local BORDER = Color3.fromRGB(20,20,20)
local TRANSPARENT = 0.7
local CORNER_RADIUS = UDim.new(0,14)
local SELECTED_COLOR = Color3.fromRGB(50,50,200)

local function Roundify(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = CORNER_RADIUS
    corner.Parent = obj
end

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.Position = UDim2.new(1,-60,0,10)
OpenBtn.AnchorPoint = Vector2.new(0,0)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Image = "rbxassetid://131149676605839"
OpenBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0,340,0,460)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -230)
MainFrame.BackgroundColor3 = BLACK
MainFrame.BackgroundTransparency = TRANSPARENT
MainFrame.BorderColor3 = BORDER
MainFrame.BorderSizePixel = 2
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Roundify(MainFrame)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 28
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Size = UDim2.new(0,36,0,36)
CloseBtn.Position = UDim2.new(1,-40,0,4)
CloseBtn.BackgroundTransparency = 0.7
CloseBtn.BackgroundColor3 = BLACK
CloseBtn.BorderColor3 = BORDER
CloseBtn.Parent = MainFrame
Roundify(CloseBtn)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Player Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.new(1,1,1)
Title.Size = UDim2.new(1, -10, 0, 40)
Title.Position = UDim2.new(0,5,0,10)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local PlayerDrop = Instance.new("Frame")
PlayerDrop.Name = "PlayerDrop"
PlayerDrop.Size = UDim2.new(0.95,0,0,48)
PlayerDrop.Position = UDim2.new(0.025,0,0,54)
PlayerDrop.BackgroundTransparency = 0.3
PlayerDrop.BackgroundColor3 = BLACK
PlayerDrop.BorderColor3 = BORDER
PlayerDrop.BorderSizePixel = 2
PlayerDrop.Parent = MainFrame
Roundify(PlayerDrop)

local DropLabel = Instance.new("TextLabel")
DropLabel.Text = "Selecionar Jogador:"
DropLabel.Font = Enum.Font.Gotham
DropLabel.TextSize = 16
DropLabel.TextColor3 = Color3.new(1,1,1)
DropLabel.Size = UDim2.new(0.6,0,1,0)
DropLabel.Position = UDim2.new(0,10,0,0)
DropLabel.BackgroundTransparency = 1
DropLabel.Parent = PlayerDrop

local PlayerSelect = Instance.new("ScrollingFrame")
PlayerSelect.Name = "PlayerSelect"
PlayerSelect.Size = UDim2.new(0.35,0,1,-10)
PlayerSelect.Position = UDim2.new(0.6,0,0,5)
PlayerSelect.BackgroundColor3 = BLACK
PlayerSelect.BackgroundTransparency = 0.4
PlayerSelect.BorderColor3 = BORDER
PlayerSelect.BorderSizePixel = 2
PlayerSelect.CanvasSize = UDim2.new(0,0,0,0)
PlayerSelect.ScrollBarThickness = 4
PlayerSelect.Parent = PlayerDrop
Roundify(PlayerSelect)

local SelectedPlayer = Instance.new("StringValue")
SelectedPlayer.Name = "SelectedPlayer"
SelectedPlayer.Parent = PlayerDrop
SelectedPlayer.Value = ""

local function HighlightSelected()
    for _,btn in ipairs(PlayerSelect:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = (btn.Name == SelectedPlayer.Value) and SELECTED_COLOR or BLACK
        end
    end
end

local function UpdatePlayers()
    PlayerSelect:ClearAllChildren()
    local y = 0
    for _,plr in ipairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton")
        btn.Text = plr.Name
        btn.Name = plr.Name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Size = UDim2.new(1,0,0,28)
        btn.Position = UDim2.new(0,0,0,y)
        btn.BackgroundColor3 = (plr.Name == SelectedPlayer.Value) and SELECTED_COLOR or BLACK
        btn.BorderColor3 = BORDER
        btn.BorderSizePixel = 2
        Roundify(btn)
        btn.Parent = PlayerSelect
        y = y + 32
        btn.MouseButton1Click:Connect(function()
            SelectedPlayer.Value = plr.Name
            HighlightSelected()
        end)
    end
    PlayerSelect.CanvasSize = UDim2.new(0,0,0,y)
end

Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
SelectedPlayer.Changed:Connect(HighlightSelected)
UpdatePlayers()

local OptionsFrame = Instance.new("ScrollingFrame")
OptionsFrame.Name = "OptionsFrame"
OptionsFrame.Size = UDim2.new(0.95,0,0,320)
OptionsFrame.Position = UDim2.new(0.025,0,0,110)
OptionsFrame.BackgroundColor3 = BLACK
OptionsFrame.BackgroundTransparency = 0.4
OptionsFrame.BorderColor3 = BORDER
OptionsFrame.BorderSizePixel = 2
OptionsFrame.CanvasSize = UDim2.new(0,0,0,0)
OptionsFrame.ScrollBarThickness = 8
OptionsFrame.Parent = MainFrame
Roundify(OptionsFrame)

-- Função para enviar mensagem no chat
local function SendChatMessage(msg)
    local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
        chatEvent.SayMessageRequest:FireServer(msg, "All")
    end
end

-- NOVO Jail Visual
local function criarJaula(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local pos = targetPlayer.Character.HumanoidRootPart.Position

    if workspace:FindFirstChild(targetPlayer.Name .. "_Jaula") then    
        workspace[targetPlayer.Name .. "_Jaula"]:Destroy()    
    end    

    local jaula = Instance.new("Model", workspace)    
    jaula.Name = targetPlayer.Name .. "_Jaula"    

    local tamanho, altura = 8, 10    

    local base = Instance.new("Part", jaula)    
    base.Size = Vector3.new(tamanho, 1, tamanho)    
    base.Position = pos + Vector3.new(0, -0.5, 0)    
    base.Anchored = true    
    base.Color = Color3.fromRGB(60, 60, 60)    

    local teto = base:Clone()    
    teto.Parent = jaula    
    teto.Position = pos + Vector3.new(0, altura, 0)    

    for i=-tamanho/2, tamanho/2, 2 do    
        for _, v in ipairs({    
            Vector3.new(i, altura/2, -tamanho/2),    
            Vector3.new(i, altura/2, tamanho/2),    
            Vector3.new(-tamanho/2, altura/2, i),    
            Vector3.new(tamanho/2, altura/2, i)    
        }) do    
            local barra = Instance.new("Part", jaula)    
            barra.Size = Vector3.new(0.3, altura, 0.3)    
            barra.Position = pos + v    
            barra.Anchored = true    
            barra.Color = Color3.fromRGB(200, 200, 200)    
        end    
    end    

    targetPlayer.Character:MoveTo(pos + Vector3.new(0, 2, 0))    
    if targetPlayer.Character:FindFirstChild("Humanoid") then    
        targetPlayer.Character.Humanoid.WalkSpeed = 0    
        targetPlayer.Character.Humanoid.JumpPower = 0    
    end    
    targetPlayer.Character.HumanoidRootPart.Anchored = true

end

local function removerJaula(targetPlayer)
    if workspace:FindFirstChild(targetPlayer.Name .. "_Jaula") then
        workspace[targetPlayer.Name .. "_Jaula"]:Destroy()
    end
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        targetPlayer.Character.Humanoid.WalkSpeed = 16
        targetPlayer.Character.Humanoid.JumpPower = 50
    end
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        targetPlayer.Character.HumanoidRootPart.Anchored = false
    end
end

local options = {
{name="Kill player",cmd=function(plr)
    SendChatMessage(PREFIX.." Kill player "..plr)
    local target = Players:FindFirstChild(plr)
    if target then target:Kick("KAKAKAK BANIDO") end
end},
{name="Bring player",cmd=function(plr) -- CORRIGIDO
    SendChatMessage(PREFIX.." Bring player "..plr)
    local target = Players:FindFirstChild(plr)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
    end
end},
{name="jail player",cmd=function(plr)
    SendChatMessage(PREFIX.." jail player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt then criarJaula(tgt) end
end},
{name="unjail player",cmd=function(plr)
    SendChatMessage(PREFIX.." unjail player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt then removerJaula(tgt) end
end},
{name="Frezze player",cmd=function(plr)
    SendChatMessage(PREFIX.." Frezze player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt and tgt.Character then
        local hum = tgt.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
    end
end},
{name="Unfrezze player",cmd=function(plr)
    SendChatMessage(PREFIX.." Unfrezze player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt and tgt.Character then
        local hum = tgt.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end},
{name="Tp player",cmd=function(plr)
    SendChatMessage(PREFIX.." Tp player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = tgt.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
    end
end},
{name="Float player",cmd=function(plr) -- CORRIGIDO
    SendChatMessage(PREFIX.." Float player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
        local root = tgt.Character.HumanoidRootPart
        local floatBP = Instance.new("BodyPosition")
        floatBP.Name = "HubFloat"
        floatBP.MaxForce = Vector3.new(1e6,1e6,1e6)
        floatBP.Position = root.Position + Vector3.new(0,60,0)
        floatBP.Parent = root

        -- Efeito foguete visual
        local effect = Instance.new("ParticleEmitter")
        effect.Texture = "rbxassetid://243098098" -- fumaça de foguete
        effect.Rate = 100
        effect.Lifetime = NumberRange.new(0.5,1)
        effect.Speed = NumberRange.new(20,30)
        effect.Parent = root

        -- Espera até o player subir, explode/mata quando chegar no topo
        local exploded = false
        local con
        con = game:GetService("RunService").Heartbeat:Connect(function()
            if root.Position.Y >= floatBP.Position.Y-2 and not exploded then
                exploded = true
                if tgt.Character:FindFirstChild("Humanoid") then
                    tgt.Character.Humanoid.Health = 0
                end
                local exp = Instance.new("Explosion")
                exp.Position = root.Position
                exp.BlastPressure = 500000
                exp.Parent = workspace
                floatBP:Destroy()
                effect:Destroy()
                con:Disconnect()
            end
        end)
        wait(2.5)
        if not exploded then
            floatBP:Destroy()
            effect:Destroy()
            con:Disconnect()
        end
    end
end},
{name="Explodir player",cmd=function(plr) -- CORRIGIDO
    SendChatMessage(PREFIX.." Explodir player "..plr)
    local tgt = Players:FindFirstChild(plr)
    if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
        local exp = Instance.new("Explosion")
        exp.Position = tgt.Character.HumanoidRootPart.Position
        exp.BlastPressure = 500000
        exp.Parent = workspace
        if tgt.Character:FindFirstChild("Humanoid") then
            tgt.Character.Humanoid.Health = 0
        end
    end
end},
{name="Verificar",cmd=function()
    SendChatMessage(PREFIX.." Verificar")
    local users = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.PlayerGui:FindFirstChild("VisualPlayerHub") then
            table.insert(users, plr.Name)
        end
    end
    local msg = "Usuários com script: " .. table.concat(users,", ")
    local popup = Instance.new("TextLabel")
    popup.Size = UDim2.new(0.7,0,0,40)
    popup.Position = UDim2.new(0.15,0,0.85,0)
    popup.Text = msg
    popup.TextColor3 = Color3.new(1,1,1)
    popup.Font = Enum.Font.GothamBold
    popup.TextSize = 22
    popup.BackgroundColor3 = BLACK
    popup.BackgroundTransparency = 0.6
    popup.Parent = ScreenGui
    Roundify(popup)
    wait(2)
    popup:Destroy()
end},
{name="Jumpscare player",cmd=function(plr)
    SendChatMessage(PREFIX.." Jumpscare player "..plr)
    local jumpscare = Instance.new("ImageLabel")
    jumpscare.Size = UDim2.new(1,0,1,0)
    jumpscare.Position = UDim2.new(0,0,0,0)
    jumpscare.Image = "rbxassetid://107299502228775"
    jumpscare.BackgroundTransparency = 1
    jumpscare.Parent = ScreenGui
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1847536864"
    sound.Volume = 1
    sound.Parent = jumpscare
    sound:Play()
    wait(1.5)
    jumpscare:Destroy()
end},
{name="Ch player",cmd=function(plr) -- CORRIGIDO
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.5,0,0,36)
    inputBox.Position = UDim2.new(0.25,0,0.8,0)
    inputBox.PlaceholderText = "Digite a mensagem para o chat do player..."
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 18
    inputBox.BackgroundColor3 = BLACK
    inputBox.TextColor3 = Color3.new(1,1,1)
    inputBox.BackgroundTransparency = 0.3
    inputBox.BorderColor3 = BORDER
    inputBox.Parent = ScreenGui
    Roundify(inputBox)
    inputBox.FocusLost:Connect(function(enter)
        if enter and inputBox.Text ~= "" then
            local msg = PREFIX.." Ch player "..plr.." "..inputBox.Text
            SendChatMessage(msg)
            -- Tentar exibir mensagem para o player (local apenas)
            local target = Players:FindFirstChild(plr)
            if target and target == LocalPlayer then
                game.StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = "[Mensagem privada] "..inputBox.Text,
                    Color = Color3.fromRGB(255, 230, 0)
                })
            end
            inputBox:Destroy()
        end
    end)
    wait(5)
    if inputBox.Parent then inputBox:Destroy() end
end},
}

local y = 0
for i,option in ipairs(options) do
    local btn = Instance.new("TextButton")
    btn.Text = option.name
    btn.Name = option.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Size = UDim2.new(1,0,0,42)
    btn.Position = UDim2.new(0,0,0,y)
    btn.BackgroundColor3 = BLACK
    btn.BackgroundTransparency = 0.25
    btn.BorderColor3 = BORDER
    btn.BorderSizePixel = 2
    Roundify(btn)
    btn.Parent = OptionsFrame
    y = y + 50
    btn.MouseButton1Click:Connect(function()
        local plr = SelectedPlayer.Value
        if option.name == "Verificar" then
            option.cmd()
        elseif plr ~= "" then
            option.cmd(plr)
        else
            local popup = Instance.new("TextLabel")
            popup.Size = UDim2.new(0.7,0,0,40)
            popup.Position = UDim2.new(0.15,0,0.85,0)
            popup.Text = "Selecione um jogador!"
            popup.TextColor3 = Color3.new(1,0.5,0.5)
            popup.Font = Enum.Font.GothamBold
            popup.TextSize = 22
            popup.BackgroundColor3 = BLACK
            popup.BackgroundTransparency = 0.6
            popup.Parent = ScreenGui
            Roundify(popup)
            wait(1.2)
            popup:Destroy()
        end
    end)
end
OptionsFrame.CanvasSize = UDim2.new(0,0,0,y)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local diff = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + diff.X, startPos.Y.Scale, startPos.Y.Offset + diff.Y)
    end
end)

LocalPlayer.Chatted:Connect(function(msg)
    if string.sub(msg,1,#PREFIX) == PREFIX then
        local args = {}
        for word in string.gmatch(msg, "[^ ]+") do
            table.insert(args, word)
        end
        local optName = args[2]
        local plrName = args[3]
        for _,option in ipairs(options) do
            if string.lower(option.name) == string.lower(optName) then
                if option.name == "Verificar" then
                    option.cmd()
                elseif plrName and plrName ~= "" then
                    option.cmd(plrName)
                end
                break
            end
        end
    end
end)
-- FIM DO SCRIPT
