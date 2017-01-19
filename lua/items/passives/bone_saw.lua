local bone_saw = {}
local game = Game()

local BoneSaw = {
  ID = Isaac.GetItemIdByName( "Bone Saw" )
}

table.insert(locou.Items.Passives, BoneSaw)

local baseDelay = 1
function bone_saw:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(BoneSaw.ID)) then
    if(flag == CacheFlag.CACHE_FIREDELAY) then
      baseDelay = ply.MaxFireDelay
    end
  end
end

function bone_saw:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(BoneSaw.ID) and game:GetRoom():GetFrameCount() >= 2) then
    ply.MaxFireDelay = baseDelay - math.floor(math.sqrt(ply:GetHearts() * ply:GetCollectibleNum(BoneSaw.ID)) / 5)
  end
end

locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bone_saw.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, bone_saw.Update)
