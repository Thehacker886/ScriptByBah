-- Sistema de Tags de Rank para Roblox
-- Coloque este script no ServerScriptService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configurações das Ranks
local RankConfig = {
    -- Substitua pelos UserIds ou Usernames dos jogadores
    Owner = {
        users = {"SeuUsernameAqui"}, -- Coloque os usernames dos owners aqui
        tag = "{Owner}",
        color = Color3.new(1, 0.84, 0) -- Dourado
    },
    Admin = {
        users = {"UsernameAdmin1", "UsernameAdmin2"}, -- Coloque os usernames dos admins
        tag = "[Admin]",
        color = Color3.new(1, 0, 0) -- Vermelho
    },
    HeadAdmin = {
        users = {"UsernameHeadAdmin"}, -- Coloque os usernames dos head admins
        tag = "[Head Admin]",
        color = Color3.new(0.5, 0, 0) -- Vermelho escuro
    },
    Friend = {
        users = {"UsernameFriend1", "UsernameFriend2"}, -- Coloque os usernames dos amigos
        tag = "[Friend]",
        color = Color3.new(0.6, 0.3, 0.1) -- Marrom
    }
}

-- Função para obter a rank de um jogador
local function getPlayerRank(player)
    local username = player.Name
    
    -- Verifica Owner primeiro (maior prioridade)
    for _, ownerName in pairs(RankConfig.Owner.users) do
        if username == ownerName then
            return RankConfig.Owner
        end
    end
    
    -- Verifica Head Admin
    for _, headAdminName in pairs(RankConfig.HeadAdmin.users) do
        if username == headAdminName then
            return RankConfig.HeadAdmin
        end
    end
    
    -- Verifica Admin
    for _, adminName in pairs(RankConfig.Admin.users) do
        if username == adminName then
            return RankConfig.Admin
        end
    end
    
    -- Verifica Friend
    for _, friendName in pairs(RankConfig.Friend.users) do
        if username == friendName then
            return RankConfig.Friend
        end
    end
    
    return nil -- Jogador normal, sem tag
end

-- Função para criar a tag acima do jogador
local function createTag(player, rankData)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    -- Remove tag existente se houver
    local existingTag = head:FindFirstChild("RankTag")
    if existingTag then
        existingTag:Destroy()
    end
    
    -- Cria a nova tag
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "RankTag"
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- Altura acima da cabeça
    billboardGui.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = rankData.tag
    textLabel.TextColor3 = rankData.color
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = billboardGui
end

-- Função chamada quando um jogador entra
local function onPlayerAdded(player)
    local function onCharacterAdded(character)
        wait(1) -- Aguarda o character carregar completamente
        
        local rankData = getPlayerRank(player)
        if rankData then
            createTag(player, rankData)
        end
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Conecta a função para novos jogadores
Players.PlayerAdded:Connect(onPlayerAdded)

-- Aplica as tags para jogadores já no servidor
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Função para atualizar tags em tempo real (opcional)
local function updateTags()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local rankData = getPlayerRank(player)
            if rankData then
                createTag(player, rankData)
            else
                -- Remove tag se o jogador não tem mais rank
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local existingTag = head:FindFirstChild("RankTag")
                    if existingTag then
                        existingTag:Destroy()
                    end
                end
            end
        end
    end
end

-- Atualiza as tags a cada 30 segundos (opcional - remova se não precisar)
spawn(function()
    while true do
        wait(30)
        updateTags()
    end
end)