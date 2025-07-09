-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

include("../shared.lua")
local Component = ents.tf2.ItemPickup

function Component:CanTrigger(ent,physObj)
	return util.EVENT_REPLY_HANDLED,ent:IsPlayer()
end

function Component:OnStartTouch(ent)
	self:BroadcastEvent(Component.EVENT_ON_PICKED_UP,{ent})
	--[[if(self.m_state ~= STATE_READY_FOR_USE) then return end
	local ent = self:FindAssociatedModelEntity()
	if(ent == nil) then return end
	ent:PlayAnimation("open")
	ent:EmitSound("items/regenerate",sound.TYPE_EFFECT) -- Regenerate.Touch ?
	self.m_state = STATE_IN_USE
	self.m_nextUseTime = time.cur_time() +NEXT_USE_TIME

	local logicC = self:GetEntity():GetComponent(ents.COMPONENT_LOGIC)
	if(logicC ~= nil) then
		logicC:SetTickPolicy(ents.TICK_POLICY_ALWAYS)
		logicC:SetNextTick(self.m_nextUseTime -1.0)
	end]]
end

function Component:OnPhysicsInitialized(physObj)
	local physComponent = self:GetEntity():GetComponent(ents.COMPONENT_PHYSICS)
	if(physComponent == nil) then return end
	physComponent:SetCollisionFilterMask(phys.COLLISIONMASK_PLAYER)
	physComponent:SetCollisionFilterGroup(phys.COLLISIONMASK_TRIGGER)
	physComponent:SetCollisionCallbacksEnabled(true)
end
