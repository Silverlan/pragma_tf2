util.register_class("ents.tf2.PlayerScout", BaseEntityComponent)
local Component = ents.tf2.PlayerScout

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	local plC = self:AddEntityComponent("tf2_player")
	if CLIENT then
		if plC ~= nil then
			plC:SetViewModelComponent("tf2_viewmodel_scout")
		end
	end

	self:BindEvent(ents.tf2.Player.EVENT_APPLY_CHARACTER_DIMENSIONS, "ApplyDimensions")
	self:BindEvent(ents.tf2.Player.EVENT_APPLY_CHARACTER_MODEL, "ApplyModel")
	if SERVER then
		self:BindEvent(ents.tf2.Player.EVENT_APPLY_CHARACTER_LOADOUT, "ApplyLoadout")
	end
end
function Component:ApplyDimensions(plC)
	plC:SetStandEyeLevel(65.0)
	plC:SetCrouchEyeLevel(28.0) -- TODO: This is (probably) not the right value

	local plTfC = self:GetEntityComponent(ents.tf2.COMPONENT_PLAYER)
	if plTfC ~= nil then
		plTfC:SetDefaultForwardMovementSpeedFactor(1.33333333333333)
		plTfC:SetDefaultBackwardMovementSpeedFactor(1.2)
		plTfC:SetDefaultCrouchedMovementSpeedFactor(0.44)
	end
end
function Component:ApplyModel()
	local ent = self:GetEntity()
	local mdlComponent = ent:GetComponent(ents.COMPONENT_MODEL)
	if CLIENT == true then
		local vb = ents.get_view_body()
		if vb ~= nil then
			local mdlComponent = vb:GetModelComponent()
			if mdlComponent ~= nil then
				mdlComponent:SetModel("player/soldier_legs.wmd")
			end
		end
		return
	end
	if mdlComponent ~= nil then
		mdlComponent:SetModel("player/scout")
	end
end
ents.register_component("tf2_player_scout", Component, "tf2")
