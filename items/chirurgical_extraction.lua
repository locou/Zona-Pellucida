local chirurgical_extraction = {}
local game = Game()

local ChirurgicalExtraction = {
  ID = Isaac.GetItemIdByName( "Chirurgical Extraction" ),
}

table.insert(locou.Items.Passives, ChirurgicalExtraction)

function chirurgical_extraction:Use_Item(rng)
  local ply = game:GetPlayer(0)
  local item = 511
  local pedestal = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ply.Position, Vector(0,0), ply, ChirurgicalExtraction.ID, rng)
  Isaac.DebugString("[ChirurgicalExtraction] Spawned pedestal: " .. pedestal.Type)
  return true
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, chirurgical_extraction.Use_Item, chirurgical_extraction.ID)