local holy_key = {}
local game = Game()

local HolyKey = {
  ID = Isaac.GetItemIdByName( "Holy Key" ),
  costume = "313_holymantle.anm2",
  costumeid = 0
}

local hasCostume = false;

table.insert(locou.Items.Passives, HolyKey)

function holy_key:Init()
    HolyKey.costumeid = Isaac.GetCostumeIdByPath("gfx/characters/" .. HolyKey.costume)
end

local handled = {}

function holy_key:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(HolyKey.ID)) then
    local ents = locou:GetEntitiesByType(EntityType.ENTITY_PICKUP)
    for _,ent in pairs(ents) do
      if(ent.Variant == PickupVariant.PICKUP_LOCKEDCHEST and ent.FrameCount == 1) then
        local chance = .2
        local random = math.random()
        if(random < chance) then
          ent:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, 9001, false)
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, holy_key.Init)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, holy_key.Update)