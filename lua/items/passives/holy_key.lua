local holy_key = {}
local game = Game()

local HolyKey = {
  ID = Isaac.GetItemIdByName( "Holy Key" )
}
table.insert(locou.Items.Passives, HolyKey)

function holy_key:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(HolyKey.ID)) then
    local ents = locou:GetEntitiesByType(EntityType.ENTITY_PICKUP)
    for _,ent in pairs(ents) do
      if(ent.Variant == PickupVariant.PICKUP_LOCKEDCHEST and ent.FrameCount == 1 and ent.FlipX == false) then
        local chance = .2
        local random = math.random()
        ent.FlipX = true
        if(random < chance) then
          ent:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, 9001, false)
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_UPDATE, holy_key.Update)
