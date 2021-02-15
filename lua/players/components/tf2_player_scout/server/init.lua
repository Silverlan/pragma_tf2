include("../shared.lua")
local Component = ents.tf2.PlayerScout

function Component:ApplyLoadout(charC)
	charC:GiveWeapon("tf_weapon_bat")
end
