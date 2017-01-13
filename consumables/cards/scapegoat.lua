local scapegoat = {}
local game = Game()

local Scapegoat = {
  ID = Isaac.GetCardIdByName("Scapegoat"),
  Variant = Isaac.GetEntityVariantByName("Spell Card")
}

table.insert(locou.Items.Cards, Scapegoat)

local shield = 0
function scapegoat:Use_Card(card)
  if(card == Scapegoat.ID) then
    local ply = game:GetPlayer(0)
    shield = 4
  end
end

function scapegoat:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(dmg_target.Type == EntityType.ENTITY_PLAYER and dmg_amount > 0 and ply.Position:Distance(dmg_source.Entity.Position) < 16) then
    if(shield > 0) then
      shield = shield - 1
      return false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, scapegoat.Use_Card, Scapegoat.ID)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, scapegoat.OnDamageTaken, EntityType.ENTITY_PLAYER)