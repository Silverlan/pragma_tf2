util.register_class("ents.tf2.LogicMedieval", BaseEntityComponent)
local Component = ents.tf2.LogicMedieval

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
end
ents.tf2.COMPONENT_LOGIC_MEDIEVAL = ents.register_component("tf2_logic_medieval", Component, "tf2")
