class_name PowerPerTurn
extends StaticEffect

var power_per_turn: int

func _init(power_per_turn: int):
	self.power_per_turn = power_per_turn

func build_description() -> String:
	return "+%s power per turn" % power_per_turn

func apply():
	game.player_state.power_per_turn += power_per_turn
	game.emit_signal("set_player_state")

func undo():
	game.player_state.power_per_turn -= power_per_turn
	game.emit_signal("set_player_state")
