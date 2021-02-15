util.register_class("ents.tf2.GmMedieval",BaseEntityComponent)
local Component = ents.tf2.GmMedieval

function Component:__init()
	BaseEntityComponent.Initialize(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:AddEntityComponent("gm_tf2")
end
ents.tf2.COMPONENT_GM_MEDIEVAL = ents.register_component("gm_tf2_medieval",Component)
