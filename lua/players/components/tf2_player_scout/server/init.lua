-- SPDX-FileCopyrightText: (c) 2021 Silverlan <opensource@pragma-engine.com>
-- SPDX-License-Identifier: MIT

include("../shared.lua")
local Component = ents.tf2.PlayerScout

function Component:ApplyLoadout(charC)
	charC:GiveWeapon("tf_weapon_bat")
end
