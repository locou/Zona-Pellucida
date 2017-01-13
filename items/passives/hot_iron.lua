local hot_iron = {}
local game = Game()

local HotIron = {
  ID = Isaac.GetItemIdByName( "Hot Iron" )
}

table.insert(locou.Items.Passives, HotIron)

local firedelay = 0
local movespeed = 0

function hot_iron:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(HotIron.ID)) then
      if(dmg_source.Type == EntityType.ENTITY_FIREPLACE) then
        if(not timer.Exists("burn_timer")) then
          firedelay = ply.FireDelay
          movespeed = ply.MoveSpeed
          ply.FireDelay = ply.FireDelay - 10
          ply.MoveSpeed = ply.MoveSpeed + 0.5
          timer.Create("burn_timer", 20, 1, function()
            ply.FireDelay = firedelay
            ply.MoveSpeed = movespeed
          end)
          timer.Start("burn_timer")
        end
        return false
      end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, hot_iron.OnDamageTaken, EntityType.ENTITY_PLAYER)
