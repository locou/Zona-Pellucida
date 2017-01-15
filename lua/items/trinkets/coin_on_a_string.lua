local coin_on_a_string = {}
local game = Game()

local CoinOnAString = {
  ID = Isaac.GetTrinketIdByName( "Coin On A String" ),
}

table.insert(locou.Items.Trinkets, CoinOnAString)

function coin_on_a_string:SlotUpdate(ent)
  local ents = locou:GetEntitiesByType(EntityType.ENTITY_SLOT)
  for _,ent in pairs(ents) do
    local slot = ent
  end
end

--locou:AddCallback(ModCallbacks.MC_POST_UPDATE, coin_on_a_string.SlotUpdate)