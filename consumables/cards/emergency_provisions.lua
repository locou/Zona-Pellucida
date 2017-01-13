local emergency_provisions = {}
local game = Game()

local EmergencyProvisions = {
  ID = Isaac.GetCardIdByName("Emergency Provisions"),
  Variant = Isaac.GetEntityVariantByName("Spell Card")
}

table.insert(locou.Items.Cards, EmergencyProvisions)

function emergency_provisions:Use_Card(card)
  Isaac.DebugString(EmergencyProvisions.ID)
  if(card == EmergencyProvisions.ID) then
    local ply = game:GetPlayer(0)
    local ents = locou:GetEntitiesByType(EntityType.ENTITY_PICKUP)
    Isaac.DebugString("AHHHHH2")
    for _,v in pairs(ents) do
      Isaac.DebugString("AHHHHH")
      if(v.Variant ~= PickupVariant.PICKUP_BED and v.Variant ~= PickupVariant.PICKUP_BIGCHEST and v.Variant ~= PickupVariant.PICKUP_COLLECTIBLE
        and v.Variant ~= PickupVariant.PICKUP_NULL and v.Variant ~= PickupVariant.PICKUP_SHOPITEM and v.Variant ~= PickupVariant.PICKUP_TROPHY) then
        if(ply:GetHearts() < ply:GetMaxHearts()) then
          ply:AddHearts(1)
        else
          ply:AddSoulHearts(1)
        end
        v:Remove()
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, emergency_provisions.Use_Card, EmergencyProvisions.ID)
