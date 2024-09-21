util.register_class("ents.tf2.GmCtf", BaseEntityComponent)
local Component = ents.tf2.GmCtf

function Component:__init()
	BaseEntityComponent.Initialize(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:AddEntityComponent("gm_tf2")
end
ents.register_component("gm_tf2_ctf", Component, "tf2")
