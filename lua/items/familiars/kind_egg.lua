local kind_egg = {}
local game = Game()

local KindEgg = {
  ID = Isaac.GetItemIdByName( "Kind Egg" ),
  Type = Isaac.GetEntityTypeByName( "Kind Egg" ),
  Variant = Isaac.GetEntityVariantByName( "Kind Egg" )
}

table.insert(locou.Items.Familiars, KindEgg)

local broken = {}
local temp = nil
function kind_egg:Init()
  temp = game:GetPlayer(0)
end

function kind_egg:InitFamiliar(ent)
  if(temp == nil) then temp = game:GetPlayer(0) end
  ent.Parent = temp
  temp = ent
end

function kind_egg:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(KindEgg.ID)) then
    if(not table.contains(broken, ent.Index)) then
      if(ent.Parent == nil) then ent.Parent = ply end
      ent:FollowPosition(ent.Parent.Position - ent.Parent.Velocity:Normalized() * 16)
      ent.CollisionDamage = 1
    else
      ent.Velocity = Vector(0.0,0.0)
      ent.CollisionDamage = 0
    end
  end
end

function kind_egg:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  if(dmg_source.Type == EntityType.ENTITY_FAMILIAR and dmg_source.Variant == KindEgg.Variant) then
    local index = dmg_source.Entity.Index
    if(not timer.Exists("kind_egg"..index)) then
      local ply = game:GetPlayer(0)
      table.insert(broken,index)
      locou:SpawnRandomPickup("random", dmg_source.Position)
      timer.Create("kind_egg"..index,8.0,1, function()
        for k,v in pairs(broken) do
          if v == index then
            table.remove(broken,k)
            break
          end
        end
      end)
      timer.Start("kind_egg"..index)
      return false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, kind_egg.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, kind_egg.InitFamiliar, KindEgg.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, kind_egg.UpdateFamiliar, KindEgg.Variant)
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, kind_egg.Init)
