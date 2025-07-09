-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

include("../shared.lua")
local Component = ents.tf2.CarryItem

function Component:Drop()
	local ownableC = self:GetEntity():GetComponent(ents.COMPONENT_OWNABLE)
	if(ownableC ~= nil) then ownableC:SetOwner() end
end
