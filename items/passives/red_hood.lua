local red_hood = {}
local game = Game()

local RedHood = {
  ID = Isaac.GetItemIdByName( "Red Hood" ),
  costume = "313_holymantle.anm2",
  costumeid = 0,
}

--RedHood.costumeid = Isaac.GetCostumeIdByPath("gfx/characters/" .. RedHood.costume)
table.insert(locou.Items.Passives, RedHood)

function red_hood:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(RedHood.ID)) then
    if(flag == CacheFlag.CACHE_DAMAGE) then
      --ply.Damage = ply.Damage + math.sqrt(ply:GetHearts())
    end
  end
end

function red_hood:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(RedHood.ID)) then
    ply.Damage = ply.Damage + math.sqrt(ply:GetHearts()) / 10
  end
end

locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, red_hood.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, red_hood.Update)