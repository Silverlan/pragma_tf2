util.register_class("ents.tf2.Teamflag", BaseEntityComponent)
local Component = ents.tf2.Teamflag

Component.GAME_TYPE_CTF = 0
Component.GAME_TYPE_ATTACK_DEFEND = 1
Component.GAME_TYPE_TERRITORY_CONTROL = 2
Component.GAME_TYPE_INVADE = 3
Component.GAME_TYPE_RESOURCE_CONTROL = 4
Component.GAME_TYPE_ROBOT_DESTRUCTION = 5

local noIoFlags =
	bit.bnot(bit.bor(ents.BaseEntityComponent.MEMBER_FLAG_BIT_INPUT, ents.BaseEntityComponent.MEMBER_FLAG_BIT_OUTPUT))
if SERVER then
	Component:RegisterMember(
		"ReturnTime",
		ents.MEMBER_TYPE_FLOAT,
		60.0,
		{},
		bit.band(ents.BaseEntityComponent.MEMBER_FLAG_DEFAULT, noIoFlags)
	)
end
Component:RegisterMember(
	"GameType",
	ents.MEMBER_TYPE_UINT32,
	Component.GAME_TYPE_CTF,
	{},
	bit.band(ents.BaseEntityComponent.MEMBER_FLAG_DEFAULT_NETWORKED, noIoFlags)
)

local gmComponents = {
	[Component.GAME_TYPE_CTF] = "gm_tf2_ctf",
	[Component.GAME_TYPE_ATTACK_DEFEND] = "gm_tf2_attack_defend",
	[Component.GAME_TYPE_TERRITORY_CONTROL] = "gm_tf2_territory_control",
	[Component.GAME_TYPE_INVADE] = "gm_tf2_invade",
	[Component.GAME_TYPE_RESOURCE_CONTROL] = "gm_tf2_resource_control",
	[Component.GAME_TYPE_ROBOT_DESTRUCTION] = "gm_tf2_robot_destruction",
}

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	self:AddEntityComponent(ents.COMPONENT_OWNABLE)
	self:AddEntityComponent("tf2_carry_item")
	local pickupC = self:AddEntityComponent("tf2_item_pickup")
	if pickupC ~= nil then
		pickupC:SetModel("flag/briefcase")
		if CLIENT then
			pickupC:SetIdleAnimation("spin")
		end
	end

	self:BindEvent(ents.OwnableComponent.EVENT_ON_OWNER_CHANGED, "OnOwnerChanged")
	if SERVER then
		self:BindEvent(ents.tf2.ItemPickup.EVENT_ON_PICKED_UP, "OnPickedUp")
	end
end
function Component:OnOwnerChanged(prevOwner, owner)
	local ent = self:GetEntity()
	local physC = ent:GetComponent(ents.COMPONENT_PHYSICS)
	if util.is_valid(owner) then
		local attC = ent:AddComponent(ents.COMPONENT_ATTACHMENT)
		local attInfo = ents.AttachmentComponent.AttachmentInfo()
		attInfo.flags = bit.bor(
			attInfo.flags,
			ents.AttachmentComponent.FATTACHMENT_MODE_SNAP_TO_ORIGIN,
			ents.AttachmentComponent.FATTACHMENT_MODE_UPDATE_EACH_FRAME,
			ents.AttachmentComponent.FATTACHMENT_MODE_FORCE_IN_PLACE
		)
		attC:AttachToAttachment(owner, "flag", attInfo)
		if CLIENT then
			ent:PlayAnimation("idle")
		end
		if physC ~= nil then
			physC:SetSimulationEnabled(false)
		end
		return
	end
	local attC = ent:GetComponent(ents.COMPONENT_ATTACHMENT)
	if attC ~= nil then
		attC:ClearAttachment()
	end
	if CLIENT then
		ent:PlayAnimation("spin")
	end
	if physC ~= nil then
		physC:SetSimulationEnabled(true)
		physC:DropToFloor()

		local ang = ent:GetAngles()
		ang.p = 0
		ang.r = 0
		ent:SetAngles(ang)
	end
end
function Component:OnEntitySpawn()
	local gameType = self:GetGameType()
	local entGm = ents.iterator({ ents.IteratorFilterComponent(ents.COMPONENT_GAMEMODE) })()
	if entGm ~= nil then
		local componentName = gmComponents[gameType]
		if componentName ~= nil then
			entGm:AddComponent(componentName)
		end
	end
end
ents.tf2.COMPONENT_TEAMFLAG = ents.register_component("tf2_teamflag", Component, "tf2")
