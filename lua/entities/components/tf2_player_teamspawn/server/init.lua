-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

util.register_class("ents.tf2.TeamSpawn", BaseEntityComponent)
local Component = ents.tf2.TeamSpawn

function Component:__init()
	BaseEntityComponent.__init(self)
end
function Component:Initialize()
	BaseEntityComponent.Initialize(self)
	self:AddEntityComponent(ents.COMPONENT_PLAYER_SPAWN)
	self:AddEntityComponent(ents.COMPONENT_TRANSFORM)

	self:BindEvent(ents.Entity.EVENT_HANDLE_KEY_VALUE, "HandleKeyValue")
end
function Component:GetMatchSummary()
	return self.m_matchSummary or 0
end
function Component:HandleKeyValue(key, val)
	if key == "matchsummary" then
		self.m_matchSummary = toint(val)
	else
		return util.EVENT_REPLY_UNHANDLED
	end
	return util.EVENT_REPLY_HANDLED
end
ents.tf2.COMPONENT_PLAYER_TEAMSPAWN = ents.register_component("tf2_player_teamspawn", Component, "tf2")
