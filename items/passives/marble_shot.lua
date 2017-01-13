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
        local radians = math.rad((360/count) * i)
        local vx = math.floor(math.cos(radians))
        local vy = math.floor(math.sin(radians))
        local tear = ply:FireTear(dmg_target.Position, Vector(vx,vy):Normalized() * 15, false, true, false)
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
      if(ent.Parent.Type == ply.Type and not table.contains(marbles,ent.Index) and ent.FrameCount == 1) then
        local chance = .25 * (1 + ply.Luck * .5)
        if(ent.Position:Distance(ply.Position) > 20) then chance = .025 * (1 + ply.Luck) end
        local random = math.random()
        if(random <= chance) then
          local rng = RNG()
          rng:SetSeed(math.floor(math.random() * game:GetFrameCount() * math.pi),6)
          local sprite = ent:GetSprite()
          sprite:Load("gfx/items/marbletear.anm2", true)
          sprite:PlayRandom(rng:Next())
          sprite.Scale = Vector(.4 * math.sqrt(ply.Damage),.4 * math.sqrt(ply.Damage))
          sprite.PlaybackSpeed = 1.0
          sprite.Rotation = ent.Velocity.Y * 5
          if(ent.Velocity.Y > 0) then
            sprite.Rotation = sprite.Rotation * -1
            sprite.FlipY = true
          end

          if(ent.Velocity.X < 0) then sprite.FlipX = true end

          table.insert(marbles,ent.Index)
        end
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, marble_shot.OnDamageTaken)
locou:AddCallback(ModCallbacks.MC_POST_RENDER, marble_shot.UpdateTears)
