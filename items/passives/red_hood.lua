local red_hood = {}
local game = Game()

local RedHood = {
  ID = Isaac.GetItemIdByName( "Red Hood" )
}

table.insert(locou.Items.Passives, RedHood)

local baseDelay = 1
function red_hood:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(RedHood.ID)) then
    if(flag == CacheFlag.CACHE_FIREDELAY) then
      baseDelay = ply.FireDelay
    end
  end
end

function red_hood:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(RedHood.ID)) then
    ply.FireDelay = baseDelay - math.sqrt(ply:GetHearts()) / 5
  end
end

locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, red_hood.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, red_hood.Update)
