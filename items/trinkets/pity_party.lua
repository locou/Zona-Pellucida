local pity_party = {}
local game = Game()

local PityParty = {
  ID = Isaac.GetTrinketIdByName( "Pity Party" ),
}

table.insert(locou.Items.Trinkets, PityParty)

local pity_party = {}

function pity_party:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasTrinket(PityParty.ID)) then
    local fams = locou:GetEntitiesByType(EntityType.ENTITY_FAMILIAR)
    for _,v in pairs(fams) do
      local rng = RNG()
      rng:SetSeed(math.floor(game:GetFrameCount() * math.pi),6)
      if(v.Variant == FamiliarVariant.MYSTERY_SACK) then
        local chance = 0.15 * (1 + ply.Luck)
        if(math.random() <= chance) then
          locou:SpawnRandomPickup()
        end
      elseif(v.Variant == FamiliarVariant.JUICY_SACK) then
        local chance = 0.25 * (1 + ply.Luck)
        if(math.random() <= chance) then
          ply:AddBlueSpider(v.Position)
        end
      elseif(v.Variant == FamiliarVariant.SACK_OF_SACKS) then
        local chance = 0.1 * (1 + ply.Luck)
        if(math.random() <= chance) then
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, 1, rng:Next())
        end
      elseif(v.Variant == FamiliarVariant.SACK_OF_PENNIES) then
        local chance = 0.1 * (1 + ply.Luck)
        if(math.random() <= chance) then
          local pickup = locou:SpawnRandomPickup("coins")
        end
      elseif(v.Variant == FamiliarVariant.BOMB_BAG) then
        local chance = 0.1 * (1 + ply.Luck)
        if(math.random() <= chance) then
          local pickup = locou:SpawnRandomPickup("bombs")
        end
      elseif(v.Variant == FamiliarVariant.RUNE_BAG) then
        local chance = 0.05 * (1 + ply.Luck)
        if(math.random() <= chance) then
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, math.random(32,41), rng:Next())
        end
      elseif(v.Variant == FamiliarVariant.LIL_CHEST) then
        local chance = 0.1 * (1 + ply.Luck)
        local chance_item = 0.015 * (1 + ply.Luck)
        local random = math.random()
        if(random <= chance) then
          local pickup = locou.Pickups[locou.Pickups_Index[math.random(table.length(locou.Pickups))]]
          local variant = pickup.Variant
          local subtype = pickup.SubTypes[math.random(table.length(pickup.SubTypes))]
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, variant, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, subtype, 1)
        elseif(random > chance_item) then
          local pedestal = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, math.random(1,CollectibleType.NUM_COLLECTIBLES), rng:Next())
        end
      elseif(v.Variant == FamiliarVariant.LITTLE_CHAD) then
        local chance = 0.1 * (1 + math.sqrt(ply.Luck))
        if(math.random() <= chance) then
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, HeartSubType.HEART_HALF, 1)
        end
      elseif(v.Variant == FamiliarVariant.RELIC) then
        local chance = 0.1 * (1 + math.sqrt(ply.Luck))
        if(math.random() <= chance) then
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, HeartSubType.HEART_SOUL, 1)
        end
      elseif(v.Variant == FamiliarVariant.CHARGED_BABY) then
        local chance = 0.1 * (1 + ply.Luck)
        if(math.random() <= chance) then
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, 1, 1)
        end
      elseif(v.Variant == FamiliarVariant.ACID_BABY) then
        local chance = 0.1 * (1 + ply.Luck)
        if(math.random() <= chance) then
          local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, math.random(1,PillEffect.NUM_PILL_EFFECTS), 1)
        end
      elseif(v.Variant == FamiliarVariant.ROTTEN_BABY) then
        local chance = 0.2 * (1 + ply.Luck)
        if(math.random() <= chance) then
          ply:AddBlueFlies(math.random(4), v.Position, ply)
        end
      elseif(v.Variant == FamiliarVariant.SISSY_LONGLEGS) then
        local chance = 0.2 * (1 + ply.Luck)
        if(math.random() <= chance) then
          ply:AddBlueSpider(v.Position)
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, pity_party.OnDamageTaken, EntityType.ENTITY_PLAYER)