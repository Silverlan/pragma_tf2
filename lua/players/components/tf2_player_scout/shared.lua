util.register_class("ents.tf2.PlayerScout",BaseEntityComponent)
local Component = ents.tf2.PlayerScout

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	local plC = self:AddEntityComponent("tf2_player")
	if(CLIENT) then
		if(plC ~= nil) then plC:SetViewModelComponent("tf2_viewmodel_scout") end
	end
end
ents.tf2.COMPONENT_PLAYER_SCOUT = ents.register_component("tf2_player_scout",Component)
