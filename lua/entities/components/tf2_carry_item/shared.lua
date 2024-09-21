util.register_class("ents.tf2.CarryItem", BaseEntityComponent)
local Component = ents.tf2.CarryItem

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
end
ents.register_component("tf2_carry_item", Component, "tf2")
