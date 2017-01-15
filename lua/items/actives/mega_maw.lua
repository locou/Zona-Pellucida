local mega_maw = {}
local game = Game()

local MegaMaw = {
  ID = Isaac.GetItemIdByName( "Mega Maw" ),
  Variant = Isaac.GetEntityVariantByName( "Mega Maw Flame" )
}

table.insert(locou.Items.Actives, MegaMaw)
local fires = {}
local fires2 = {}
local inner_radius = 48
local outer_radius = 80
local speedmod = 3.0

function mega_maw:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  if(id == MegaMaw.ID) then
    local inner_fires = {
      count = 0,
      out = 0.0001
    }
    local outer_fires = {
      count = 0,
      out = 0.0001
    }
    for i=1,8 do
      local fire = game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE,ply.Position + Vector(0.0,32.0), Vector(0,0), ply, 1, 1)
      fire.CollisionDamage = 15
      fire.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
      fire:GetSprite().Scale = Vector(1.0,1.0)
      fire:GetSprite().Color = Color(0,0,0,4,169,81,255)
      fire:ToEffect():SetTimeout(150)
      fire:ToEffect():SetRadii(32.0,32.0)
      fire:ToEffect():SetDamageSource(EntityType.ENTITY_PLAYER)
      table.insert(inner_fires, fire)
    end
    for i=1,16 do
      local fire = game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE,ply.Position + Vector(0.0,32.0), Vector(0,0), ply, 1, 1)
      fire.CollisionDamage = 15
      fire.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
      fire:GetSprite().Scale = Vector(1.0,1.0)
      fire:GetSprite().Color = Color(0,0,0,4,169,81,255)
      fire:ToEffect():SetTimeout(150)
      fire:ToEffect():SetRadii(32.0, 32.0)
      fire:ToEffect():SetDamageSource(EntityType.ENTITY_PLAYER)
      table.insert(outer_fires, fire)
    end
    table.insert(fires,inner_fires)
    table.insert(fires2,outer_fires)
    return true
  end
end

function mega_maw:UpdateFlames()
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(fires ~= nil and fires2 ~= nil) then
    for _,f in pairs(fires) do
      for k,v in pairs(f) do
        if(type(v) ~= "number") then
          local count = f["count"]
          local out = f["out"]
          local angle = (count * (360/(#f - 2))) * (math.pi/180)
          local x = ply.Position.X + math.cos(-1*((v.FrameCount * 0.75 * math.pi)/60 + angle)) * (inner_radius + out)
          local y = ply.Position.Y + math.sin(-1*((v.FrameCount * 0.75 * math.pi)/60 + angle)) * (inner_radius + out)
          v.Position = Vector(x,y)
          f["count"] = count + 1
        end
        if(type(v) == "number" and v == f["out"]) then
          f["out"] = f["out"] + 0.66 * speedmod
        end
      end
    end
    for _,f in pairs(fires2) do
      for k,v in pairs(f) do
        if(type(v) ~= "number") then
          local count = f["count"]
          local out = f["out"]
          local angle = (count * (360/(#f - 2))) * (math.pi/180)
          local x = ply.Position.X + math.cos(1*((v.FrameCount * 0.5 * math.pi)/60 + angle)) * (outer_radius + out)
          local y = ply.Position.Y + math.sin(1*((v.FrameCount * 0.5 * math.pi)/60 + angle)) * (outer_radius + out)
          v.Position = Vector(x,y)
          f["count"] = count + 1
        end
        if(type(v) == "number" and v == f["out"]) then
          f["out"] = f["out"] + 1.0 * speedmod
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, mega_maw.Use_Item, MegaMaw.ID)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, mega_maw.UpdateFlames)
