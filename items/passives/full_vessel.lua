local full_vessel = {}
local game = Game()

local FullVessel = {
  ID = Isaac.GetItemIdByName( "Full Vessel" ),
  costume = "fullvessel.anm2",
  costumeid = 0,
  dmg_mod = 1.5,
  speed_bonus = 1
}

FullVessel.costumeid = Isaac.GetCostumeIdByPath("gfx/characters/" .. FullVessel.costume)
table.insert(locou.Items.Passives, FullVessel)

local hasCostume = false

function full_vessel:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
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
          v:AddFreeze(EntityRef(v), 4 * 60)
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
        local count = 6
        for i=1,count do
        local radians = (360/count) * i * (math.pi/180)
        local vx = math.floor(15 * math.cos(radians))
        local vy = math.floor(15 * math.sin(radians))
        ply:FireTear(dmg_target.Position, Vector(vx,vy), true, true, false)
        end
      end
  end
end

locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, full_vessel.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, full_vessel.Update)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, full_vessel.OnDamageTaken)
