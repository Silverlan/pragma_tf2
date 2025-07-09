-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

include("../shared.lua")
include_component("tf2_player_teamspawn")
local Component = ents.GmTf2

function Component:FindSpawnPoint()
	local tEnts = ents.get_all({ents.IteratorFilterComponent(ents.tf2.COMPONENT_PLAYER_TEAM_SPAWN),ents.IteratorFilterComponent(ents.COMPONENT_TRANSFORM)})
	local i = 1
	while(i <= #tEnts) do
		local ent = tEnts[i]
		local c = ent:GetComponent(ents.tf2.COMPONENT_PLAYER_TEAM_SPAWN)
		if(c:GetMatchSummary() ~= 0) then table.remove(tEnts,i)
		else i = i +1 end
	end
	if(#tEnts == 0) then
		-- Fallback
		tEnts = ents.get_all({ents.IteratorFilterComponent(ents.COMPONENT_PLAYER_SPAWN),ents.IteratorFilterComponent(ents.COMPONENT_TRANSFORM)})
	end
	local numSpawnPoints = #tEnts
	if(numSpawnPoints == 0) then return Vector(0,0,0),EulerAngles(0,0,0) end
	local r = math.random(1,numSpawnPoints)
	local ent = tEnts[r]
	if(ent:IsValid() == false) then return Vector(0,0,0),EulerAngles(0,0,0) end
	local trComponent = ent:GetTransformComponent()
	return trComponent:GetPos(),EulerAngles(0,trComponent:GetYaw(),0)
end

function Component:OnPlayerSpawned(pl)
	local tfPlC = pl:GetEntity():AddNetworkedComponent("tf2_player")
	if(tfPlC ~= nil) then tfPlC:ChangeClass(tf2.PLAYER_CLASS_SCOUT) end

	local ent = pl:GetEntity()
	local pos,ang = self:FindSpawnPoint()
	local trComponent = ent:GetTransformComponent()
	if(trComponent ~= nil) then
		trComponent:SetPos(pos)
		trComponent:SetAngles(ang)
	end
	
	local charComponent = ent:GetCharacterComponent()
	if(charComponent ~= nil) then
		charComponent:SetViewAngles(ang)
	end
end
