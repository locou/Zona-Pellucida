local mirror_force = {}
local game = Game()

local MirrorForce = {
  ID = Isaac.GetCardIdByName("00_MirrorForce")
}

table.insert(locou.Items.Cards.Yugi, MirrorForce)

local shield = false
function mirror_force:Init()
  shield = false
end

function mirror_force:Use_Card(card)
  if(card == MirrorForce.ID) then
    local ply = game:GetPlayer(0)
    shield = true
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddFear(EntityRef(ply), 180)
    end
  end
end

function mirror_force:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(dmg_amount > 0) then
    if(shield) then
      if(not ply:HasEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)) then
        ply:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
        ply:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, true, false, false, false)
      elseif(not timer.Exists("invuln_timer2")) then
        timer.Create("invuln_timer2", 0.35, 1, function()
          ply:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
          shield = false
        end)
        timer.Start("invuln_timer2")
      end
      return false
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mirror_force.Init)
locou:AddCallback(ModCallbacks.MC_USE_CARD, mirror_force.Use_Card, MirrorForce.ID)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mirror_force.OnDamageTaken, EntityType.ENTITY_PLAYER)
