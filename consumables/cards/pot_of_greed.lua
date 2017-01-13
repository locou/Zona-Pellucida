local pot_of_greed = {}
local game = Game()

local PotOfGreed = {
  ID = Isaac.GetCardIdByName("Pot of Greed"),
  Variant = Isaac.GetEntityVariantByName("Spell Card")
}

table.insert(locou.Items.Cards, PotOfGreed)

function pot_of_greed:Use_Card(card)
  if(card == PotOfGreed.ID) then
    local ply = game:GetPlayer(0)
    local room = game:GetRoom()
    local index = {"DarkFactory","EmergencyProvisions","EternalRest","JustDeserts","MagicCylinder","MirrorForce","PotOfGreed","Scapegoat","SpellbindingCircle","TorrentalTribute"}
    for i=1,2 do
      local card = locou.Items.Cards[index[math.random() * #index]]
      if(card~= nil) then 
        game:Spawn(EntityType.ENTITY_PICKUP, card.Variant, room:FindFreePickupSpawnPosition(ply.Position, 16.0, true), Vector(0,0), ply, card.ID, 1)
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, pot_of_greed.Use_Card, PotOfGreed.ID)