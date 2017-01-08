local challenger = {}
local game = Game()

local Challenger = {
  ID = Isaac.GetItemIdByName( "Challenger" ),
}

table.insert(locou.Items.Passives, Challenger)

local cur_floor = LevelStage.STAGE_NULL

function challenger:Init()
  local level = game:GetLevel()
  local cur_floor = level:GetAbsoluteStage()
end

function challenger:IsNewFloor(level)
  local old_floor = cur_floor
  cur_floor = level:GetAbsoluteStage()
  
  return old_floor ~= cur_floor
end

function challenger:PostUpdate()
    local ply = game:GetPlayer(0)
    local level = game:GetLevel()
    if(ply:HasCollectible(Challenger.ID)) then
      if(challenger:IsNewFloor(level)) then
        local challenge = level:QueryRoomTypeIndex(RoomType.ROOM_CHALLENGE, false, RNG())
        level:ChangeRoom(challenge)
      end
    end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, challenger.Init)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, challenger.PostUpdate)