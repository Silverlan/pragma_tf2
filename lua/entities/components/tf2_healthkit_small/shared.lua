-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.HealthkitSmall", BaseEntityComponent)
local Component = ents.tf2.HealthkitSmall

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if pickupC ~= nil then
		pickupC:SetModel("items/medkit_small")
	end
	if SERVER then
		local healthkitC = self:AddEntityComponent("tf2_healthkit")
		if healthkitC ~= nil then
			healthkitC:SetRestoreAmount(0.205)
		end
	end
end
ents.tf2.COMPONENT_HEALTHKIT_SMALL = ents.register_component("tf2_healthkit_small", Component, "tf2/items/healthkit")
