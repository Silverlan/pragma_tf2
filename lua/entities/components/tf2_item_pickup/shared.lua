util.register_class("ents.tf2.ItemPickup",BaseEntityComponent)
local Component = ents.tf2.ItemPickup

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	self:AddEntityComponent(ents.COMPONENT_TRANSFORM)
	self:AddEntityComponent(ents.COMPONENT_MODEL)
	if(CLIENT) then
		self:AddEntityComponent(ents.COMPONENT_RENDER)
		self:AddEntityComponent(ents.COMPONENT_ANIMATED)
		self:BindEvent(ents.AnimatedComponent.EVENT_ON_ANIMATION_RESET,function() self:ResetAnimation() end)
	else
		self:AddEntityComponent(ents.COMPONENT_PHYSICS)
		self:AddEntityComponent(ents.COMPONENT_TOUCH)

		self:BindEvent(ents.PhysicsComponent.EVENT_ON_PHYSICS_INITIALIZED,"OnPhysicsInitialized")
		self:BindEvent(ents.TouchComponent.EVENT_ON_START_TOUCH,"OnStartTouch")
		self:BindEvent(ents.TouchComponent.EVENT_CAN_TRIGGER,"CanTrigger")
	end
	self:SetTickPolicy(ents.TICK_POLICY_ALWAYS)
end
function Component:SetModel(mdl)
	self.m_itemModel = mdl
end
function Component:OnTick()

end
function Component:OnEntitySpawn()
	if((SERVER or self:GetEntity():IsClientsideOnly()) and self.m_itemModel ~= nil) then
		self:GetEntity():SetModel(self.m_itemModel)
	end
	if(CLIENT) then self:ResetAnimation() end
end
ents.tf2.COMPONENT_ITEM_PICKUP = ents.register_component("tf2_item_pickup",Component)
