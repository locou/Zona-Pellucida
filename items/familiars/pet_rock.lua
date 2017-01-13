local pet_rock = {}
local game = Game()

local PetRock = {
  ID = Isaac.GetItemIdByName( "Pet Rock" ),
  Type = Isaac.GetEntityTypeByName( "Pet Rock" ),
  Variant = Isaac.GetEntityVariantByName( "Pet Rock" )
}

table.insert(locou.Items.Familiars, PetRock)

local temp = nil

function pet_rock:Init()
    temp = game:GetPlayer(0)
end

function pet_rock:InitFamiliar(ent)
  if(temp == nil) then temp = game:GetPlayer(0) end
  ent.Parent = temp
  temp = ent
end

function pet_rock:UpdateFamiliar(ent)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(PetRock.ID)) then
    if(ent.Parent == nil) then ent.Parent = ply end
    if(ent.Parent.Index ~= ply.Index) then ent.Friction = 0.5 end
    ent:FollowPosition(ent.Parent.Position + Vector(4.0,4.0))
  elseif(ent.Variant == PetRock.Variant) then
    ent:Kill()
  end
end

locou:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, pet_rock.InitFamiliar, PetRock.Variant)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, pet_rock.UpdateFamiliar, PetRock.Variant)
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, pet_rock.Init)
