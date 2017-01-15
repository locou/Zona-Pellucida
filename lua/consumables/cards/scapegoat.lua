local scapegoat = {}
local game = Game()

local Scapegoat = {
  ID = Isaac.GetCardIdByName("07_Scapegoat")
}

table.insert(locou.Items.Cards.Yugi, Scapegoat)

local shield = 0
function scapegoat:Init()
  shield = 0
end

function scapegoat:Use_Card(card)
  if(card == Scapegoat.ID) then
    local ply = game:GetPlayer(0)
    shield = 4
  end
end

function scapegoat:OnDamageTaken(dmg_target, dmg_amount, dmg_flags, dmg_source, dmg_frames)
  local ply = game:GetPlayer(0)
  if(shield > 0 and dmg_target.Type == EntityType.ENTITY_PLAYER and dmg_amount > 0 and ply.Position:Distance(dmg_source.Position) < 16) then
    shield = shield - 1
    return false
  end
end

locou:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, scapegoat.Init)
locou:AddCallback(ModCallbacks.MC_USE_CARD, scapegoat.Use_Card, Scapegoat.ID)
locou:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, scapegoat.OnDamageTaken, EntityType.ENTITY_PLAYER)
