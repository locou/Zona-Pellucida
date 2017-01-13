local babygrv = {}
local game = Game()

local BabyGRV = {
  ID = Isaac.GetItemIdByName( "Baby Growth" ),
  ID2 = Isaac.GetItemIdByName( "Baby Rage" ),
  ID3 = Isaac.GetItemIdByName( "Baby Virus" )
}

table.insert(locou.Items.Passives, BabyGRV)


function pet_rock:Init()
end

function babygrv:InitFamiliar(ent)
  
end

function babygrv:UpdateFamiliar(ent)
  
end

locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, babygrv.InitFamiliar)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, babygrv.UpdateFamiliar)
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, babygrv.Init)