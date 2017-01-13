local mothers_intuition = {}
local game = Game()

local MothersIntuition = {
  ID = Isaac.GetItemIdByName( "Mother's Intuition" ),
  dmg_mod = 1.3
}

table.insert(locou.Items.Passives, MothersIntuition)

function mothers_intuition:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(MothersIntuition.ID)) then
    if(flag == CacheFlag.CACHE_DAMAGE) then
      ply.Damage = ply.Damage * MothersIntuition.dmg_mod
    end
  end
end

function mothers_intuition:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasCollectible(MothersIntuition.ID)) then
    local chance = 1.0
    if(math.random() < chance) then
      local hand = game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MOMS_HAND, dmg_source.Entity.Position, Vector(0,0), ply, 0, 1):ToEffect()
      hand:SetRadii(40.0, 60.0)
      hand:SetTimeout(3.0)
      hand:SetDamageSource(EntityType.ENTITY_PLAYER)
      hand.CollisionDamage = 40.0
      hand.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
      Isaac.DebugString(tostring(hand.CollisionDamage))
    end
  end
end

locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mothers_intuition.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mothers_intuition.OnDamageTaken, EntityType.ENTITY_PLAYER)
