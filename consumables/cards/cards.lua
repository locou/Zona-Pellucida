--This is not an item, this only handles the card backs.

local cards = {}

function cards:UpdateBacks()
  local dropped_cards = locou:GetEntitiesByVariant(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD)
  for _,v in pairs(dropped_cards) do
    for _,x in pairs(locou.Items.Cards.Yugi) do
      if(x.ID == v.SubType and v.FrameCount <= 0) then
        local sprite = v:GetSprite()
        local animation = "Idle"
        if(sprite:IsPlaying("Appear")) then
          animation = "Appear"
        elseif(sprite:IsPlaying("Collect")) then
          animation = "Collect"
        end
        sprite:Load("gfx/pick ups/yugi card.anm2", true)
        sprite:Play(animation, true)
      end
    end

    for _,x in pairs(locou.Items.Cards.Poke) do
      if(x.ID == v.SubType and v.FrameCount <= 0) then
        local sprite = v:GetSprite()
        local animation = "Idle"
        if(sprite:IsPlaying("Appear")) then
          animation = "Appear"
        elseif(sprite:IsPlaying("Collect")) then
          animation = "Collect"
        end
        sprite:Load("gfx/pick ups/poke card.anm2", true)
        sprite:Play(animation, true)
      end
    end
  end
end

locou:AddCallback(ModCallbacks.MC_POST_RENDER, cards.UpdateBacks)
