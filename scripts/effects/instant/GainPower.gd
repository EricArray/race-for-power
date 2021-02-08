class_name GainPower
extends InstantEffect

var power: int

func _init(power: int):
	self.power = power

func build_description() -> String:
	return "gain %s power" % power

func resolve():
	game.player(Players.HARDCODED_P1_BEFORE_MULTIPLAYER).gain_power(power)
