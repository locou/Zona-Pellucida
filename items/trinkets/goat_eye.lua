local goat_eye = {}
local game = Game()

local GoatEye = {
  ID = Isaac.GetTrinketIdByName( "Goat Eye" ),
}

table.insert(locou.Items.Trinkets, GoatEye)

local devil = nil
local flag = false
local fallen = nil
local leech1 = nil
local leech2 = nil
      
function goat_eye:OnUpdate()
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasTrinket(GoatEye.ID)) then
    if(room:GetType() == RoomType.ROOM_DEVIL) then
      if(room:GetFrameCount() == 1) then
        local ents = locou:GetEntitiesByType(EntityType.ENTITY_EFFECT)
        for _,v in pairs(ents) do
          if(v.Variant == EffectVariant.DEVIL) then
            timer.Simple(15, function()
              flag = false
              v:Kill()
            end)
            devil = v
            break
          end
        end
      end
      
      if(devil ~= nil and devil:IsDead() and not flag) then
        fallen = game:Spawn(EntityType.ENTITY_FALLEN, 0, room:GetCenterPos() - Vector(0,16.0), Vector(0,0), nil, 0, 1)
        leech1 = game:Spawn(EntityType.ENTITY_LEECH, 1, room:GetCenterPos() + Vector(-32,-16.0), Vector(0,0), nil, 1, 1)
        leech2 = game:Spawn(EntityType.ENTITY_LEECH, 1, room:GetCenterPos() + Vector(32,-16.0), Vector(0,0), nil, 1, 1)
        devil:Remove()
        devil = nil
        flag = true
      end
      
      if(flag and #locou:GetEnemies() <= 1) then
        local deals = locou:GetEntitiesByVariant(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE)
        for _,v in pairs(deals) do
          if(v:ToPickup():IsShopItem()) then
            local deal = v:ToPickup()
            deal.Price = 0
          end
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_UPDATE, goat_eye.OnUpdate)