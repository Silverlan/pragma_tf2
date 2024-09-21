include_component("gm_generic")
include_component("tf2_player")

util.register_class("ents.GmTf2", BaseEntityComponent)
local Component = ents.GmTf2

function Component:__init()
	BaseEntityComponent.Initialize(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:BindEvent(ents.GamemodeComponent.EVENT_ON_PLAYER_SPAWNED, "OnPlayerSpawned")

	if CLIENT then
		console.run("cl_fov_viewmodel", "54")
	else
		for ent in ents.iterator({ ents.IteratorFilterComponent(ents.COMPONENT_PLAYER) }) do
			if ent:IsSpawned() then
				self:OnPlayerSpawned(ent:GetComponent(ents.COMPONENT_PLAYER))
			end
		end
	end

	self:InitializeConsoleCommands()
end

function Component:InitializeConsoleCommands()
	if SERVER then
		net.register("sv_tf2_dropitem")
		net.receive("sv_tf2_dropitem", function(packet, pl)
			local plC = pl:GetEntity():GetComponent("tf2_player")
			if plC ~= nil then
				plC:DropItem()
			end
		end)
	else
		console.register_command("dropitem", function(pl, ...)
			net.send(net.PROTOCOL_SLOW_RELIABLE, "sv_tf2_dropitem", net.Packet())
		end)
	end
end
ents.register_component("gm_tf2", Component, "tf2")
