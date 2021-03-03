extends Node

signal set_turn_player_id()
signal set_turn_phase()
signal set_state()

var attack_animation_scene := preload("res://scenes/animations/Slash.tscn")

var turn_player_id: int
var turn_phase: int

var state_stack: Array

var player_states := [
	PlayerState.new(),
	PlayerState.new(),
]

var cards_controllers := [
	CardsController.new(Players.PlayerId.P1),
	CardsController.new(Players.PlayerId.P2),
]

var entities_controller := EntitiesController.new()
var traps_controller := TrapsController.new()

func _ready():
	reset()

func reset():
	randomize()
	
	for player_state in player_states:
		player_state.reset()
	
	for cards_controller in cards_controllers:
		cards_controller.reset()
		cards_controller.draw_cards(4)

	traps_controller.reset()
	
	entities_controller.reset()
	
	set_turn(Players.PlayerId.P1)

func player(player_id: int) -> PlayerState:
	return player_states[player_id]

func state() -> GameState:
	return state_stack.back()

func set_state(new_state: GameState):
	print("set state: ", new_state.name())
	state_stack.clear()
	state_stack.append(new_state)
	emit_signal("set_state")
	
	new_state.on_start()

func push_state(new_state: GameState):
	print("push state: ", new_state.name())
	state_stack.append(new_state)
	emit_signal("set_state")	
	
	new_state.on_start()

func pop_state():
	print("pop state: ", state().name())
	state_stack.pop_back()
	emit_signal("set_state")


func play_card_in_hand(player_id: int, card: Card):
	if turn_player_id == player_id and state().can_play_cards_in_hand() and player(player_id).try_spend_power(card.def.power_cost):
		cards(player_id).remove_card_from_hand(card)
		
		card.def.resolve(player_id, card)

func pick_target(target: EntityInBoard):
	state().on_target_picked(target)

func attack(attacker: EntityInBoard):
	# keep triggering traps until the attacker is dead, or no more traps
	var opponent := Players.opponent(attacker.controller_player_id)
	var callback := Callback.new(self, "attack", [attacker])
	if not traps_controller.check_trigger_traps(opponent, attacker, callback):
		if attacker.life <= 0 or attacker.exhausted:
			return
		execute_attack(attacker)

func activate(entity: EntityInBoard):
	entities_controller.exhaust(entity)
	entity.card.def.on_activate.resolve(entity.controller_player_id)

func execute_attack(attacker: EntityInBoard):
	animations_controller.play_animation(
		attack_animation_scene,
		attacker.control,
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


func go_to_next_turn():
	var next_player := {
		Players.PlayerId.P1: Players.PlayerId.P2,
		Players.PlayerId.P2: Players.PlayerId.P1,
	}
	set_turn(next_player[turn_player_id])

func set_turn(new_turn_player_id: int):
	turn_player_id = new_turn_player_id
	emit_signal("set_turn_player_id")
	
	set_turn_phase(TurnPhase.BEGIN_PHASE)
	
func set_turn_phase(new_turn_phase: int):
	turn_phase = new_turn_phase
	emit_signal("set_turn_phase")
	
	set_state(get_new_phase_state())

func go_to_next_phase():
	set_turn_phase(TurnPhase.next(turn_phase))

func get_new_phase_state() -> GameState:
	match turn_phase:
		TurnPhase.BEGIN_PHASE:
			return BeginPhase.new()
		TurnPhase.POWER_PHASE:
			return PowerPhase.new()
		TurnPhase.MAIN_PHASE:
			return MainPhase.new()
		TurnPhase.ATTACK_PHASE:
			return AttackPhase.new()
		TurnPhase.RECOVER_PHASE:
			return RecoverPhase.new()
		_:
			return BeginPhase.new()


func set_trap(player_id: int, card: Card):
	if turn_player_id == player_id and state().can_play_cards_in_hand() and player(player_id).try_spend_power(2):
		cards(player_id).remove_card_from_hand(card)
		traps_controller.create_trap(player_id, card)


func cards(player_id: int):
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
