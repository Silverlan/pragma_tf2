util.register_class("ents.tf2.HealthkitMedium", BaseEntityComponent)
local Component = ents.tf2.HealthkitMedium

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if pickupC ~= nil then
		pickupC:SetModel("items/medkit_medium")
	end
	if SERVER then
		local healthkitC = self:AddEntityComponent("tf2_healthkit")
		if healthkitC ~= nil then
			healthkitC:SetRestoreAmount(0.5)
		end
	end
end
ents.tf2.COMPONENT_HEALTHKIT_MEDIUM = ents.register_component("tf2_healthkit_medium", Component, "tf2/items/healthkit")
