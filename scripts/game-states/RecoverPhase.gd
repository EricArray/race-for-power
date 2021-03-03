class_name RecoverPhase
extends GameState

func name() -> String:
	return "Recover phase"

func on_start():
	game.player(game.turn_player_id).waste_temporal_power()
	
	game.entities_controller.recover_all_entities_controlled_by_player(game.turn_player_id)

	game.go_to_next_turn()
