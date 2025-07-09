-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

include("../shared.lua")
local Component = ents.tf2.Player

function Component:DropItem()
	local ent = self:GetEntity()
	for entItem in ents.iterator({ents.IteratorFilterComponent("tf2_carry_item")}) do
		local owner = entItem:GetOwner()
		if(owner == ent) then entItem:GetComponent(ents.tf2.COMPONENT_CARRY_ITEM):Drop() end
	end
end
