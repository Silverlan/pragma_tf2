util.register_class("ents.tf2.HealthkitFull", BaseEntityComponent)
local Component = ents.tf2.HealthkitFull

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if pickupC ~= nil then
		pickupC:SetModel("items/medkit_large")
	end
	if SERVER then
		local healthkitC = self:AddEntityComponent("tf2_healthkit")
		if healthkitC ~= nil then
			healthkitC:SetRestoreAmount(1.0)
		end
	end
end
ents.register_component("tf2_healthkit_full", Component, "tf2")
