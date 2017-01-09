local bodyguards = {}
local game = Game()

local Bodyguards = {
  ID = Isaac.GetItemIdByName( "Bodyguards" ),
}

table.insert(locou.Items.Passives, Bodyguards)

local familiars = {}

local acceptable_variants = {
  FamiliarVariant.ABEL,
  FamiliarVariant.BROTHER_BOBBY,
  FamiliarVariant.BUM_FRIEND,
  FamiliarVariant.DARK_BUM,
  FamiliarVariant.DRY_BABY,
  FamiliarVariant.GHOST_BABY,
  FamiliarVariant.DEMON_BABY,
  FamiliarVariant.HARLEQUIN_BABY,
  FamiliarVariant.LIL_BRIMSTONE,
  FamiliarVariant.LIL_HAUNT,
  FamiliarVariant.LITTLE_CHAD,
  FamiliarVariant.LITTLE_CHUBBY,
  FamiliarVariant.LITTLE_GISH,
  FamiliarVariant.LITTLE_STEVEN,
  FamiliarVariant.MONGO_BABY,
  FamiliarVariant.RAINBOW_BABY,
  FamiliarVariant.ROBO_BABY,
  FamiliarVariant.ROBO_BABY_2,
  FamiliarVariant.ROTTEN_BABY,
  FamiliarVariant.SISTER_MAGGY,
  FamiliarVariant.MULTIDIMENSIONAL_BABY,
  FamiliarVariant.FARTING_BABY,
  FamiliarVariant.KEY_BUM,
  FamiliarVariant.SERAPHIM,
  FamiliarVariant.SWORN_PROTECTOR,
  FamiliarVariant.INCUBUS,
  FamiliarVariant.GUARDIAN_ANGEL
}

local cur_floor = LevelStage.STAGE_NULL
local next_fam = 1
local previous_fam = 0

function bodyguards:Init()
  local level = game:GetLevel()
  local cur_floor = level:GetAbsoluteStage()
end

function bodyguards:IsNewFloor(level)
  local old_floor = cur_floor
  cur_floor = level:GetAbsoluteStage()
  
  return old_floor ~= cur_floor
end

function bodyguards:PostUpdate()
    local ply = game:GetPlayer(0)
    local level = game:GetLevel()
    local room = game:GetRoom()
    if(ply:HasCollectible(Bodyguards.ID)) then
      if(bodyguards:IsNewFloor(level) and room:GetFrameCount() == 1) then
        next_fam = 1
        previous_fam = 0
        ply:RespawnFamiliars()
      end
    end
end

function bodyguards:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames) --TODO: Clean this up / find a better way.
  local ply = game:GetPlayer(0)
  local room = game:GetRoom()
  if(ply:HasCollectible(Bodyguards.ID) and dmg_source.Type ~= EntityType.ENTITY_FIREPLACE) then
    if(familiars ~= nil) then
      if(#familiars > 0 and dmg_amount > 0 and next_fam <= #familiars) then
        if(next_fam > previous_fam) then
          if(not ply:HasEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)) then
            local familiar = familiars[next_fam]
            if(familiar ~= nil) then
              ply:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
              familiar:BloodExplode()
              familiar:Remove()
              previous_fam = next_fam
              next_fam = next_fam + 1
              return false
            end
          else
            if not timer.Exists("invuln_timer") then
              timer.Create("invuln_timer", 0.35, 1, function()
                ply:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
              end)
              timer.Start("invuln_timer")
            end
            return false
          end
        end
      end
    end
  end
end

function bodyguards:EvaluateCache(ply, flags)
  local ply = game:GetPlayer(0)
  next_fam = 1
  previous_fam = 0
  if(flags == CacheFlag.CACHE_FAMILIARS) then
    local fams = locou:GetEntitiesByType(EntityType.ENTITY_FAMILIAR)
    local fams2 = {}
    for _,v in pairs(acceptable_variants) do
      for k,v2 in pairs(fams) do
        if(v2.Variant == v) then
          if(not table.contains(fams2,v2)) then
            table.insert(fams2,v2)
          end
        end
      end
    end
    familiars = fams2
  end
end
locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, bodyguards.Init)
locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bodyguards.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, bodyguards.OnDamageTaken, EntityType.ENTITY_PLAYER)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, bodyguards.PostUpdate)