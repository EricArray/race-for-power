class_name GainTemporalPower
extends InstantEffect

var temporal_power: int

func _init(temporal_power: int):
	self.temporal_power = temporal_power

func build_description() -> String:
	return "gain %s power until the end of your turn" % temporal_power

func resolve(player_id: int):
	game.player(player_id).gain_temporal_power(temporal_power)
