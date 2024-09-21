util.register_class("ents.tf2.Announcer", BaseEntityComponent)
local Component = ents.tf2.Announcer

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
end
function Component:PlayVoice(snd)
	--sound.play("vo/intel_teamstolen.mp3",sound.TYPE_VOICE)
end
ents.register_component("tf2_announcer", Component, "tf2")
