local equality = {}
local game = Game()

local Equality = {
  ID = Isaac.GetItemIdByName( "Equality" ),
}

table.insert(locou.Items.Passives, Equality)

local reward = false
function equality:OnRoomClear()
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasCollectible(Equality.ID)) then
    if(room:IsFirstVisit() and not reward and room:GetFrameCount() == 1) then reward = true end
    if(room:IsFirstVisit() and room:IsClear() and reward) then
      local coins = math.max(ply:GetNumCoins(),1)
      local bombs  = math.max(ply:GetNumBombs(),1)
      local keys  = math.max(ply:GetNumKeys(),1)
      --local chance = math.abs((((coins - keys) / keys) + ((bombs - coins) / coins) + ((keys - bombs) / bombs))/300) * .20
      local chance = (1 - math.sqrt(((math.abs(coins-bombs)+math.abs(coins-keys)+math.abs(keys-bombs))/198)))
      if(math.random() < chance) then
        local rng = RNG()
        rng:SetSeed(math.floor(game:GetFrameCount() * math.pi),6)
        local chest = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, room:FindFreePickupSpawnPosition(ply.Position, 5.0, true), Vector(0,0), ply, 0, rng:Next())
      end
      reward = false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_UPDATE, equality.OnRoomClear)