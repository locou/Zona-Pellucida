local coin_on_a_string = {}
local game = Game()

local CoinOnAString = {
  ID = Isaac.GetTrinketIdByName( "Coin On A String" ),
}

table.insert(locou.Items.Trinkets, CoinOnAString)

function coin_on_a_string:SlotUpdate(ent)
end

--locou:AddCallback(ModCallbacks.MC_NPC_UPDATE, coin_on_a_string.SlotUpdate)