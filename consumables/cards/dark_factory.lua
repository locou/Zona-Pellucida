local dark_factory = {}
local game = Game()

local DarkFactory = {
  ID = Isaac.GetCardIdByName("Dark Factory"),
  Variant = Isaac.GetEntityVariantByName("Spell Card")
}

table.insert(locou.Items.Cards, DarkFactory)

local cur_floor = LevelStage.STAGE_NULL
local temp = {}

function dark_factory:Init()
  local level = game:GetLevel()
  local cur_floor = level:GetAbsoluteStage()
end

function dark_factory:IsNewFloor(level)
  local old_floor = cur_floor
  cur_floor = level:GetAbsoluteStage()
  
  return old_floor ~= cur_floor
end

function dark_factory:Use_Card(card)
  if(card == DarkFactory.ID) then
    local ply = game:GetPlayer(0)
    local familiars = locou:GetEntitiesByType(EntityType.ENTITY_FAMILIAR)
    local fam1 = familiars[math.random() * #familiars]
    local fam2 = familiars[math.random() * #familiars]
    if(fam1 ~= nil) then
      local fam = game:Spawn(EntityType.ENTITY_FAMILIAR, fam1.Variant, ply.Position, Vector(0,0), ply, 1, 1)
      if(not table.contains(temp,fam)) then table.insert(temp, fam) end
    end
    if(fam2 ~= nil) then
      local fam = game:Spawn(EntityType.ENTITY_FAMILIAR, fam2.Variant, ply.Position, Vector(0,0), ply, 1, 1)
      if(not table.contains(temp,fam)) then table.insert(temp, fam) end
    end
  end
end

function dark_factory:PostUpdate()
    local ply = game:GetPlayer(0)
    local level = game:GetLevel()
    if(ply:HasCollectible(DarkFactory.ID)) then
      if(dark_factory:IsNewFloor(level)) then
        for _,v in pairs(temp) do
          v:Kill()
        end
      end
    end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, dark_factory.Init)
locou:AddCallback(ModCallbacks.MC_USE_CARD, dark_factory.Use_Card, DarkFactory.ID)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, dark_factory.PostUpdate)