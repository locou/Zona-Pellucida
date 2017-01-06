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
  Familiars = {}
}

function locou:Init()
  PlayerItems = {}
end

local update_time = 60 --Calls every 60 frames i.e. 60fps
function locou:Update()
  timer.Update(1/update_time)
end

function locou:ItemUpdate(ply, flag)
  ply = game:GetPlayer(0)
  --if(not table.contains(PlayerItems, 
  if(not flag == CacheFlag.CACHE_FAMILIARS) then else
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
  local count = 1
  for k,v in pairs(Isaac.GetRoomEntities()) do
    if(v.Type == ent_type) then
      count = count + 1
    end
  end
  return count or 1
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function locou:render()
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
