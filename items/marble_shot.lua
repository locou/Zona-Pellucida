local marble_shot = {}
local game = Game()

local MarbleShot = {
  ID = Isaac.GetItemIdByName( "Marble Shot" ),
}

table.insert(locou.Items.Passives, MarbleShot)

local marbles = {}

local damage = 0
function marble_shot:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(MarbleShot.ID)) then
    if(dmg_target:IsVulnerableEnemy() and dmg_source.Type == EntityType.ENTITY_TEAR and dmg_target ~= ply and table.contains(marbles, dmg_source.Entity.Index)) then
      local count = 8
      for i=1,count do
        local radians =  (360/count) * i * (math.pi/180)
        local vx = 15 * math.cos(radians)
        local vy = 15 * math.sin(radians)
        local tear = ply:FireTear(dmg_target.Position, Vector(vx,vy), false, true, false)
      end
      if(not timer.Exists("damage_penalty")) then
          damage = ply.Damage
          ply.Damage = ply.Damage/2
          timer.Create("damage_penalty", 4.0, 1, function()
            ply.Damage = damage
          end)
          timer.Start("damage_penalty")
        end
    end
  end
end

local shot = false
function marble_shot:UpdateTears()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(MarbleShot.ID)) then
    local ents = locou:GetEntitiesByType(EntityType.ENTITY_TEAR)
    for _,ent in pairs(ents) do
      if(ent.Parent.Type == ply.Type and not table.contains(marbles,ent.Index) and ent.FrameCount == 0) then
        local chance = 0.1 * (1 + ply.Luck)
        if(ent.Position:Distance(ply.Position) > 20) then chance = 0.025 * (1 + ply.Luck) end
        if(math.random() < chance) then
          ent.Color = Color(0,0,0,255,255,0,0)
          local sprite = ent:GetSprite()
          sprite:Load("gfx/002.018_diamond tear.anm2", true)
          sprite:Play(ent:GetSprite():GetDefaultAnimationName(), false)
          sprite.Scale = Vector(.3 * math.sqrt(ply.Damage),.25 * math.sqrt(ply.Damage))
          sprite:Update()
          table.insert(marbles,ent.Index)
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, marble_shot.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, marble_shot.UpdateTears)