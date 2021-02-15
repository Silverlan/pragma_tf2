include("../shared.lua")

function ents.tf2.ItemPickup:SetIdleAnimation(idle) self.m_idleAnim = idle end
function ents.tf2.ItemPickup:ResetAnimation()
	self:GetEntity():PlayAnimation(self.m_idleAnim or "idle")
end
