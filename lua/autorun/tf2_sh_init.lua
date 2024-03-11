ents.tf2 = {}
tf2 = tf2 or {}

game.Model.ACT_MELEE_VM_IDLE = game.Model.Animation.RegisterActivity("ACT_MELEE_VM_IDLE")
game.Model.ACT_MELEE_VM_DRAW = game.Model.Animation.RegisterActivity("ACT_MELEE_VM_DRAW")
game.Model.ACT_MELEE_VM_HITCENTER = game.Model.Animation.RegisterActivity("ACT_MELEE_VM_HITCENTER")
game.Model.ACT_MELEE_VM_SWINGHARD = game.Model.Animation.RegisterActivity("ACT_MELEE_VM_SWINGHARD")

game.Model.ACT_MP_RUN_MELEE = game.Model.Animation.RegisterActivity("ACT_MP_RUN_MELEE")
game.Model.ACT_MP_STAND_MELEE = game.Model.Animation.RegisterActivity("ACT_MP_STAND_MELEE")
game.Model.ACT_MP_CROUCH_MELEE = game.Model.Animation.RegisterActivity("ACT_MP_CROUCH_MELEE")
game.Model.ACT_MP_CROUCHWALK_MELEE = game.Model.Animation.RegisterActivity("ACT_MP_CROUCHWALK_MELEE")

-- Weapon_BaseballBat.HitWorld

tf2.PLAYER_CLASS_INVALID = -1
tf2.PLAYER_CLASS_SCOUT = 0
tf2.PLAYER_CLASS_SOLDIER = (tf2.PLAYER_CLASS_SCOUT + 1)
tf2.PLAYER_CLASS_PYRO = (tf2.PLAYER_CLASS_SOLDIER + 1)
tf2.PLAYER_CLASS_DEMO = (tf2.PLAYER_CLASS_PYRO + 1)
tf2.PLAYER_CLASS_HEAVY = (tf2.PLAYER_CLASS_DEMO + 1)
tf2.PLAYER_CLASS_ENGINEER = (tf2.PLAYER_CLASS_HEAVY + 1)
tf2.PLAYER_CLASS_MEDIC = (tf2.PLAYER_CLASS_ENGINEER + 1)
tf2.PLAYER_CLASS_SNIPER = (tf2.PLAYER_CLASS_MEDIC + 1)
tf2.PLAYER_CLASS_SPY = (tf2.PLAYER_CLASS_SNIPER + 1)
tf2.PLAYER_CLASS_COUNT = (tf2.PLAYER_CLASS_SPY + 1)

local classIdentifiers = {
	[tf2.PLAYER_CLASS_SCOUT] = "scout",
	[tf2.PLAYER_CLASS_SOLDIER] = "soldier",
	[tf2.PLAYER_CLASS_PYRO] = "pyro",
	[tf2.PLAYER_CLASS_DEMO] = "demo",
	[tf2.PLAYER_CLASS_HEAVY] = "heavy",
	[tf2.PLAYER_CLASS_ENGINEER] = "engineer",
	[tf2.PLAYER_CLASS_MEDIC] = "medic",
	[tf2.PLAYER_CLASS_SNIPER] = "sniper",
	[tf2.PLAYER_CLASS_SPY] = "spy",
}

function tf2.player_class_to_identifier(class)
	return "tf2_player_" .. classIdentifiers[class]
end
