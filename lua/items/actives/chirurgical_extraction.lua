local chirurgical_extraction = {}
local game = Game()

local ChirurgicalExtraction = {
  ID = Isaac.GetItemIdByName( "Chirurgical Extraction" ),
}

table.insert(locou.Items.Actives, ChirurgicalExtraction)

function chirurgical_extraction:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  if(id == ChirurgicalExtraction.ID) then
    local items = locou:GetCollectibles()
    local item = id
    if(#items > 0) then
      item = items[math.random(#items)]
    end

    local pedestal = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ply.Position, Vector(0,0), ply, item, rng:Next())
    return true
  end
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, chirurgical_extraction.Use_Item, chirurgical_extraction.ID)
