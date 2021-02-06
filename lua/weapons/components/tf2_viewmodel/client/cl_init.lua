util.register_class("ents.tf2.ViewModel",BaseEntityComponent)
local Component = ents.tf2.ViewModel

local VM_ACTIVITY_TO_TF2 = {
	[game.Model.Animation.ACT_VM_DEPLOY] = game.Model.Animation.ACT_MELEE_VM_DRAW,
	[game.Model.Animation.ACT_VM_IDLE] = game.Model.Animation.ACT_MELEE_VM_IDLE,
	-- [game.Model.Animation.ACT_VM_HOLSTER] = game.Model.Animation.ACT_MELEE_VM_DRAW
}

function Component:__init()
	BaseEntityComponent.__init(self)
end

function Component:Initialize()
	BaseEntityComponent.Initialize(self)

	self:BindEvent(ents.AnimatedComponent.EVENT_TRANSLATE_ACTIVITY,"TranslateActivity")
end

function Component:TranslateActivity(act)
	if(VM_ACTIVITY_TO_TF2[act] == nil) then return end
	return util.EVENT_REPLY_HANDLED,VM_ACTIVITY_TO_TF2[act]
end
ents.tf2.COMPONENT_TF2_VIEWMODEL = ents.register_component("tf2_viewmodel",Component)
