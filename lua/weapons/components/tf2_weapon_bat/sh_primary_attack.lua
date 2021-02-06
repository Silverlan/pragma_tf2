local Component = ents.tf2.WeaponBat
Component.Primary = {}
Component.Primary.AmmoType = "smg1"
Component.Primary.MaxClipSize = 45
Component.Primary.AttackDelay = 0.1
Component.Primary.Automatic = true

function Component:InitializePrimaryAttack()
end

function Component:OnPrimaryAttack()
	--[[local ent = self:GetEntity()
	local wepComponent = ent:GetComponent(ents.COMPONENT_WEAPON)
	if(wepComponent == nil) then return end
	if(self:IsReloading() == true) then return end
	if(wepComponent:IsPrimaryClipEmpty() == true) then
		if(CLIENT == true) then
			local sndEmitterComponent = ent:GetComponent(ents.COMPONENT_SOUND_EMITTER)
			if(sndEmitterComponent ~= nil) then
				sndEmitterComponent:EmitSound("weapon_smg1.empty",sound.TYPE_WEAPON,1.0,1.0)
			end
			wepComponent:PlayViewActivity(Animation.ACT_VM_TERTIARY_ATTACK,ents.AnimatedComponent.FPLAYANIM_RESET)
		end
		wepComponent:SetNextAttack(time.cur_time() +self.Primary.AttackDelay)
		return
	end
	local shooterComponent = ent:GetComponent(ents.COMPONENT_SHOOTER)
	if(shooterComponent ~= nil) then
		local ownableComponent = ent:GetComponent(ents.COMPONENT_OWNABLE)
		local owner = (ownableComponent ~= nil) and ownableComponent:GetOwner()
		self.m_bulletInfo.attacker = (owner ~= nil) and owner or ents.get_null()
		self.m_bulletInfo.effectOrigin = self:GetMuzzlePos()
		shooterComponent:FireBullets(self.m_bulletInfo)
	end
	if(CLIENT == true) then
		local sndEmitterComponent = ent:GetComponent(ents.COMPONENT_SOUND_EMITTER)
		if(sndEmitterComponent ~= nil) then
			sndEmitterComponent:EmitSound("weapon_smg1.fire1",sound.TYPE_WEAPON,1.0,1.0)
		end
		wepComponent:PlayViewActivity(Animation.ACT_VM_PRIMARY_ATTACK,ents.AnimatedComponent.FPLAYANIM_RESET)
		self:EjectShell()
	else
		wepComponent:RemovePrimaryClip()
	end
	wepComponent:SetNextAttack(time.cur_time() +self.Primary.AttackDelay)]]
end
