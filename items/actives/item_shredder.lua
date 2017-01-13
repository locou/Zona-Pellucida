local item_shredder = {}
local game = Game()

local ItemShredder = {
  ID = Isaac.GetItemIdByName( "Item Shredder" ),
}

table.insert(locou.Items.Actives, ItemShredder)

function item_shredder:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  if(id == ItemShredder.ID) then
    local pedestals = locou:GetEntitiesByVariant(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    for _,v in pairs(pedestals) do
      if(v.SubType > 0) then
          local pos = v.Position
          v:Remove()
          for i=0, (math.random(3) + 2) do
            locou:SpawnRandomChest(pos)
          end
      end
    end
    return true
  end
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, item_shredder.Use_Item, item_shredder.ID)