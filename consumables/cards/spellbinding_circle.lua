local spellbinding_circle = {}
local game = Game()

local SpellbindingCircle = {
  ID = Isaac.GetCardIdByName("Spellbinding Circle"),
  Variant = Isaac.GetEntityVariantByName("Trap Card")
}

table.insert(locou.Items.Cards, SpellbindingCircle)

local trigger = false
function spellbinding_circle:Use_Card(card)
  if(card == SpellbindingCircle.ID) then
    local ply = game:GetPlayer(0)
    trigger = true
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddFear(EntityRef(ply), 180)
    end
  end
end

function spellbinding_circle:OnRoomChange()
    local ply = game:GetPlayer(0)
    local room = game:GetRoom()
    if(trigger) then
      if(room:IsFirstVisit() and room:GetFrameCount() == 1) then
        local enemies = locou:GetEnemies()
        local enemy = enemies[math.random() * #enemies]
        if(enemy ~= nil) then enemy:AddFreeze(EntityRef(ply), 1200) end
        trigger = false
      end
    end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, spellbinding_circle.Use_Card, SpellbindingCircle.ID)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, spellbinding_circle.OnRoomChange)