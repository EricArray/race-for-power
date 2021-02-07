extends Node

signal log_message(message)
signal set_state()
signal set_player_state()
signal set_deck()
signal set_hand()
signal set_entities()
signal update_entity(entity)

var state: GameState

var turn_phase: int

var player_state: PlayerState
var cards_in_deck: Array = []
var cards_in_hand: Array = []
var entities_in_board: Array = []

func _ready():
	reset()

func reset():
	randomize()
	
	state = MainPhase.new()
	
	turn_phase = TurnPhase.MAIN_PHASE
	
	player_state = PlayerState.new()
	
	cards_in_deck = [
		Card.new(cardDefs.warlock),
		Card.new(cardDefs.warlock),
		Card.new(cardDefs.warlock),
		Card.new(cardDefs.warlock),
		Card.new(cardDefs.warlock),
		Card.new(cardDefs.imp),
		Card.new(cardDefs.imp),
		Card.new(cardDefs.imp),
		Card.new(cardDefs.surge_of_power),
		Card.new(cardDefs.fireball),
		Card.new(cardDefs.fireball),
		Card.new(cardDefs.firestorm),
		Card.new(cardDefs.polliwog),
		Card.new(cardDefs.polliwog),
		Card.new(cardDefs.polliwog),
		Card.new(cardDefs.hydrothermal_vents),
		Card.new(cardDefs.hydrothermal_vents),
		Card.new(cardDefs.blue_dragon),
		Card.new(cardDefs.blue_dragon),
		Card.new(cardDefs.freeze),
		Card.new(cardDefs.exploration),
	]
	cards_in_deck.shuffle()
	
	cards_in_hand = []
	
	emit_signal("set_deck")
	emit_signal("set_hand")
	
	draw_cards(4)
	
func set_state(new_state: GameState):
	state = new_state
	
	var new_turn_phase = new_state.turn_phase()
	if new_turn_phase:
		turn_phase = new_turn_phase
		match new_turn_phase:
			TurnPhase.POWER_PHASE: log_message("Power phase")
			TurnPhase.MAIN_PHASE: log_message("Main phase")
			TurnPhase.ATTACK_PHASE: log_message("Attack phase")
			TurnPhase.RECOVER_PHASE: log_message("Recover phase")
	
	emit_signal("set_state")
	
	if new_state.is_power_phase():
		player_state.gain_power(player_state.power_per_turn)
		emit_signal("set_player_state")
		log_message("Player gains 5 power")
		
		draw_cards(1)
		go_to_next_phase()
	
	if new_state.is_recover():
		player_state.waste_temporal_power()
		emit_signal("set_player_state")
		
		for entity in entities_in_board:
			entity.exhausted = false
			update_entity(entity)
		go_to_next_phase()

func play_card_in_hand(card: Card):
	if player_state.try_spend_power(card.def.power_cost):
		emit_signal("set_player_state")
		
		cards_in_hand.erase(card)
		emit_signal("set_hand")
		
		card.def.resolve()

func create_entity(cardDef: CardDef): 
	entities_in_board.push_back(EntityInBoard.new(cardDef))
	emit_signal("set_entities")
	log_message(cardDef.card_name + " created")

	if cardDef.static_effect:
		cardDef.static_effect.apply()

	if cardDef.on_play:
		cardDef.resolve_on_play()

func update_entity(entity: EntityInBoard):
	if entity.life <= 0:
		destroy_entity(entity)
	else:
		emit_signal("update_entity", entity)

func destroy_entity(entity: EntityInBoard):
	entities_in_board.erase(entity)
	emit_signal("set_entities")
	log_message(entity.def.card_name + " destroyed")
	
	if entity.def.static_effect:
		entity.def.static_effect.undo()
	
	if entity.def.on_destroyed:
		entity.def.resolve_on_destroyed()

func draw_cards(cards: int):
	log_message("Player draws " + str(cards) + " cards")
	for i in range(cards):
		if cards_in_deck.size() > 0:
			cards_in_hand.push_back(cards_in_deck.pop_back())
	cards_in_hand.sort_custom(self, "sort_cards_in_hand")
	emit_signal("set_deck")
	emit_signal("set_hand")

func sort_cards_in_hand(a: Card, b: Card) -> bool:
	if a.def.card_type != b.def.card_type:
		return a.def.card_type < b.def.card_type
	elif a.def.power_cost != b.def.power_cost:
		return a.def.power_cost < b.def.power_cost
	elif a.def.card_name != b.def.card_name:
		return a.def.card_name < b.def.card_name
	else:
		return a < b

func pick_target(target: EntityInBoard):
	state.on_target_picked(target)

func attack(attacker: EntityInBoard):
	attacker.exhausted = true
	emit_signal("update_entity", attacker)
	
	if attacker.def.attack:
		player_state.gain_power(1)
		emit_signal("set_player_state")
		log_message(attacker.def.card_name + " attacked; 1 power stolen")
	else:
		log_message(attacker.def.card_name + " attacked; couldn't steal power")

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

func log_message(message: String):
	emit_signal("log_message", message)
