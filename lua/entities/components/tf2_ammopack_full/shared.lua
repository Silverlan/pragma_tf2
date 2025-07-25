-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.AmmoPackFull", BaseEntityComponent)
local Component = ents.tf2.AmmoPackFull

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if pickupC ~= nil then
		pickupC:SetModel("items/ammopack_large")
	end
	if SERVER then
		local ammoPackC = self:AddEntityComponent("tf2_ammopack")
		if ammoPackC ~= nil then
			ammoPackC:SetRestoreAmount(1.0)
		end
	end
end
ents.tf2.COMPONENT_AMMOPACK_FULL = ents.register_component("tf2_ammopack_full", Component, "tf2/ammo")
