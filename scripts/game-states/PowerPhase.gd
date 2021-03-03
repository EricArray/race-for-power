class_name PowerPhase
extends GameState

func name() -> String:
	return "Power phase"

func on_start():
	var p = game.turn_player_id
	
	game.player(p).gain_power(
		game.player(p).power_per_turn
	)
	
	console.log("{player_name} gains {power_gain} power".format({
		player_name = Players.name(p),
		power_gain = game.player(p).power_per_turn
	}))
	
	game.cards(p).draw_cards(1)
	
	game.go_to_next_phase()
	
