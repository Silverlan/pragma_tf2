util.register_class("ents.tf2.ItemPickup", BaseEntityComponent)
local Component = ents.tf2.ItemPickup

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	self:AddEntityComponent(ents.COMPONENT_TRANSFORM)
	self:AddEntityComponent(ents.COMPONENT_MODEL)
	if CLIENT then
		self:AddEntityComponent(ents.COMPONENT_RENDER)
		self:AddEntityComponent(ents.COMPONENT_ANIMATED)
		self:BindEvent(ents.AnimatedComponent.EVENT_ON_ANIMATION_RESET, function()
			self:ResetAnimation()
		end)
	else
		self:AddEntityComponent(ents.COMPONENT_PHYSICS)
		self:AddEntityComponent(ents.COMPONENT_TOUCH)

		self:BindEvent(ents.PhysicsComponent.EVENT_ON_PHYSICS_INITIALIZED, "OnPhysicsInitialized")
		self:BindEvent(ents.TouchComponent.EVENT_ON_START_TOUCH, "OnStartTouch")
		self:BindEvent(ents.TouchComponent.EVENT_CAN_TRIGGER, "CanTrigger")
	end
end
function Component:SetModel(mdl)
	self.m_itemModel = mdl
end
function Component:OnEntitySpawn()
	if (SERVER or self:GetEntity():IsClientsideOnly()) and self.m_itemModel ~= nil then
		self:GetEntity():SetModel(self.m_itemModel)

		local ent = self:GetEntity()
		local touchComponent = ent:GetComponent(ents.COMPONENT_TOUCH)
		if touchComponent ~= nil then
			touchComponent:SetTriggerFlags(ents.TouchComponent.TRIGGER_FLAG_BIT_PLAYERS)
		end
		local physComponent = ent:GetPhysicsComponent()
		if physComponent ~= nil then
			physComponent:InitializePhysics(phys.TYPE_STATIC)
		end
	end
	if CLIENT then
		self:ResetAnimation()
	end
end
ents.tf2.COMPONENT_ITEM_PICKUP = ents.register_component("tf2_item_pickup", Component, "tf2")
Component.EVENT_ON_PICKED_UP = ents.register_component_event(ents.tf2.COMPONENT_ITEM_PICKUP, "on_picked_up")
