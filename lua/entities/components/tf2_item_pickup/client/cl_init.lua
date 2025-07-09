-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

include("../shared.lua")

function ents.tf2.ItemPickup:SetIdleAnimation(idle) self.m_idleAnim = idle end
function ents.tf2.ItemPickup:ResetAnimation()
	self:GetEntity():PlayAnimation(self.m_idleAnim or "idle")
end
