include("../shared.lua")
local Component = ents.tf2.Teamflag

function Component:OnPickedUp(ent)
	local ownableC = self:GetEntityComponent(ents.COMPONENT_OWNABLE)
	if(ownableC ~= nil and util.is_valid(ownableC:GetOwner())) then return end
	if(ownableC ~= nil) then ownableC:SetOwner(ent) end
end
