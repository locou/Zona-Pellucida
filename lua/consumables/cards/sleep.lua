local sleep = {}
local game = Game()

local Sleep = {
  ID = Isaac.GetCardIdByName("12_Sleep")
}

table.insert(locou.Items.Cards.Poke, Sleep)

function sleep:Use_Card(card)
  if(card == Sleep.ID) then
    local ply = game:GetPlayer(0)
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddEntityFlags(EntityFlag.FLAG_FREEZE)
      v:AddEntityFlags(EntityFlag.FLAG_CONFUSION)
      timer.Create("sleep"..v.Index,5.0,1, function()
        v:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
        v:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
      end)
      timer.Start("sleep"..v.Index)
    end
  end
end

function sleep:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  if(timer.Exists("sleep"..dmg_target.Index) and dmg_target ~= nil and dmg_target:HasEntityFlags(EntityFlag.ENTITY_FREEZE) and dmg_target:HasEntityFlags(EntityFlag.ENTITY_CONFUSE) and dmg_amount > 0) then
    dmg_target:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
    dmg_target:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
    timer.Destroy("sleep"..dmg_target.Index)
  end
end

locou:AddCallback(ModCallbacks.MC_USE_CARD, sleep.Use_Card, Sleep.ID)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, sleep.OnDamageTaken)
