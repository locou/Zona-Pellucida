local strong_reaction = {}
local game = Game()

local StrongReaction = {
  ID = Isaac.GetItemIdByName( "Strong Reaction" ),
}

table.insert(locou.Items.Passives, StrongReaction)

function strong_reaction:OnPillUsed(pill)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasCollectible(StrongReaction.ID)) then
    local heart = locou.Pickups.Hearts.SubTypes[math.random(table.length(pickup.SubTypes))]
    local ent = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, heart, 1)
    for i=1,ply:GetCollectibleNum(StrongReaction.ID) do
      local pickup = locou.Pickups[locou.Pickups_Index[math.random(table.length(locou.Pickups))]]
      local variant = pickup.Variant
      local subtype = pickup.SubTypes[math.random(table.length(pickup.SubTypes))]
      local ent = game:Spawn(EntityType.ENTITY_PICKUP, variant, room:FindFreePickupSpawnPosition(v.Position, 20.0, true), Vector(0,0), ply, subtype, 1)
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_PILL, strong_reaction.OnPillUsed)