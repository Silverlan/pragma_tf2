util.register_class("ents.tf2.AmmoPackSmall", BaseEntityComponent)
local Component = ents.tf2.AmmoPackSmall

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if pickupC ~= nil then
		pickupC:SetModel("items/ammopack_small")
	end
	if SERVER then
		local ammoPackC = self:AddEntityComponent("tf2_ammopack")
		if ammoPackC ~= nil then
			ammoPackC:SetRestoreAmount(0.205)
		end
	end
end
ents.tf2.COMPONENT_AMMOPACK_SMALL = ents.register_component("tf2_ammopack_small", Component, "tf2/ammo")
