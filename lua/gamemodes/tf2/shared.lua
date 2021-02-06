include_component("tf2_player")

util.register_class("ents.GmTf2",BaseEntityComponent)
local Component = ents.GmTf2

function Component:__init()
	BaseEntityComponent.Initialize(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:BindEvent(ents.GamemodeComponent.EVENT_ON_PLAYER_SPAWNED,"OnPlayerSpawned")

	if(CLIENT) then
		console.run("cl_fov_viewmodel","54")
	end
end

function Component:OnPlayerSpawned(pl)
	local tfPlC = pl:GetEntity():AddComponent("tf2_player")
	if(tfPlC ~= nil) then tfPlC:ChangeClass(tf2.PLAYER_CLASS_SCOUT) end
end
ents.COMPONENT_GM_TF2 = ents.register_component("gm_tf2",Component)
