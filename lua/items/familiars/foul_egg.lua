local foul_egg = {}
local game = Game()

local FoulEgg = {
  ID = Isaac.GetItemIdByName( "Foul Egg" ),
  Type = Isaac.GetEntityTypeByName( "Foul Egg" ),
  Variant = Isaac.GetEntityVariantByName( "Foul Egg" )
}

table.insert(locou.Items.Familiars, FoulEgg)

local broken = {}
local temp = nil
function foul_egg:Init()
  temp = game:GetPlayer(0)
end

function foul_egg:InitFamiliar(ent)
  if(temp == nil) then temp = game:GetPlayer(0) end
  ent.Parent = temp
  temp = ent
end

function foul_egg:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(FoulEgg.ID)) then
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

function foul_egg:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  if(dmg_source.Type == EntityType.ENTITY_FAMILIAR and dmg_source.Variant == FoulEgg.Variant) then
    local index = dmg_source.Entity.Index
    if(not timer.Exists("foul_egg"..index)) then
      local ply = game:GetPlayer(0)
      table.insert(broken,index)
      for i=0,5 do
        if(math.random() < 0.5) then
          ply:AddBlueSpider(ply.Position)
        else
          ply:AddBlueFlies(1, ply.Position, ply)
        end
      end
      timer.Create("foul_egg"..index,8.0,1, function()
        for k,v in pairs(broken) do
          if v == index then
            table.remove(broken,k)
            break
          end
        end
      end)
      timer.Start("foul_egg"..index)
      return false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, foul_egg.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, foul_egg.InitFamiliar, FoulEgg.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, foul_egg.UpdateFamiliar, FoulEgg.Variant)
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, foul_egg.Init)
