class_name PowerPerTurn
extends StaticEffect

var power_per_turn: int

func _init(power_per_turn: int):
	self.power_per_turn = power_per_turn

func build_description() -> String:
	return "+%s power per turn" % power_per_turn

func apply():
	game.player(Players.HARDCODED_P1_BEFORE_MULTIPLAYER).inc_power_per_turn(power_per_turn)

func undo():
	game.player(Players.HARDCODED_P1_BEFORE_MULTIPLAYER).dec_power_per_turn(power_per_turn)
