local torrental_tribute = {}
local game = Game()

local TorrentalTribute = {
  ID = Isaac.GetCardIdByName("01_TorrentalTribute")
}

table.insert(locou.Items.Cards.Poke, TorrentalTribute)

local trigger = false
function torrental_tribute:Init()
  trigger = false
end

function torrental_tribute:Use_Card(card)
  if(card == TorrentalTribute.ID) then
    local ply = game:GetPlayer(0)
    trigger = true
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddFear(EntityRef(ply), 180)
    end
  end
end

function torrental_tribute:OnRoomChange()
    local ply = game:GetPlayer(0)
    local room = game:GetRoom()
    if(trigger) then
      if(room:IsFirstVisit() and room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH and room:GetFrameCount() == 1) then
        local enemies = locou:GetEnemies()
        for _,v in pairs(enemies) do
          v:Kill()
        end
        local fams = locou:GetEntitiesByType(EntityType.ENTITY_FAMILIAR)
        for _,v in pairs(fams) do
          v:Kill()
        end
        trigger = false
      end
    end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, torrental_tribute.Init)
locou:AddCallback(ModCallbacks.MC_USE_CARD, torrental_tribute.Use_Card, TorrentalTribute.ID)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, torrental_tribute.OnRoomChange)
