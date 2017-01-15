local exp_bar = {}
local game = Game()

local EXPBar = {
  ID = Isaac.GetItemIdByName( "EXP Bar" )
}

table.insert(locou.Items.Passives, EXPBar)

local stats = {
  exp = 0.0,
  tolevel = 15.0,
  damage = 0.0,
  firedelay = 1.0,
  speed = 0.0,
  luck = 0.0
}

local index = {"damage","firedelay","speed","luck"}

local baseDamage
local baseDelay
local baseSpeed
local baseLuck

function exp_bar:Init()
  local ply = game:GetPlayer(0)
  if(Isaac.HasModData(locou)) then
    local save = Isaac.LoadModData(locou)
    assert(load(save))()
  end
end

function exp_bar:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  if(dmg_amount > dmg_target.HitPoints and dmg_target ~= EntityType.ENTITY_FIREPLACE) then
    stats.exp = stats.exp + 1.0
    if(stats.exp >= stats.tolevel) then
      stats.exp = 0
      stats.tolevel = stats.tolevel + math.floor(math.sqrt(stats.tolevel))
      local random = index[math.random(#index)]
      stats[random] = stats[random] + math.max(math.random() * 1.5, .5)
    end
    Isaac.SaveModData(locou, table.serialize(stats, "stats"))
  end
end

function exp_bar:EvaluateCache(ply, flag)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(EXPBar.ID)) then
    if(flag == CacheFlag.CACHE_DAMAGE) then
      baseDamage = ply.Damage
    end
    if(flag == CacheFlag.CACHE_FIREDELAY) then
      baseDelay = ply.MaxFireDelay
    end
    if(flag == CacheFlag.CACHE_SPEED) then
      baseSpeed = ply.MoveSpeed
    end
    if(flag == CacheFlag.CACHE_LUCK) then
      baseLuck = ply.Luck
    end
  end
end

function exp_bar:Update()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(EXPBar.ID) and game:GetRoom():GetFrameCount() >= 2) then
    ply.Damage = baseDamage + stats.damage
    ply.MaxFireDelay = baseDelay - math.floor(stats.firedelay/2)
    ply.MoveSpeed = baseSpeed + (stats.speed * .2)
    ply.Luck = baseLuck + stats.luck
  end
end

function exp_bar:DrawBar(position, width, color)
  if(color == nil) then color = 0 end
  local bar = Sprite()
  bar:Load("gfx/ui/ui_bar.anm2", true)
  bar:Play("Background")
  bar:Render(Isaac.WorldToRenderPosition(position, true), Vector(0,0), Vector(0,0))
  local bar = Sprite()
  bar:Load("gfx/ui/ui_bar.anm2", true)
  bar:SetFrame("Bar", color)
  bar:Render(Isaac.WorldToRenderPosition(position, true), Vector(0,0), Vector(width,0))
  local bar = Sprite()
  bar:Load("gfx/ui/ui_bar.anm2", true)
  bar:Play("Segments")
  bar:Render(Isaac.WorldToRenderPosition(position, true), Vector(0,0), Vector(0,0))
end

function exp_bar:Render()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(EXPBar.ID)) then
    local width = 30
    local exp = width - math.floor((stats.exp/stats.tolevel) * width)
    local health = ply:GetHearts() + ply:GetSoulHearts() + ply:GetBlackHearts()
    local maxhealth = ply:GetMaxHearts() + ply:GetSoulHearts() + ply:GetBlackHearts()
    local hp = width - math.floor((health/maxhealth) * width)
    local mana = ply:GetActiveCharge()
    exp_bar:DrawBar(ply.Position + Vector(0,8.0), exp, 2)
    exp_bar:DrawBar(ply.Position - Vector(0,52), hp, 1)
    Isaac.RenderText("EXP:"..stats.exp .. "/" .. stats.tolevel, 50, 30, 255, 255, 255, 255)
    Isaac.RenderText("Damage:"..stats.damage, 50, 45, 255, 255, 255, 255)
    Isaac.RenderText("FireDelay:"..stats.firedelay, 50, 60, 255, 255, 255, 255)
    Isaac.RenderText("Speed:"..stats.speed, 50, 75, 255, 255, 255, 255)
    Isaac.RenderText("Luck:"..stats.luck, 50, 90, 255, 255, 255, 255)
  end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, exp_bar.Init)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, exp_bar.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, exp_bar.EvaluateCache)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, exp_bar.Update)
locou:AddCallback(ModCallbacks.MC_POST_RENDER, exp_bar.Render)
