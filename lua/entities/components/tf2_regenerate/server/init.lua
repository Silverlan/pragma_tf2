util.register_class("ents.tf2.Regenerate",BaseEntityComponent)
local Component = ents.tf2.Regenerate
local NEXT_USE_TIME = 3.0

local STATE_READY_FOR_USE = 0
local STATE_IN_USE = 1
local STATE_CLOSING = 2
function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	self:AddEntityComponent(ents.COMPONENT_MODEL)
	self:AddEntityComponent(ents.COMPONENT_PHYSICS)
	self:AddEntityComponent(ents.COMPONENT_IO)
	self:AddEntityComponent(ents.COMPONENT_TOUCH)

	self:BindEvent(ents.PhysicsComponent.EVENT_ON_PHYSICS_INITIALIZED,"OnPhysicsInitialized")
	self:BindEvent(ents.TouchComponent.EVENT_ON_START_TOUCH,"OnStartTouch")
	self:BindEvent(ents.TouchComponent.EVENT_CAN_TRIGGER,"CanTrigger")
	self:BindEvent(ents.Entity.EVENT_HANDLE_KEY_VALUE,"HandleKeyValue")

	self:SetTickPolicy(ents.TICK_POLICY_NEVER)
	self.m_state = STATE_READY_FOR_USE
end

function Component:OnTick()
	local t = time.cur_time()
	if(self.m_state == STATE_IN_USE) then
		if(t >= self.m_nextUseTime -1.0) then
			self.m_state = STATE_CLOSING
			local ent = self:FindAssociatedModelEntity()
			if(ent ~= nil) then ent:PlayAnimation("close") end
		end
	elseif(t >= self.m_nextUseTime) then
		self.m_state = STATE_READY_FOR_USE

		self:SetTickPolicy(ents.TICK_POLICY_NEVER)

		local touchC = self:GetEntity():GetComponent(ents.COMPONENT_TOUCH)
		if(touchC ~= nil and touchC:GetTouchingEntityCount() > 0) then
			-- Someone is still in the trigger area, regenerate immediately!
			self:OnStartTouch()
		end
	end
end

function Component:HandleKeyValue(key,val)
	if(key == "associatedmodel") then self.m_associatedModel = val
	else return util.EVENT_REPLY_UNHANDLED end
	return util.EVENT_REPLY_HANDLED
end

function Component:CanTrigger(ent,physObj)
	return util.EVENT_REPLY_HANDLED,ent:IsPlayer()
end

function Component:OnStartTouch()
	if(self.m_state ~= STATE_READY_FOR_USE) then return end
	local ent = self:FindAssociatedModelEntity()
	if(ent == nil) then return end
	ent:PlayAnimation("open")
	ent:EmitSound("items/regenerate",sound.TYPE_EFFECT) -- TODO: Use Regenerate.Touch soundscript
	self.m_state = STATE_IN_USE
	self.m_nextUseTime = time.cur_time() +NEXT_USE_TIME

	self:SetTickPolicy(ents.TICK_POLICY_ALWAYS)
	self:SetNextTick(self.m_nextUseTime -1.0)
end

function Component:FindAssociatedModelEntity()
	return (self.m_associatedModel ~= nil) and ents.iterator({ents.IteratorFilterName(self.m_associatedModel)})() or nil
end

function Component:OnPhysicsInitialized(physObj)
	local physComponent = self:GetEntity():GetComponent(ents.COMPONENT_PHYSICS)
	if(physComponent == nil) then return end
	physComponent:SetCollisionFilterMask(phys.COLLISIONMASK_PLAYER)
	physComponent:SetCollisionFilterGroup(phys.COLLISIONMASK_TRIGGER)
	physComponent:SetCollisionCallbacksEnabled(true)
end

function Component:OnEntitySpawn()
	local ent = self:GetEntity()
	local touchComponent = ent:GetComponent(ents.COMPONENT_TOUCH)
	if(touchComponent ~= nil) then
		touchComponent:SetTriggerFlags(ents.TouchComponent.TRIGGER_FLAG_BIT_PLAYERS)
	end
	local physComponent = ent:GetPhysicsComponent()
	if(physComponent ~= nil) then physComponent:InitializePhysics(phys.TYPE_STATIC) end
end
ents.tf2.COMPONENT_REGENERATE = ents.register_component("tf2_regenerate",Component)
