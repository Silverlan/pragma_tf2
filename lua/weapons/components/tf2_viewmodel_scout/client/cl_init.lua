-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.ViewModelScout", BaseEntityComponent)
local Component = ents.tf2.ViewModelScout

function Component:__init()
	BaseEntityComponent.__init(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:AddEntityComponent("tf2_viewmodel")
end

function Component:OnEntitySpawn()
	self:GetEntity():SetModel("weapons/c_models/c_scout_arms")
end
ents.tf2.COMPONENT_VIEWMODEL_SCOUT = ents.register_component("tf2_viewmodel_scout", Component, "tf2")
