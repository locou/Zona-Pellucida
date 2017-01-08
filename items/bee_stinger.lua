local bee_stinger = {}
local game = Game()

local BeeStinger = {
  ID = Isaac.GetTrinketIdByName( "Bee Stinger" ),
}

table.insert(locou.Items.Trinkets, BeeStinger)

local trigger_items = {
    CollectibleType.COLLECTIBLE_HABIT,
    CollectibleType.COLLECTIBLE_PIGGY_BANK,
    CollectibleType.COLLECTIBLE_VIRGO,
    CollectibleType.COLLECTIBLE_ATHAME,
    CollectibleType.COLLECTIBLE_VARICOSE_VEINS,
    CollectibleType.COLLECTIBLE_TONSIL
}

local trigger_trinkets = {
  TrinketType.TRINKET_MYSTERIOUS_PAPER,
  TrinketType.TRINKET_UMBILICAL_CORD,
  TrinketType.TRINKET_WISH_BONE,
  TrinketType.TRINKET_BAG_LUNCH,
  TrinketType.TRINKET_WALNUT
}

function bee_stinger:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(ply:HasTrinket(BeeStinger.ID) and dmg_flags ~= DamageFlag.DAMAGE_FAKE) then
    timer.Simple(2.0, function()
      ply:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(ply), 0)
      ply:GetSprite():Stop()
    end)
    if(ply:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
      timer.Simple(2.1, function()
        ply:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(ply), 0)
        ply:GetSprite():Stop()
      end)
    end
  end
end

locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, bee_stinger.OnDamageTaken, EntityType.ENTITY_PLAYER)