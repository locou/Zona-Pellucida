local vector_shot = {}
local game = Game()

local VectorShot = {
  ID = Isaac.GetItemIdByName( "Vector Shot" ),
}

table.insert(locou.Items.Passives, VectorShot)

local shots = {}

local shot = false
function vector_shot:UpdateTears()
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(VectorShot.ID)) then
    local ents = locou:GetEntitiesByType(EntityType.ENTITY_TEAR)
    for _,ent in pairs(ents) do
      if(ent.Parent.Type == ply.Type and not table.contains(shots,ent.Index) and ent.FrameCount == 1) then
        local chance = 1.25 * (1 + ply.Luck * .5)
        if(ent.Position:Distance(ply.Position) > 20) then chance = 1.025 * (1 + ply.Luck) end
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

          table.insert(shots,ent.Index)
        end
      end
      if(table.contains(shots,ent.Index)) then
        ent.Velocity = ent.Velocity * (math.sqrt(ent.FrameCount) / 3)
        local sprite = ent:GetSprite()
        sprite.Scale = Vector(.4 * math.sqrt(ply.Damage),(.4 * math.sqrt(ply.Damage)) / (math.sqrt(ent.FrameCount) / 3))
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_RENDER, vector_shot.UpdateTears)
