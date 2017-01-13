local eternal_rest = {}
local game = Game()

local EternalRest = {
  ID = Isaac.GetCardIdByName("Eternal Rest"),
  Variant = Isaac.GetEntityVariantByName("Spell Card")
}

table.insert(locou.Items.Cards, EternalRest)

function eternal_rest:Use_Card(card)
  if(card == EternalRest.ID) then
    local ply = game:GetPlayer(0)
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      if(v:ToNPC():IsChampion()) then
        if(math.random() < 0.5) then
          locou:SpawnRandomPickup("random", v.Position)
        else
          locou:SpawnRandomChest(v.Position)
        end
        v:Kill()
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, eternal_rest.Use_Card, EternalRest.ID)