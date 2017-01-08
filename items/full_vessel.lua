local full_vessel = {}
local game = Game()

local FullVessel = {
  ID = Isaac.GetItemIdByName( "Full Vessel" ),
  costume = "313_holymantle.anm2",
  costumeid = 0,
  dmg_mod = 1.5,
  speed_bonus = 1
}

local hasCostume = false;

table.insert(locou.Items.Passives, FullVessel)

function full_vessel:Init()
    FullVessel.costumeid = Isaac.GetCostumeIdByPath("gfx/characters/" .. FullVessel.costume)
end

function full_vessel:EvaluateCache(ply, flag)
  ply = game:GetPlayer(0)
  if(ply:HasCollectible(FullVessel.ID)) then
    ply:AddBlackHearts(-40)
    ply:AddSoulHearts(-40)
    if(flag == CacheFlag.CACHE_DAMAGE) then
      ply.Damage = ply.Damage * FullVessel.dmg_mod
    end
    if(flag == CacheFlag.CACHE_SPEED) then
      ply.MoveSpeed = ply.MoveSpeed + FullVessel.speed_bonus
    end
    if(not hasCostume) then
      ply:AddNullCostume(FullVessel.costumeid)
    end
  end
end

function full_vessel:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(FullVessel.ID)) then
    if(ply:GetSoulHearts() > 0 or ply:GetBlackHearts() > 0 and hasCostume) then
      ply:TryRemoveNullCostume(FullVessel.costumeid)
      hasCostume = false
    elseif(not hasCostume) then
      ply:AddNullCostume(FullVessel.costumeid)
      hasCostume = true
    end
    if(hasCostume) then
      local near_ents = locou:GetEntitiesByDistance(ply,60)
      for k,v in pairs(near_ents) do
        if(v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_FREEZE) and not v:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then
          v:AddFreeze(EntityRef(v), 240)
          v:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
          timer.Simple(6.0, function()
              v:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
          end)
        end
      end
    end
  end
end

function full_vessel:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(FullVessel.ID)) then
      if(dmg_target:HasEntityFlags(EntityFlag.FLAG_FREEZE) and dmg_amount >= dmg_target.HitPoints and dmg_target:IsEnemy() and hasCostume) then
        for i=1,6 do
          ply:FireTear(dmg_target.Position, RandomVector() * 15, true, true, false)
        end
      end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, full_vessel.Init)
locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, full_vessel.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, full_vessel.Update)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, full_vessel.OnDamageTaken)