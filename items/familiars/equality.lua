local equality = {}
local game = Game()

local Equality = {
  ID = Isaac.GetItemIdByName( "Equality" ),
  Type = Isaac.GetEntityTypeByName( "Equality" ),
  Variant = Isaac.GetEntityVariantByName( "Equality" )
}

table.insert(locou.Items.Familiars, Equality)

local reward = false
function equality:InitFamiliar(ent)
  ent.Parent = game:GetPlayer(0)
end

function equality:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasCollectible(Equality.ID)) then
    local sprite = ent:GetSprite()
    local coins = math.max(ply:GetNumCoins(),1)
    local bombs  = math.max(ply:GetNumBombs(),1)
    local keys  = math.max(ply:GetNumKeys(),1)
    local chance = (1 - math.sqrt(((math.abs(coins-bombs)+math.abs(coins-keys)+math.abs(keys-bombs))/198)))*.25
    ent:FollowPosition(ent.Parent.Position + Vector(16.0,16.0))
    sprite.PlaybackSpeed = 0.4
    if(room:IsFirstVisit() and not reward and locou:HasEnemies() and room:GetFrameCount() == 1) then reward = true end
    if(room:IsFirstVisit() and room:IsClear() and reward) then
      if(math.random() < chance) then
        if(chance >= .2) then
          local room = game:GetRoom()
          local rng = RNG()
          rng:SetSeed(math.floor(math.random() * game:GetFrameCount() * math.pi),6)
          local chest = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, room:FindFreePickupSpawnPosition(ent.Position, 5.0, true), Vector(0,0), nil, 1, rng:Next())
        elseif(chance >= .08 and chance < .2) then
          locou:SpawnRandomChest(ent.Position)
        end
      end
      reward = false
    end
    if(chance >= .2 and not sprite:IsPlaying("optimal")) then
      sprite:Play("optimal", true)
    elseif(chance >= .08 and chance < .2 and not sprite:IsPlaying("good")) then
      sprite:Play("good", true)
    elseif(chance < .08 and not sprite:IsPlaying("bad")) then
      sprite:Play("bad", true)
    end
  else
    if(ent.Variant == Equality.Variant) then
      ent:Kill()
    end
  end
end

locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, equality.InitFamiliar, Equality.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, equality.UpdateFamiliar, Equality.Variant)
