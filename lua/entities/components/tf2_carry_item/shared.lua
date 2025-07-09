-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.CarryItem", BaseEntityComponent)
local Component = ents.tf2.CarryItem

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
end
ents.tf2.COMPONENT_CARRY_ITEM = ents.register_component("tf2_carry_item", Component, "tf2")
