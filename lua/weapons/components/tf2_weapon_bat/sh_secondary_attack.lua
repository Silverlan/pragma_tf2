-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

local Component = ents.tf2.WeaponBat
Component.Secondary = {}
Component.Secondary.AmmoType = "smg1_grenade"
Component.Secondary.AttackDelay = 0.4
Component.Secondary.Automatic = true

function Component:InitializeSecondaryAttack()
	-- self:BindEvent(ents.WeaponComponent.EVENT_ON_SECONDARY_ATTACK,"OnSecondaryAttack")
end

function Component:OnSecondaryAttack()
	--[[local ent = self:GetEntity()
	local wepComponent = ent:GetComponent(ents.COMPONENT_WEAPON)
	local ownableComponent = ent:GetComponent(ents.COMPONENT_OWNABLE)
	if(wepComponent == nil or ownableComponent == nil or self:IsReloading() == true) then return end
	local owner = ownableComponent:GetOwner()
	local charComponent = (owner ~= nil) and owner:GetComponent(ents.COMPONENT_CHARACTER) or nil
	if(charComponent ~= nil and charComponent:GetAmmoCount(wepComponent:GetSecondaryAmmoType()) == 0) then
		if(CLIENT == true) then
			local sndEmitterComponent = ent:GetComponent(ents.COMPONENT_SOUND_EMITTER)
			if(sndEmitterComponent ~= nil) then
				sndEmitterComponent:EmitSound("weapon_smg1.empty",sound.TYPE_WEAPON,1.0,1.0)
			end
		end
	else
		if(CLIENT == true) then
			local sndEmitterComponent = ent:GetComponent(ents.COMPONENT_SOUND_EMITTER)
			if(sndEmitterComponent ~= nil) then
				sndEmitterComponent:EmitSound("weapon_smg1.fire_grenade_launcher",sound.TYPE_WEAPON,1.0,1.0)
			end
			wepComponent:PlayViewActivity(Animation.ACT_VM_SECONDARY_ATTACK,ents.AnimatedComponent.FPLAYANIM_RESET)
		else
			if(charComponent ~= nil) then charComponent:RemoveAmmo(wepComponent:GetSecondaryAmmoType(),1) end
			self:FireGrenade()
		end
	end
	wepComponent:SetNextAttack(time.cur_time() +self.Secondary.AttackDelay)]]
end
