if locou == nil then
  locou = RegisterMod( "Zona-Pellucida" , 0 )
end

function Include(aFilename)
  local sourcePath = debug.getinfo(1, "S").source:sub(2)
  local baseDir = sourcePath:match(".*/") or "./"
  
  dofile( ("%s%s"):format(baseDir, aFilename) )
end

Include('lua/timer.lua')

local game = Game()

locou.Items = {
  Actives = {},
  Passives = {},
  Familiars = {},
  Trinkets = {}
}

function locou:Init()
  PlayerItems = {}
end

function locou:Update()
end

locou.Pickups = {
  Keys = {
    Variant = PickupVariant.PICKUP_KEY,
    SubTypes = {
      KeySubType.KEY_NORMAL,
      KeySubType.KEY_DOUBLEPACK,
      KeySubType.KEY_GOLDEN,
      KeySubType.KEY_CHARGED
    }
  },
  Bombs = {
    Variant = PickupVariant.PICKUP_BOMB,
    SubTypes = {
      BombSubType.BOMB_NORMAL,
      BombSubType.BOMB_DOUBLEPACK,
      BombSubType.BOMB_GOLDEN
    }
  },
  Coins = {
    Variant = PickupVariant.PICKUP_COIN,
    SubTypes = {
      CoinSubType.COIN_PENNY,
      CoinSubType.COIN_DOUBLEPACK,
      CoinSubType.COIN_NICKEL,
      CoinSubType.COIN_STICKYNICKEL,
      CoinSubType.COIN_DIME
    }
  },
  Hearts = {
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

locou.Pickups_Index = {"Keys", "Bombs", "Coins", "Hearts"}


function locou:ItemUpdate(ply, flag)
  ply = game:GetPlayer(0)
  if(not flag == CacheFlag.CACHE_FAMILIARS) then
  else
    for k,v in pairs(locou.Items.Familiars) do
      locou:InitFamiliar(ply, v.ID, v.Type, v.Variant)
    end
  end
end

function locou:InitFamiliar(ply, familiar_item, familiar_type, familiar_variant)
  if(ply:HasCollectible(familiar_item)) then
    for i = locou:CountEntities(familiar_type), ply:GetCollectibleNum(familiar_item) do
      local fam = game:Spawn(familiar_type, familiar_variant, ply.Position, Vector(0,0), ply, EntityType.ENTITY_FAMILIAR, 0):ToFamiliar()
    end
  else
  end
end

function locou:CountEntities(ent_type)
  local count = 0
  for k,v in pairs(Isaac.GetRoomEntities()) do
    if(v.Type == ent_type) then
      count = count + 1
    end
  end
  return count or 0
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

function locou:GetEntitiesByVariant(ent_variant)
  local room_ents = Isaac.GetRoomEntities()
  local ents = {}
  for k,v in pairs(room_ents) do
    if(v.Variant == ent_variant) then
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

local update_time = 60 --Calls every 60 frames i.e. 60fps
function locou:render()
    timer.Update(1/update_time)
    Isaac.RenderText("Frame Count:"..game:GetFrameCount(), 50, 15, 255, 255, 255, 255)
end

locou:AddCallback(ModCallbacks.MC_POST_RENDER, locou.render)
locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, locou.ItemUpdate)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, locou.Update);
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, locou.Init);

--Items
Include('items/hot_iron.lua')
Include('items/pet_rock.lua')
Include('items/chirurgical_extraction.lua')
Include('items/bee_stinger.lua')
Include('items/coin_on_a_string.lua')
Include('items/challenger.lua')
Include('items/full_vessel.lua')
Include('items/camoflage.lua')
Include('items/equality.lua')
Include('items/bodyguards.lua')
Include('items/holy_key.lua')
Include('items/marble_shot.lua')
Include('items/pity_party.lua')