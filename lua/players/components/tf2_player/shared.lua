util.register_class("ents.tf2.Player",BaseEntityComponent)
local Component = ents.tf2.Player

Component:RegisterMember("DefaultForwardMovementSpeedFactor",util.VAR_TYPE_FLOAT,1.0,ents.BaseEntityComponent.MEMBER_FLAG_DEFAULT_TRANSMIT,1)
Component:RegisterMember("DefaultBackwardMovementSpeedFactor",util.VAR_TYPE_FLOAT,0.9,ents.BaseEntityComponent.MEMBER_FLAG_DEFAULT_TRANSMIT,1)
Component:RegisterMember("DefaultCrouchedMovementSpeedFactor",util.VAR_TYPE_FLOAT,0.33,ents.BaseEntityComponent.MEMBER_FLAG_DEFAULT_TRANSMIT,1)
Component:RegisterMember("DefaultJumpHeight",util.VAR_TYPE_FLOAT,72.0,ents.BaseEntityComponent.MEMBER_FLAG_DEFAULT_TRANSMIT,1)

local TF2_ACTIVITIES = {
	[game.Model.Animation.ACT_WALK] = game.Model.Animation.ACT_MP_RUN_MELEE,
	[game.Model.Animation.ACT_RUN] = game.Model.Animation.ACT_MP_RUN_MELEE,
	[game.Model.Animation.ACT_IDLE] = game.Model.Animation.ACT_MP_STAND_MELEE,
	[game.Model.Animation.ACT_CROUCH_IDLE] = game.Model.Animation.ACT_MP_CROUCH_MELEE,
	[game.Model.Animation.ACT_CROUCH_WALK] = game.Model.Animation.ACT_MP_CROUCHWALK_MELEE
}

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:AddEntityComponent(ents.COMPONENT_DAMAGEABLE)
	self:AddEntityComponent(ents.COMPONENT_RENDER)
	self:AddEntityComponent(ents.COMPONENT_ANIMATED)
	self:AddEntityComponent(ents.COMPONENT_MODEL)
	self:AddEntityComponent(ents.COMPONENT_PHYSICS)
	self:AddEntityComponent(ents.COMPONENT_CHARACTER)

	self.m_class = tf2.PLAYER_CLASS_INVALID

	self:BindEvent(ents.AnimatedComponent.EVENT_TRANSLATE_ACTIVITY,"TranslateActivity")
	self:BindEvent(ents.CharacterComponent.EVENT_ON_RESPAWN,"OnRespawn")
end

function Component:UpdateMovementSpeed()
	local plC = self:GetEntityComponent(ents.COMPONENT_PLAYER)
	if(plC == nil) then return end
	local baselineSpeed = 300.0
	-- TODO: Implement backward movement speed
	plC:SetWalkSpeed(self:GetDefaultForwardMovementSpeedFactor() *baselineSpeed)
	plC:SetRunSpeed(self:GetDefaultForwardMovementSpeedFactor() *baselineSpeed)
	plC:SetSprintSpeed(self:GetDefaultForwardMovementSpeedFactor() *baselineSpeed)
	plC:SetCrouchedWalkSpeed(self:GetDefaultCrouchedMovementSpeedFactor() *baselineSpeed)
	local charComponent = self:GetEntityComponent(ents.COMPONENT_CHARACTER)
	if(charComponent ~= nil) then charComponent:SetJumpPower(self:GetDefaultJumpHeight()) end
end

function Component:TranslateActivity(act)
	if(TF2_ACTIVITIES[act] == nil) then return end
	return util.EVENT_REPLY_HANDLED,TF2_ACTIVITIES[act]
end

function Component:InitializeDefaultPlayerDimensions(plC)
	plC:SetStandHeight(83.0)
	plC:SetCrouchHeight(63.0)
	self:SetDefaultJumpHeight(72.0)
	self:BroadcastEvent(Component.EVENT_APPLY_CHARACTER_DIMENSIONS,{plC})

	self:UpdateMovementSpeed()
end

function Component:InitializePlayer(plC)
	local ent = plC:GetEntity()
	local charComponent = ent:AddComponent(ents.COMPONENT_CHARACTER)
	if(charComponent ~= nil) then
		charComponent:AddEventCallback(ents.CharacterComponent.EVENT_PLAY_FOOTSTEP_SOUND,function(footType,surfMat,intensity)
			local sndComponent = charComponent:GetEntity():GetComponent(ents.COMPONENT_SOUND_EMITTER)
			if(sndComponent == nil) then return end
			local maxGain = 0.5
			sndComponent:EmitSound(surfMat:GetFootstepSound(),bit.bor(sound.TYPE_EFFECT,sound.TYPE_PLAYER),maxGain *intensity,1.0,false)
		end)
	end
	self:InitializeDefaultPlayerDimensions(plC)
	if(charComponent ~= nil) then charComponent:SetMoveController("move_x","move_y") end
	self:BroadcastEvent(Component.EVENT_APPLY_CHARACTER_MODEL,{plC})

	self:UpdatePhysics()
end

function Component:ChangeClass(class)
	if(class == self.m_class) then return end
	self:ClearClass()
	self:AddEntityComponent(tf2.player_class_to_identifier(class))
	self.m_class = class

	if(SERVER) then
		local p = net.Packet()
		p:WriteUInt32(class)
		self:SendNetEvent(net.PROTOCOL_SLOW_RELIABLE,Component.NET_EVENT_CHANGE_CLASS,p)
	end

	local plC = self:GetEntityComponent(ents.COMPONENT_PLAYER)
	if(plC ~= nil) then self:InitializePlayer(plC) end

	if(SERVER) then
		local charC = self:GetEntityComponent(ents.COMPONENT_CHARACTER)
		if(charC ~= nil) then
			charC:RemoveWeapons()
			self:BroadcastEvent(Component.EVENT_APPLY_CHARACTER_LOADOUT,{charC})
		end
	end
end

function Component:UpdatePhysics()
	local ent = self:GetEntity()
	local pl = ent:GetComponent(ents.COMPONENT_PLAYER)
	if(pl == nil) then return end
	local physComponent = ent:GetComponent(ents.COMPONENT_PHYSICS)
	if(physComponent ~= nil) then
		physComponent:SetCollisionBounds(Vector(-16,0,-16),Vector(16,pl:GetStandHeight(),16))
		physComponent:InitializePhysics(phys.TYPE_CAPSULECONTROLLER)
	end
end

function Component:ClearClass()
	if(self.m_class ~= tf2.PLAYER_CLASS_INVALID) then self:GetEntity():RemoveComponent(tf2.player_class_to_identifier(self.m_class)) end
	if(CLIENT) then self:ResetViewModel() end
end

function Component:GetClass() return self.m_class end

function Component:OnEntitySpawn()
	if(CLIENT) then
		local renderC = self:GetEntity():GetComponent(ents.COMPONENT_RENDER)
		-- Fixes a bug that causes the player to become partially invisible depending on the camera angle.
		-- TODO: This is a workaround, fix the underlying cause!
		if(renderC ~= nil) then renderC:SetExemptFromOcclusionCulling(true) end
	end
	self:OnRespawn()
end

function Component:OnRespawn()
	local ent = self:GetEntity()
	local pl = ent:GetComponent(ents.COMPONENT_PLAYER)
	if(pl == nil) then return end
	local healthComponent = ent:GetComponent(ents.COMPONENT_HEALTH)
	if(healthComponent ~= nil) then healthComponent:SetMaxHealth(100) end
	
	if(SERVER == true) then
		if(healthComponent ~= nil) then healthComponent:SetHealth(100) end
	end

	self:UpdatePhysics()
	if(pl ~= nil) then pl:SetObserverMode(ents.PlayerComponent.OBSERVERMODE_THIRDPERSON) end
end
ents.tf2.COMPONENT_PLAYER = ents.register_component("tf2_player",Component,ents.EntityComponent.FREGISTER_BIT_NETWORKED)
Component.NET_EVENT_CHANGE_CLASS = ents.register_component_net_event(ents.tf2.COMPONENT_PLAYER,"change_class")
Component.EVENT_APPLY_CHARACTER_DIMENSIONS = ents.register_component_event(ents.tf2.COMPONENT_PLAYER,"apply_character_dimensions")
Component.EVENT_APPLY_CHARACTER_MODEL = ents.register_component_event(ents.tf2.COMPONENT_PLAYER,"apply_character_model")
Component.EVENT_APPLY_CHARACTER_LOADOUT = ents.register_component_event(ents.tf2.COMPONENT_PLAYER,"apply_character_loadout")
