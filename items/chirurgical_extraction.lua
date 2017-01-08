local chirurgical_extraction = {}
local game = Game()

local ChirurgicalExtraction = {
  ID = Isaac.GetItemIdByName( "Chirurgical Extraction" ),
}

table.insert(locou.Items.Actives, ChirurgicalExtraction)

function chirurgical_extraction:Use_Item(rng)
  local ply = game:GetPlayer(0)
  local items = locou:GetCollectibles()
  local item = items[RNG():RandomInt(#items)] or ChirurgicalExtraction.ID
  local pedestal = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ply.Position, Vector(0,0), ply, item, rng)
  return true
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, chirurgical_extraction.Use_Item, chirurgical_extraction.ID)