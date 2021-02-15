include("/gamemodes/generic/server/init.lua")
include("../shared.lua")
local Component = ents.GmTf2

function Component:FindSpawnPoint()
	local tEnts = ents.get_all({ents.IteratorFilterComponent(ents.COMPONENT_PLAYER_SPAWN),ents.IteratorFilterComponent(ents.COMPONENT_TRANSFORM)})
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
end
