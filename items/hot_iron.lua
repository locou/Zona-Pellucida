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
        return false
      end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, hot_iron.OnDamageTaken, EntityType.ENTITY_PLAYER)