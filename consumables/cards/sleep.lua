local sleep = {}
local game = Game()

local Sleep = {
  ID = Isaac.GetCardIdByName("Sleep"),
  Variant = Isaac.GetEntityVariantByName("Trainer Card")
}

table.insert(locou.Items.Cards, Sleep)

function sleep:Use_Card(card)
  if(card == Sleep.ID) then
    local ply = game:GetPlayer(0)
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddConfusion(EntityRef(ply), 300)
      v:AddFreeze(EntityRef(ply), 300)
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, sleep.Use_Card, Sleep.ID)