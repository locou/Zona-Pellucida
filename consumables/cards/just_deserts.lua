local just_deserts = {}
local game = Game()

local JustDeserts = {
  ID = Isaac.GetCardIdByName("Just Deserts"),
  Variant = Isaac.GetEntityVariantByName("Trap Card")
}

table.insert(locou.Items.Cards, JustDeserts)

local shield = false
function just_deserts:Use_Card(card)
  if(card == JustDeserts.ID) then
    local ply = game:GetPlayer(0)
    shield = true
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddFear(EntityRef(ply), 180)
    end
  end
end

function just_deserts:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(dmg_target.Type == EntityType.ENTITY_PLAYER and dmg_amount > 0) then
    if(shield) then
      shield = false
      local enemies = locou:GetEnemies()
      dmg_source.Entity:TakeDamage(15 * #enemies, DamageFlag.DAMAGE_DEVIL, EntityRef(ply), 0)
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, just_deserts.Use_Card, JustDeserts.ID)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, just_deserts.OnDamageTaken, EntityType.ENTITY_PLAYER)