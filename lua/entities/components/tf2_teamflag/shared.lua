util.register_class("ents.tf2.Teamflag",BaseEntityComponent)
local Component = ents.tf2.Teamflag

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if(pickupC ~= nil) then pickupC:SetModel("flag/briefcase") end
end
ents.tf2.COMPONENT_TEAMFLAG = ents.register_component("tf2_teamflag",Component)
