-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.WeaponBat", BaseEntityComponent)
local Component = ents.tf2.WeaponBat

include("sh_primary_attack.lua")
include("sh_secondary_attack.lua")
include("sh_reload.lua")

-- game.load_sound_scripts("fx_weapon_smg1.txt",true)

Component.ViewModel = "weapons/c_models/c_scout_arms"
Component.WorldModel = "weapons/w_models/w_bat"
Component.ViewFOV = 50
Component.AttackDelay = 0.6

function Component:__init()
	BaseEntityComponent.__init(self)
end

function Component:Initialize()
	local ent = self:GetEntity()

	self:AddEntityComponent(ents.COMPONENT_WEAPON, "InitializeWeapon")
	self:AddEntityComponent(ents.COMPONENT_MODEL, "InitializeModel")
	self:AddEntityComponent(ents.COMPONENT_OWNABLE)
	if CLIENT == true then
		self:AddEntityComponent(ents.COMPONENT_SOUND_EMITTER)
		self:BindEvent(ents.WeaponComponent.EVENT_ATTACH_TO_OWNER, "AttachToOwner")
	end
	if SERVER == true then
		self:BindEvent(ents.OwnableComponent.EVENT_ON_OWNER_CHANGED, "OnOwnerChanged")
	end
	self:BindEvent(ents.WeaponComponent.EVENT_ON_PRIMARY_ATTACK, "OnPrimaryAttack")

	self:InitializePrimaryAttack()
	self:InitializeSecondaryAttack()
	self:InitializeReload()
end

function Component:OnPrimaryAttack()
	local ent = self:GetEntity()
	local wepC = ent:GetComponent(ents.COMPONENT_WEAPON)
	if wepC == nil then
		return
	end

	if CLIENT == true then
		local sndEmitterComponent = ent:GetComponent(ents.COMPONENT_SOUND_EMITTER)
		if sndEmitterComponent ~= nil then
			sndEmitterComponent:EmitSound(
				"weapons/bat_baseball_hit_world1.wav",
				sound.TYPE_WEAPON,
				ents.SoundEmitterComponent.SoundInfo(1.0, 1.0)
			) -- TODO: Use sound script
		end
		wepC:PlayViewActivity(Animation.ACT_MELEE_VM_HITCENTER, ents.AnimatedComponent.FPLAYANIM_RESET)
	end

	local owner = ent:GetOwner()
	local animC = (owner ~= nil) and owner:GetComponent(ents.COMPONENT_ANIMATED) or nil
	if animC ~= nil then
		animC:PlayLayeredAnimation(0, "layer_melee_swing")
	end

	wepC:SetNextAttack(time.cur_time() + self.AttackDelay)
end

function Component:AttachToOwner(owner, vm)
	local ent = vm and vm:GetEntity() or owner
	local attC = self:AddEntityComponent(ents.COMPONENT_ATTACHMENT)
	if attC == nil then
		return util.EVENT_REPLY_UNHANDLED
	end
	local attInfo = ents.AttachmentComponent.AttachmentInfo()
	attInfo:SetRotation(EulerAngles(0, 90, 0):ToQuaternion())
	attInfo.flags = bit.bor(
		attInfo.flags,
		ents.AttachmentComponent.FATTACHMENT_MODE_SNAP_TO_ORIGIN,
		ents.AttachmentComponent.FATTACHMENT_MODE_UPDATE_EACH_FRAME,
		ents.AttachmentComponent.FATTACHMENT_MODE_FORCE_IN_PLACE
	)
	attC:AttachToAttachment(ent, "weapon_bone", attInfo)
	return util.EVENT_REPLY_HANDLED
end

function Component:InitializeModel(component)
	component:SetModel(self.WorldModel)
end

function Component:InitializeWeapon(component)
	if CLIENT == true then
		-- component:SetViewModel(self.ViewModel)
		-- component:SetViewFOV(self.ViewFOV)
	end
	component:SetAutomaticPrimary(self.Primary.Automatic)
	component:SetAutomaticSecondary(self.Secondary.Automatic)

	if SERVER == true then
		component:SetPrimaryAmmoType(self.Primary.AmmoType)
		component:SetMaxPrimaryClipSize(self.Primary.MaxClipSize)

		component:SetSecondaryAmmoType(self.Secondary.AmmoType)
	end
end
ents.tf2.COMPONENT_WEAPON_BAT = ents.register_component("tf2_weapon_bat", Component, "tf2")
