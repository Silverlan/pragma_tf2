-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

local Component = ents.tf2.WeaponBat
Component.ReloadDelay = 1.0

function Component:InitializeReload()
	--[[self:BindEvent(ents.WeaponComponent.EVENT_ON_RELOAD,"OnReload")
	self:BindEvent(ents.WeaponComponent.EVENT_ON_DEPLOY,"OnDeploy")
	self:SetTickPolicy(ents.TICK_POLICY_ALWAYS)]]
end

function Component:OnDeploy()
	--self.m_bReloading = false
end

function Component:OnReload()
	--[[local ent = self:GetEntity()
	local wepComponent = ent:GetComponent(ents.COMPONENT_WEAPON)
	local ownableComponent = ent:GetComponent(ents.COMPONENT_OWNABLE)
	if(wepComponent == nil or ownableComponent == nil or self:IsReloading() or wepComponent:GetPrimaryClipSize() == wepComponent:GetMaxPrimaryClipSize()) then return end
	local owner = ownableComponent:GetOwner()
	local charComponent = (owner ~= nil) and owner:GetComponent(ents.COMPONENT_CHARACTER) or nil
	if(charComponent ~= nil and charComponent:GetAmmoCount(wepComponent:GetPrimaryAmmoType()) == 0) then return end
	if(CLIENT == true) then
		local sndEmitterComponent = ent:GetComponent(ents.COMPONENT_SOUND_EMITTER)
		if(sndEmitterComponent ~= nil) then
			sndEmitterComponent:EmitSound("weapon_smg1.reload",sound.TYPE_WEAPON,1.0,1.0)
		end
		wepComponent:PlayViewActivity(Animation.ACT_VM_RELOAD)
	end
	self.m_bReloading = true
	self.m_tReload = time.cur_time() +self.ReloadDelay]]
end

function Component:IsReloading() return self.m_bReloading end

function Component:OnTick()
	--if(self:IsDeployed() == false) then return end
	--[[local ent = self:GetEntity()
	local wepComponent = ent:GetComponent(ents.COMPONENT_WEAPON)
	if(wepComponent == nil) then return end
	if(self:IsReloading() == true and time.cur_time() >= self.m_tReload) then
		if(SERVER) then wepComponent:RefillPrimaryClip() end
		self.m_bReloading = false
	end]]
end
