local pet_rock = {}
local game = Game()

local PetRock = {
  ID = Isaac.GetItemIdByName( "Pet Rock" ),
  Type = Isaac.GetEntityTypeByName( "Pet Rock" ),
  Variant = Isaac.GetEntityVariantByName( "Pet Rock" )
}

table.insert(locou.Items.Familiars, PetRock)

function pet_rock:UpdateFamiliar(fam)
  local ply = game:GetPlayer(0)
  fam:FollowPosition(ply.Position + Vector(16.0,16.0))
end

locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, pet_rock.UpdateFamiliar, PetRock.Variant)