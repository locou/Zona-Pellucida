local pocket_sand = {}
local game = Game()

local PocketSand = {
  ID = Isaac.GetItemIdByName( "Pocket Sand" ),
}

table.insert(locou.Items.Actives, PocketSand)

function pocket_sand:Use_Item(id, rng)
  local ply = game:GetPlayer(0)
  if(id == PocketSand.ID) then
    local enemies = locou:GetEnemies()
    for _,v in pairs(enemies) do
      v:AddConfusion(EntityRef(ply), 150, true)
    end
    return true
  end
end

locou:AddCallback(ModCallbacks.MC_USE_ITEM, pocket_sand.Use_Item, pocket_sand.ID)