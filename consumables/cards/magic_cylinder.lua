local magic_cylinder = {}
local game = Game()

local MagicCylinder = {
  ID = Isaac.GetCardIdByName("Magic Cylinder"),
  Variant = Isaac.GetEntityVariantByName("Trap Card")
}

table.insert(locou.Items.Cards, MagicCylinder)

local shield = false
function magic_cylinder:Use_Card(card)
  if(card == MagicCylinder.ID) then
    local ply = game:GetPlayer(0)
    shield = true
  end
end

function magic_cylinder:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(dmg_target.Type == EntityType.ENTITY_PLAYER and dmg_amount > 0) then
    if(shield) then
      shield = false
      local enemies = locou:GetEnemies()
      local ent = nil
      for _,v in pairs(enemies) do
        if(v.HitPoints > max) then ent = v end
      end
      
      if(ent ~= nil) then ent:TakeDamage(ent.MaxHitPoints * .25, DamageFlag.DAMAGE_DEVIL, EntityRef(ply), 0) end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, magic_cylinder.Use_Card, MagicCylinder.ID)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, magic_cylinder.OnDamageTaken, EntityType.ENTITY_PLAYER)