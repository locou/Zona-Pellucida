local switch = {}
local game = Game()

local Switch = {
  ID = Isaac.GetCardIdByName("10_Switch")
}

table.insert(locou.Items.Cards.Poke, Switch)

function switch:Use_Card(card)
  if(card == Switch.ID) then
    local ply = game:GetPlayer(0)
    local collectibles = locou:GetCollectibles()
    local item = collectibles[math.random() * #collectibles]
    local replacement = collectibles[math.random() * #collectibles]
    if(item ~= nil and replacement ~= nil) then
      ply:RemoveCollectible(item)
      ply:AddCollectible(replacement)
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, switch.Use_Card, Switch.ID)
