local kind_egg = {}
local game = Game()

local KindEgg = {
  ID = Isaac.GetItemIdByName( "Kind Egg" ),
  Type = Isaac.GetEntityTypeByName( "Kind Egg" ),
  Variant = Isaac.GetEntityVariantByName( "Kind Egg" )
}

table.insert(locou.Items.Familiars, KindEgg)

local broken = false
function kind_egg:Init()
  broken = false
end

function kind_egg:InitFamiliar(ent)
  local ply = game:GetPlayer(0)
  ent.Parent = ply
end

function kind_egg:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(FoulEgg.ID)) then
    if(not broken) then
      ent:FollowPosition(ent.Parent.Position + Vector(8.0,8.0))
      ent.CollisionDamage = 1
    else
      ent.Velocity = Vector(0.0,0.0)
      ent.CollisionDamage = 0
    end
  elseif(ent.Variant == KindEgg.Variant) then
    ent:Kill()
  end
end

function kind_egg:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  if(dmg_source.Type == EntityType.ENTITY_FAMILIAR and dmg_source.Variant == KindEgg.Variant) then
    if(not timer.Exists("kind_egg"..dmg_source.Entity.Index)) then
      broken = true
      locou:SpawnRandomPickup("random", dmg_source.Position)
      timer.Create("kind_egg"..dmg_source.Entity.Index,8.0,1, function()
        broken = false
      end)
      timer.Start("kind_egg"..dmg_source.Entity.Index)
      return false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, kind_egg.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, kind_egg.InitFamiliar, KindEgg.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, kind_egg.UpdateFamiliar, KindEgg.Variant)
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, kind_egg.Init)
