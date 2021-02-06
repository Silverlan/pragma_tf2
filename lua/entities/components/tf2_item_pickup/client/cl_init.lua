include("../shared.lua")

function ents.tf2.ItemPickup:ResetAnimation()
	self:GetEntity():PlayAnimation("idle")
end
