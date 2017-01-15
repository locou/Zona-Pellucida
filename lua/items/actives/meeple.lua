local meeple = {}
local game = Game()

local Meeple = {
  ID = Isaac.GetItemIdByName( "Meeple" ),
  Type = Isaac.GetEntityTypeByName( "Meeple" ),
  Variant = Isaac.GetEntityVariantByName( "Meeple" )
}

table.insert(locou.Items.Actives, Meeple)

function meeple:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  if(id == Meeple.ID) then
    local meep = game:Spawn(Meeple.Type, Meeple.Variant, ply.Position, Vector(0,0), ply, 1, 1)
  end
end

function meeple:UpdateFamiliar(ent)
  if(not timer.Exists("meeple"..ent.Index)) then
    timer.Create("meeple"..ent.Index,0.35,0, function()
        if(game:IsPaused() or ent:IsDead()) then return end
        local range = 300
        if(ent.Target == nil or ent.Target:IsDead() or ent.Target.Position:Distance(ent.Position) > range) then
          target = locou:GetRandomEnemyByDistance(ent.Position, range)
          ent.Target = target
        end
        if(ent.Target ~= nil) then
          local heading = ent.Target.Position - ent.Position
          local tear = ent:FireProjectile(heading:Normalized())
        end
    end)
    timer.Start("meeple"..ent.Index)
  end
end

function meeple:OnRoomClear()
  local room = game:GetRoom()
  if(room:IsClear()) then
    local ents = locou:GetEntitiesByVariant(Meeple.Type, Meeple.Variant)
    for _,v in pairs(ents) do
      if(v ~= nil) then
        timer.Destroy("meeple"..v.Index)
        v:Kill()
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, meeple.Use_Item, Meeple.ID)
locou:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, meeple.UpdateFamiliar, Meeple.Variant)
locou:AddCallback(ModCallbacks.MC_POST_UPDATE, meeple.OnRoomClear)