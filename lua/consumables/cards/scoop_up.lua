local scoop_up = {}
local game = Game()

local ScoopUp = {
  ID = Isaac.GetCardIdByName("11_ScoopUp")
}

table.insert(locou.Items.Cards.Poke, ScoopUp)

function scoop_up:Use_Card(card)
  if(card == ScoopUp.ID) then
    local ply = game:GetPlayer(0)
    local room = game:GetRoom()
    local collectibles = locou:GetCollectibles()
    local item = collectibles[math.random() * #collectibles]
    if(item ~= nil) then
      ply:RemoveCollectible(item)
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, room:FindFreePickupSpawnPosition(ply.Position, 16.0, true), vector(0,0), ply, item, 1)
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, scoop_up.Use_Card, ScoopUp.ID)
