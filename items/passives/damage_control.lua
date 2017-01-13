local damage_control = {}
local game = Game()

local DamageControl = {
  ID = Isaac.GetItemIdByName( "Damage Control" ),
  dmg_mod = 1.2
}

table.insert(locou.Items.Passives, DamageControl)

local has = false
function damage_control:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(DamageControl.ID)) then
    if(flag == CacheFlag.CACHE_DAMAGE) then
      ply.Damage = ply.Damage * DamageControl.dmg_mod
    end
    if(not has) then
      ply:AddKeys(-5)
      ply:AddBombs(-5)
      ply:AddCoins(-5)
      has = true
    end
  end
end

locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, damage_control.EvaluateCache)