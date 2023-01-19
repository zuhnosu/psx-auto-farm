local Client = require(game.ReplicatedStorage.Library.Client)
local Library = require(game.ReplicatedStorage.Library)
local Orbs = getsenv(game.Players.LocalPlayer.PlayerScripts.Scripts.Game.Orbs)

debug.setupvalue(Client.Network.Invoke, 1, function() return true end)
debug.setupvalue(Client.Network.Fire, 1, function() return true end)

function GetCoins(Area)
    local Coins = {}
    for i,v in next, Client.Network.Invoke('Get Coins') do 
        if v.a == Area then 
            Coins[i] = v
        end 
    end 
    return Coins
end 

function GetPets()
    return Client.PetCmds.GetEquipped() 
end 

for i,v in pairs(workspace.__THINGS.Orbs:GetChildren()) do 
    Orbs.Collect(v)
end 

workspace.__THINGS.Orbs.ChildAdded:Connect(function(v)
    Orbs.Collect(v)
end)

while true do 
    if _G.AutoFarm then
        local Pets = GetPets()
        local Coins = GetCoins(_G.Area or 'Town')
        for i,v in next, Coins do
            if workspace.__THINGS.Coins:FindFirstChild(i) and _G.AutoFarm then 
                for _,Pet in next, Pets do 
                    spawn(function()
                        if _G.AutoFarm then
                            Client.Network.Invoke('Join Coin', i, {Pet.uid})
                            Client.Network.Fire('Farm Coin', i, Pet.uid)
                        end
                    end)
                end 
            end 
            repeat task.wait() until not workspace.__THINGS.Coins:FindFirstChild(i)
        end 
        task.wait()
    end
    task.wait()
end 
