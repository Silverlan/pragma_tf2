util.register_class("ents.tf2.AmmoPack", BaseEntityComponent)
local Component = ents.tf2.AmmoPack

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	self:AddEntityComponent("tf2_item_pickup")
	self:SetRestoreAmount(1.0)
end

function Component:SetRestoreAmount(am)
	self.m_restoreAmount = am
end
ents.tf2.COMPONENT_AMMOPACK = ents.register_component("tf2_ammopack", Component, "tf2")
