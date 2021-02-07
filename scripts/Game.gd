extends Node

signal set_state()
signal create_animation(animation)

var state: GameState

var turn_phase: int

var player_state: PlayerState

func _ready():
	reset()

func reset():
	randomize()
	
	state = MainPhase.new()
	turn_phase = TurnPhase.MAIN_PHASE
	
	player_state = PlayerState.new()
	
	cards_controller.reset()
	cards_controller.draw_cards(4)
	
	traps_controller.reset()
	
	entities_controller.reset()

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
		player_state.gain_power(player_state.power_per_turn)
		console.log("Player gains 5 power")
		
		cards_controller.draw_cards(1)
		
		go_to_next_phase()
	
	if new_state.is_recover():
		player_state.waste_temporal_power()
		entities_controller.recover_every_entity()
		go_to_next_phase()

func play_card_in_hand(card: Card):
	if state.can_play_cards_in_hand() and player_state.try_spend_power(card.def.power_cost):
		cards_controller.remove_card_from_hand(card)
		cards_controller.discard_card(card)
		
		card.def.resolve()

func pick_target(target: EntityInBoard):
	state.on_target_picked(target)

func attack(attacker: EntityInBoard):
	# keep triggering traps until the attacker is dead, or no more traps
	var callback := {
		target = self,
		method = "attack",
		binds = [attacker]
	}
	if not traps_controller.check_trigger_traps(player_state, attacker, callback):
		if attacker.life <= 0 or attacker.exhausted:
			return
		
		entities_controller.exhaust(attacker)
		
		if attacker.def.attack:
			player_state.gain_power(1)
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

func set_trap(card: Card):
	if state.can_play_cards_in_hand() and player_state.try_spend_power(2):
		cards_controller.remove_card_from_hand(card)
		traps_controller.create_trap(card)
