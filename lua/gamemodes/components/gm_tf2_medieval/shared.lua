-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.GmMedieval", BaseEntityComponent)
local Component = ents.tf2.GmMedieval

function Component:__init()
	BaseEntityComponent.Initialize(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:AddEntityComponent("gm_tf2")
end
ents.register_component("gm_tf2_medieval", Component, "tf2")
