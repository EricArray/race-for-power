extends Node

signal set_state()

var attack_animation_scene := preload("res://scenes/animations/Slash.tscn")

var state: GameState

var turn_phase: int

var player_states := [
	PlayerState.new(),
	PlayerState.new(),
]

var cards_controllers := [
	CardsController.new(),
	CardsController.new(),
]

var entities_controller := EntitiesController.new()
var traps_controller := TrapsController.new()

func _ready():
	reset()

func reset():
	randomize()
	
	state = MainPhase.new()
	turn_phase = TurnPhase.MAIN_PHASE
	
	for player_state in player_states:
		player_state.reset()
	
	for cards_controller in cards_controllers:
		cards_controller.reset()
		cards_controller.draw_cards(4)

	traps_controller.reset()
	
	entities_controller.reset()

func player(player_id: int) -> PlayerState:
	return player_states[player_id]

func set_state(new_state: GameState):
	state = new_state
	
	var new_turn_phase = new_state.turn_phase()
	if new_turn_phase:
		turn_phase = new_turn_phase
		match new_turn_phase:
			TurnPhase.POWER_PHASE: console.log("Power phase")
			TurnPhase.MAIN_PHASE: console.log("Main phase")
			TurnPhase.ATTACK_PHASE: console.log("Attack phase")
			TurnPhase.RECOVER_PHASE: console.log("Recover phase")
	
	emit_signal("set_state")
	
	if new_state.is_power_phase():
		for player_id in Players.EACH:
			player(player_id).gain_power(player(player_id).power_per_turn)
			console.log("{player_name} gains {power_gain} power".format({
				player_name = Players.name(player_id),
				power_gain = player(player_id).power_per_turn
			}))
			
			cards(player_id).draw_cards(1)
		
		go_to_next_phase()
	
	if new_state.is_recover():
		for player_id in Players.EACH:
			player(player_id).waste_temporal_power()
			entities_controller.recover_all_entities_controlled_by_player(player_id)
		
		go_to_next_phase()

func play_card_in_hand(player_id: int, card: Card):
	if state.can_play_cards_in_hand() and player(player_id).try_spend_power(card.def.power_cost):
		cards(player_id).remove_card_from_hand(card)
		cards(player_id).discard_card(card)
		
		card.def.resolve(player_id)

func pick_target(target: EntityInBoard):
	state.on_target_picked(target)

func attack(attacker: EntityInBoard):
	# keep triggering traps until the attacker is dead, or no more traps
	var opponent := Players.opponent(attacker.controller_player_id)
	var callback := Callback.new(self, "attack", [attacker])
	if not traps_controller.check_trigger_traps(opponent, attacker, callback):
		if attacker.life <= 0 or attacker.exhausted:
			return
		execute_attack(attacker)
		
func execute_attack(attacker: EntityInBoard):
	animations_controller.play_animation(
		attack_animation_scene,
		Callback.new(self, "apply_attack_effect", [attacker])
	)

func apply_attack_effect(attacker: EntityInBoard):
	var opponent := Players.opponent(attacker.controller_player_id)
	
	entities_controller.exhaust(attacker)
	
	if attacker.def.attack and player(opponent).power >= 1:
		player(attacker.controller_player_id).gain_power(1)
		player(opponent).lose_power(1)
		console.log(attacker.def.card_name + " attacked; 1 power stolen")
	else:
		console.log(attacker.def.card_name + " attacked; couldn't steal power")

	
func go_to_next_phase():
	set_state(get_next_phase_state())

func get_next_phase_state() -> GameState:
	match turn_phase:
		TurnPhase.POWER_PHASE:
			return MainPhase.new()
		TurnPhase.MAIN_PHASE:
			return AttackPhase.new()
		TurnPhase.ATTACK_PHASE:
			return RecoverPhase.new()
		TurnPhase.RECOVER_PHASE:
			return PowerPhase.new()
		_:
			return PowerPhase.new()

func set_trap(player_id: int, card: Card):
	if state.can_play_cards_in_hand() and player(player_id).try_spend_power(2):
		cards(player_id).remove_card_from_hand(card)
		traps_controller.create_trap(player_id, card)


func cards(player_id: int) -> CardsController:
	return cards_controllers[player_id]

func cards_in_hand(player_id: int) -> Array:
	return cards(player_id).cards_in_hand

func cards_in_deck(player_id: int) -> Array:
	return cards(player_id).cards_in_deck

func discard_pile(player_id: int) -> Array:
	return cards(player_id).discard_pile

func draw_card(player_id: int, n: int):
	cards(player_id).draw_cards(n)

func discard_card(player_id: int, card: Card):
	cards(player_id).discard_card(card)

