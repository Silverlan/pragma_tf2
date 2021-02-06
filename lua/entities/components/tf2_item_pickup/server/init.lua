include("../shared.lua")
local Component = ents.tf2.ItemPickup

--[[function Component:OnEntitySpawn()
	local ent = self:GetEntity()
	local touchComponent = ent:GetComponent(ents.COMPONENT_TOUCH)
	if(touchComponent ~= nil) then
		touchComponent:SetTriggerFlags(ents.TouchComponent.TRIGGER_FLAG_BIT_PLAYERS)
	end
	if(SERVER == true) then
		local physComponent = ent:GetPhysicsComponent()
		if(physComponent ~= nil) then physComponent:InitializePhysics(phys.TYPE_STATIC) end
	end]
end
]]
function Component:CanTrigger(ent,physObj)
	return util.EVENT_REPLY_HANDLED,ent:IsPlayer()
end

function Component:OnStartTouch()
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
