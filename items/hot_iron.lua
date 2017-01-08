local hot_iron = {}
local game = Game()

local HotIron = {
  ID = Isaac.GetItemIdByName( "Hot Iron" ),
}

table.insert(locou.Items.Passives, HotIron)

function hot_iron:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(ply:HasCollectible(HotIron.ID)) then
      if(dmg_source.Type == EntityType.ENTITY_FIREPLACE or dmg_flags == DamageFlag.DAMAGE_FIRE) then
        if(not ply:HasEntityFlags(EntityFlag.FLAG_BURN)) then
          ply:AddEntityFlags(EntityFlag.FLAG_BURN)
          local firedelay = ply.FireDelay
          local movespeed = ply.MoveSpeed
          ply.FireDelay = ply.FireDelay - 10
          ply.MoveSpeed = ply.MoveSpeed + 0.5
          timer.Simple(20, function()
            ply:ClearEntityFlags(EntityFlag.FLAG_BURN)
            ply.FireDelay = firedelay
            ply.MoveSpeed = movespeed
          end)
        end
        return false
      end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, hot_iron.OnDamageTaken, EntityType.ENTITY_PLAYER)