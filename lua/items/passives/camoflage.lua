local camo = {}
local game = Game()

local Camo = {
  ID = Isaac.GetItemIdByName( "Camoflage" ),
}

table.insert(locou.Items.Passives, Camo)

local frozen = false

function Camo:PostUpdate()
    local ply = game:GetPlayer(0)
    local room = game:GetRoom()
    if(ply:HasCollectible(Camo.ID)) then
    if(room:GetFrameCount() == 1) then frozen = true end
    local entities = Isaac.GetRoomEntities()
    for k,v in pairs (entities) do
      if(v:IsVulnerableEnemy() and frozen) then
        v:AddEntityFlags(EntityFlag.FLAG_FREEZE)
        timer.Simple(2.5, function()
          v:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
        end)
      end
    end
    frozen = false
  end
end

locou:AddCallback(ModCallbacks.MC_POST_UPDATE, Camo.PostUpdate)