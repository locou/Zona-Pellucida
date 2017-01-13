local foul_egg = {}
local game = Game()

local FoulEgg = {
  ID = Isaac.GetItemIdByName( "Foul Egg" ),
  Type = Isaac.GetEntityTypeByName( "Foul Egg" ),
  Variant = Isaac.GetEntityVariantByName( "Foul Egg" )
}

table.insert(locou.Items.Familiars, FoulEgg)

local broken = false
function foul_egg:Init()
  broken = false
end

function foul_egg:InitFamiliar(ent)
  local ply = game:GetPlayer(0)
  ent.Parent = ply
end

function foul_egg:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(FoulEgg.ID)) then
    if(not broken) then
      ent:FollowPosition(ent.Parent.Position + Vector(8.0,8.0))
      ent.CollisionDamage = 1
    else
      ent.Velocity = Vector(0.0,0.0)
      ent.CollisionDamage = 0
    end
  elseif(ent.Variant == FoulEgg.Variant) then
    ent:Kill()
  end
end

function foul_egg:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  if(dmg_source.Type == EntityType.ENTITY_FAMILIAR and dmg_source.Variant == FoulEgg.Variant) then
    if(not timer.Exists("foul_egg"..dmg_source.Entity.Index)) then
      local ply = game:GetPlayer(0)
      broken = true
      for i=0,5 do
        if(math.random() < 0.5) then
          ply:AddBlueSpider(ply.Position)
        else
          ply:AddBlueFlies(1, ply.Position, ply)
        end
      end
      timer.Create("foul_egg"..dmg_source.Entity.Index,8.0,1, function()
        broken = false
      end)
      timer.Start("foul_egg"..dmg_source.Entity.Index)
      return false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, foul_egg.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, foul_egg.InitFamiliar, FoulEgg.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, foul_egg.UpdateFamiliar, FoulEgg.Variant)
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, foul_egg.Init)
