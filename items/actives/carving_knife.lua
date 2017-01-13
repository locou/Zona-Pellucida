local carving_status = {}
local game = Game()

local CarvingKnife = {
  ID = Isaac.GetItemIdByName( "Carving Knife" ),
}

table.insert(locou.Items.Actives, CarvingKnife)

function carving_status:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(id == CarvingKnife.ID) then
    local enemies = locou:GetEnemies()
    if(room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH) then
      for _,v in pairs(enemies) do
        if(v.HitPoints / v.MaxHitPoints <= 0.5) then
            local pos = v.Position
            v:Kill()
            if(math.random() < 0.2) then
              locou:SpawnRandomPickup()
            end
        end
      end
    end
  end
  return true
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, carving_status.Use_Item, CarvingKnife.ID)