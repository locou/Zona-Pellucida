local born_from_ash = {}
local game = Game()

local BornFromAsh = {
  ID = Isaac.GetItemIdByName( "Born From Ash" ),
  Variant = Isaac.GetEntityVariantByName( "Mega Maw Flame" )
}

table.insert(locou.Items.Actives, BornFromAsh)

local variants = {}

function born_from_ash:FireLine(start,stop,count)
  local ply = game:GetPlayer(0)
  local distance = start:Distance(stop)
  local last = nil
  for i=1,count do
    local gap = i/count
    local pos = locou:Lerp(start,stop,gap)
    local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, pos, Vector(0,0), ply)
          fire.CollisionDamage = 4
          fire.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
          fire:GetSprite().Scale = Vector(0.3,0.3)
          --fire:GetSprite().Color = Color(0,0,0,4,169,81,255)
          fire:ToEffect():SetTimeout(150)
          fire:ToEffect():SetRadii(32.0,32.0)
          fire:ToEffect():SetDamageSource(EntityType.ENTITY_PLAYER)
  end
end

function born_from_ash:DrawCircle(center,radius,count)
  for i=1,count do
    local radians = math.rad((360/count) * i)
    local x = math.cos(radians) * radius
    local y = math.sin(radians) * radius
    local pos = center + Vector(x,y)
    local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, pos, Vector(0,0), ply)
          fire.CollisionDamage = 4
          fire.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
          fire:GetSprite().Scale = Vector(0.3,0.3)
          --fire:GetSprite().Color = Color(0,0,0,4,169,81,255)
          fire:ToEffect():SetTimeout(150)
          fire:ToEffect():SetRadii(32.0,32.0)
          fire:ToEffect():SetDamageSource(EntityType.ENTITY_PLAYER)
  end
end

function born_from_ash:DrawPentagram(center,radius,count)
  local tau = 2 * math.pi
  local from = tau/4
  local x = center.X
  local y = center.Y
  for i=0,5 do
    to = from + (2/5 * tau)
    local startp = Vector(x + (radius * math.cos(from)), y + (radius * math.sin(from)))
    local endp = Vector(x + (radius * math.cos(to)), y + (radius * math.sin(to)))
    born_from_ash:FireLine(startp,endp,count)
    from = to
  end
end

function born_from_ash:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  if(id == BornFromAsh.ID) then
    born_from_ash:DrawPentagram(ply.Position, 64, 16)
    born_from_ash:DrawCircle(ply.Position, 64, 32)
    return true
  end
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, born_from_ash.Use_Item, BornFromAsh.ID)
