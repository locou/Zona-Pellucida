local equilibrium = {}
local game = Game()

local Equilibrium = {
  ID = Isaac.GetItemIdByName( "Equilibrium" ),
  Type = Isaac.GetEntityTypeByName( "Equilibrium" ),
  Variant = Isaac.GetEntityVariantByName( "Equilibrium" )
}

table.insert(locou.Items.Familiars, Equilibrium)

local reward = false
local temp = nil
function equilibrium:InitFamiliar(ent)
  if(temp == nil) then temp = game:GetPlayer(0) end
  ent.Parent = temp
  temp = ent
end

function equilibrium:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasCollectible(Equilibrium.ID)) then
    local sprite = ent:GetSprite()
    local coins = math.max(ply:GetNumCoins(),1)
    local bombs  = math.max(ply:GetNumBombs(),1)
    local keys  = math.max(ply:GetNumKeys(),1)
    local chance = (1 - math.sqrt(((math.abs(coins-bombs)+math.abs(coins-keys)+math.abs(keys-bombs))/198)))*.25
    ent:FollowPosition(ent.Parent.Position - ent.Parent.Velocity:Normalized() * 16)
    sprite.PlaybackSpeed = 0.4
    if(room:IsFirstVisit() and not reward and locou:HasEnemies() and room:GetFrameCount() == 1) then reward = true end
    if(room:IsFirstVisit() and room:IsClear() and reward) then
      for _,v in pairs(locou:GetEntitiesByVariant(EntityType.ENTITY_FAMILIAR, Equilibrium.Variant)) do
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
    end
    if(chance >= .2 and not sprite:IsPlaying("optimal")) then
      sprite:Play("optimal", true)
    elseif(chance >= .08 and chance < .2 and not sprite:IsPlaying("good")) then
      sprite:Play("good", true)
    elseif(chance < .08 and not sprite:IsPlaying("bad")) then
      sprite:Play("bad", true)
    end
  else
    if(ent.Variant == Equilibrium.Variant) then
      ent:Kill()
    end
  end
end

locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, equilibrium.InitFamiliar, Equilibrium.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, equilibrium.UpdateFamiliar, Equilibrium.Variant)
