class_name GainTemporalPower
extends InstantEffect

var temporal_power: int

func _init(temporal_power: int):
	self.temporal_power = temporal_power

func build_description() -> String:
	return "gain %s power until the end of your turn" % temporal_power

func resolve():
	game.player_state.temporal_power += temporal_power
	game.emit_signal("set_player_state")
