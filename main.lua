if locou == nil then
  locou = RegisterMod( "Zona-Pellucida" , 1 )
end

function Include(aFilename)
  local sourcePath = debug.getinfo(1, "S").source:sub(2)
  local baseDir = sourcePath:match(".*/") or "./"

  dofile( ("%s%s"):format(baseDir .. "lua/", aFilename) )
end

Include('timer.lua')

local game = Game()

locou.Items = {
  Actives = {},
  Passives = {},
  Familiars = {},
  Trinkets = {},
  Cards = {
    Yugi = {},
    Poke = {}
  }
}

function locou:Init()
  PlayerItems = {}
end

function locou:Update()
end

locou.Pickups = {
  keys = {
    Variant = PickupVariant.PICKUP_KEY,
    SubTypes = {
      KeySubType.KEY_NORMAL,
      KeySubType.KEY_DOUBLEPACK,
      KeySubType.KEY_GOLDEN,
      KeySubType.KEY_CHARGED
    }
  },
  bombs = {
    Variant = PickupVariant.PICKUP_BOMB,
    SubTypes = {
      BombSubType.BOMB_NORMAL,
      BombSubType.BOMB_DOUBLEPACK,
      BombSubType.BOMB_GOLDEN
    }
  },
  coins = {
    Variant = PickupVariant.PICKUP_COIN,
    SubTypes = {
      CoinSubType.COIN_PENNY,
      CoinSubType.COIN_DOUBLEPACK,
      CoinSubType.COIN_NICKEL,
      CoinSubType.COIN_STICKYNICKEL,
      CoinSubType.COIN_DIME
    }
  },
  hearts = {
    Variant = PickupVariant.PICKUP_HEART,
    SubTypes = {
      HeartSubType.HEART_HALF,
      HeartSubType.HEART_FULL,
      HeartSubType.HEART_DOUBLEPACK,
      HeartSubType.HEART_HALF_SOUL,
      HeartSubType.HEART_SOUL,
      HeartSubType.HEART_BLENDED,
      HeartSubType.HEART_BLACK,
      HeartSubType.HEART_GOLDEN,
      HeartSubType.HEART_ETERNAL
    }
  }
}

locou.Pickups_Index = {"keys", "bombs", "coins", "hearts"}

function locou:ItemUpdate(ply, flag)
  ply = game:GetPlayer(0)
  if(not flag == CacheFlag.CACHE_FAMILIARS) then
  else
    for k,v in pairs(locou.Items.Familiars) do
      if(locou:CountEntities(v.Type, v.Variant) > ply:GetCollectibleNum(v.ID)) then
          local count = locou:CountEntities(v.Type, v.Variant) - ply:GetCollectibleNum(v.ID)
          local fams = locou:GetEntitiesByVariant(v.Type, v.Variant)
          for _,v in pairs(fams) do
            if(count > 0) then
              v:Kill()
              count = count - 1
            else
              break
            end
          end
      else
        locou:InitFamiliar(ply, v.ID, v.Type, v.Variant)
      end
    end
  end
end

function locou:InitFamiliar(ply, familiar_item, familiar_type, familiar_variant)
  if(ply:HasCollectible(familiar_item)) then
    for i = 1 + locou:CountEntities(familiar_type, familiar_variant), ply:GetCollectibleNum(familiar_item) do
      local fam = game:Spawn(familiar_type, familiar_variant, ply.Position, Vector(0,0), ply, EntityType.ENTITY_FAMILIAR, 0):ToFamiliar()
    end
  else
  end
end

function locou:SpawnRandomChest(pos, velocity)
  if(velocity == nil) then velocity = Vector(0,0) end
  local room = game:GetRoom()
  local rng = RNG()
  rng:SetSeed(math.floor(math.random() * game:GetFrameCount() * math.pi),6)
  local chest = game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, room:FindFreePickupSpawnPosition(pos, 5.0, true), velocity, nil, 0, rng:Next())
  return chest
end

function locou:SpawnRandomPickup(type, pos, velocity)
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(type == nil) then type = "random" else type = string.lower(type) end
  if(pos == nil) then pos = ply.Position end
  if(velocity == nil) then velocity = Vector(0,0) end
  local pickup = nil
  if(type == "random") then
    pickup = locou.Pickups[locou.Pickups_Index[math.random(table.length(locou.Pickups))]]
  else
    pickup = locou.Pickups[type]
  end

  local variant = pickup.Variant
  local subtype = pickup.SubTypes[math.random(table.length(pickup.SubTypes))]
  local ent = game:Spawn(EntityType.ENTITY_PICKUP, variant, room:FindFreePickupSpawnPosition(pos, 20.0, true), velocity, ply, subtype, 1)
  return ent
end

function locou:CountEntities(ent_type, ent_variant)
  local count = 0
  for k,v in pairs(Isaac.GetRoomEntities()) do
    if(v.Type == ent_type and v.Variant == ent_variant) then
      count = count + 1
    end
  end
  return count or 0
end

function locou:Lerp(a,b,t)
  local u = 1 - t
  local x = a.X*u + b.X*t
  local y = a.Y*u + b.Y*t
  return Vector(x,y)
end

function locou:GetCollectibles()
    local ply = game:GetPlayer(0)
    local items = {}
    for i = 1, CollectibleType.NUM_COLLECTIBLES do
        if(ply:HasCollectible(i) and not table.contains(items, i)) then
          table.insert(items, i)
        end
    end
    return items
end

function locou:GetEnemies()
  local room_ents = Isaac.GetRoomEntities()
  local ents = {}
  for k,v in pairs(room_ents) do
    if(v:IsVulnerableEnemy()) then
      table.insert(ents, v)
    end
  end
  return ents
end

function locou:HasEnemies()
  local room_ents = Isaac.GetRoomEntities()
  for k,v in pairs(room_ents) do
    if(v:IsEnemy()) then
      return true
    end
  end
  return false
end

function locou:GetRandomEnemyByDistance(pos, distance)
  local room_ents = Isaac.GetRoomEntities()
  local ents = {}
  for k,v in pairs(room_ents) do
    if(v:IsVulnerableEnemy() and v.Position:Distance(pos) <= distance) then
      table.insert(ents, v)
    end
  end
  if(#ents < 1) then return nil end
  return ents[math.random(#ents)]
end

function locou:GetEntitiesByDistance(ent, distance)
  local room_ents = Isaac.GetRoomEntities()
  local ents = {}
  for k,v in pairs(room_ents) do
    if(ent.Position:Distance(v.Position) <= distance and v ~= ent) then
      table.insert(ents, v)
    end
  end
  return ents
end

function locou:GetEntitiesByType(ent_type)
  local room_ents = Isaac.GetRoomEntities()
  local ents = {}
  for k,v in pairs(room_ents) do
    if(v.Type == ent_type) then
      table.insert(ents, v)
    end
  end
  return ents
end

function locou:GetEntitiesByVariant(ent_type, ent_variant)
  local room_ents = Isaac.GetRoomEntities()
  local ents = {}
  for k,v in pairs(room_ents) do
    if(v.Type == ent_type and v.Variant == ent_variant) then
      table.insert(ents, v)
    end
  end
  return ents
end

function locou:GetWeaponType()
    local ply = game:GetPlayer(0)
    for i = 0, #WeaponType - 1 do
      if(ply:HasWeaponType(k)) then
        return k
      end
    end
    return WeaponType.WEAPON_TEARS
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function table.foreach(table, func)
  for _, value in pairs(table) do
    if(value ~= nil) then
      func(value)
    end
  end
end

function table.length(table)
  local count = 0
  for _ in pairs(table) do
    count = count + 1
  end
  return count
end

function table.serialize(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. table.serialize(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

local update_time = 60 --Calls every 60 frames i.e. 60fps
function locou:render()
    timer.Update(1/update_time)
    Isaac.RenderText("Frame Count:"..game:GetFrameCount(), 50, 15, 255, 255, 255, 255)
end

locou:AddCallback(ModCallbacks.MC_POST_RENDER, locou.render)
locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, locou.ItemUpdate)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, locou.Update);
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, locou.Init);

TearFlags = {
	FLAG_NO_EFFECT = 0,
	FLAG_SPECTRAL = 1,
	FLAG_PIERCING = 1<<1,
	FLAG_HOMING = 1<<2,
	FLAG_SLOWING = 1<<3,
	FLAG_POISONING = 1<<4,
	FLAG_FREEZING = 1<<5,
	FLAG_COAL = 1<<6,
	FLAG_PARASITE = 1<<7,
	FLAG_MAGIC_MIRROR = 1<<8,
	FLAG_POLYPHEMUS = 1<<9,
	FLAG_WIGGLE_WORM = 1<<10,
	FLAG_UNK1 = 1<<11, --No noticeable effect
	FLAG_IPECAC = 1<<12,
	FLAG_CHARMING = 1<<13,
	FLAG_CONFUSING = 1<<14,
	FLAG_ENEMIES_DROP_HEARTS = 1<<15,
	FLAG_TINY_PLANET = 1<<16,
	FLAG_ANTI_GRAVITY = 1<<17,
	FLAG_CRICKETS_BODY = 1<<18,
	FLAG_RUBBER_CEMENT = 1<<19,
	FLAG_FEAR = 1<<20,
	FLAG_PROPTOSIS = 1<<21,
	FLAG_FIRE = 1<<22,
	FLAG_STRANGE_ATTRACTOR = 1<<23,
	FLAG_UNK2 = 1<<24, --Possible worm?
	FLAG_PULSE_WORM = 1<<25,
	FLAG_RING_WORM = 1<<26,
	FLAG_FLAT_WORM = 1<<27,
	FLAG_UNK3 = 1<<28, --Possible worm?
	FLAG_UNK4 = 1<<29, --Possible worm?
	FLAG_UNK5 = 1<<30, --Possible worm?
	FLAG_HOOK_WORM = 1<<31,
	FLAG_GODHEAD = 1<<32,
	FLAG_UNK6 = 1<<33, --No noticeable effect
	FLAG_UNK7 = 1<<34, --No noticeable effect
	FLAG_EXPLOSIVO = 1<<35,
	FLAG_MULTIDIMENSIONAL = 1<<36,
	FLAG_HOLY_LIGHT = 1<<37,
	FLAG_KEEPER_HEAD = 1<<38,
	FLAG_ENEMIES_DROP_BLACK_HEARTS = 1<<39,
	FLAG_ENEMIES_DROP_BLACK_HEARTS2 = 1<<40,
	FLAG_GODS_FLESH = 1<<41,
	FLAG_UNK8 = 1<<42, --No noticeable effect
	FLAG_TOXIC_LIQUID = 1<<43,
	FLAG_OUROBOROS_WORM = 1<<44,
	FLAG_GLAUCOMA = 1<<45,
	FLAG_BOOGERS = 1<<46,
	FLAG_PARASITOID = 1<<47,
	FLAG_UNK9 = 1<<48, --No noticeable effect
	FLAG_SPLIT = 1<<49,
	FLAG_DEADSHOT = 1<<50,
	FLAG_MIDAS = 1<<51,
	FLAG_EUTHANASIA = 1<<52,
	FLAG_JACOBS_LADDER = 1<<53,
	FLAG_LITTLE_HORN = 1<<54,
	FLAG_GHOST_PEPPER = 1<<55
}

--Items

--Actives--
--Include('items/actives/')
Include('items/actives/chirurgical_extraction.lua')
Include('items/actives/meeple.lua')
Include('items/actives/carving_knife.lua')
Include('items/actives/item_shredder.lua')
Include('items/actives/pocket_sand.lua')
Include('items/actives/mega_maw.lua')
Include('items/actives/born_from_ash.lua')
--Passives--
--Include('items/passives/')
Include('items/passives/hot_iron.lua')
Include('items/passives/challenger.lua')
Include('items/passives/full_vessel.lua')
Include('items/passives/camoflage.lua')
Include('items/passives/bodyguards.lua')
Include('items/passives/holy_key.lua')
Include('items/passives/marble_shot.lua')
Include('items/passives/strong_reaction.lua')
Include('items/passives/red_hood.lua')
Include('items/passives/damage_control.lua')
Include('items/passives/mothers_intuition.lua')
Include('items/passives/vector_shot.lua')
Include('items/passives/exp_bar.lua')
--Familiars--
--Include('items/familiars/')
Include('items/familiars/pet_rock.lua')
Include('items/familiars/kind_egg.lua')
Include('items/familiars/foul_egg.lua')
Include('items/familiars/equality.lua')
--Trinkets--
--Include('items/trinkets/')
Include('items/trinkets/bee_stinger.lua')
Include('items/trinkets/coin_on_a_string.lua')
Include('items/trinkets/pity_party.lua')
Include('items/trinkets/goat_eye.lua')
--Cards--
--Include('consumables/cards/')
Include('consumables/cards/cards.lua')
Include('consumables/cards/dark_factory.lua')
Include('consumables/cards/emergency_provisions.lua')
Include('consumables/cards/eternal_rest.lua')
Include('consumables/cards/just_deserts.lua')
Include('consumables/cards/magic_cylinder.lua')
Include('consumables/cards/mirror_force.lua')
Include('consumables/cards/pot_of_greed.lua')
Include('consumables/cards/scapegoat.lua')
Include('consumables/cards/scoop_up.lua')
Include('consumables/cards/switch.lua')
Include('consumables/cards/spellbinding_circle.lua')
Include('consumables/cards/sleep.lua')
Include('consumables/cards/torrental_tribute.lua')
