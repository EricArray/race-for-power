class_name GainPower
extends InstantEffect

var power: int

func _init(power: int):
	self.power = power

func build_description() -> String:
	return "gain %s power" % power

func resolve():
	game.player_state.power += power
	game.emit_signal("set_player_state")
