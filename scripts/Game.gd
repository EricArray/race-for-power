extends Node

signal set_deck()
signal set_hand()
signal set_entities()
signal update_entity(entity)

var cards_in_deck: Array = []
var cards_in_hand: Array = []
var entities_in_board: Array = []

func _ready():
	reset()

func reset():
	cards_in_deck = [
		Card.new(cardDefs.lower_abyssal),
		Card.new(cardDefs.blue_dragon),
		Card.new(cardDefs.lower_abyssal),
		Card.new(cardDefs.lower_abyssal),
		Card.new(cardDefs.blue_dragon),
		Card.new(cardDefs.blue_dragon),
		Card.new(cardDefs.lower_abyssal),
	]
	
	cards_in_hand = [
		Card.new(cardDefs.lower_abyssal),
		Card.new(cardDefs.lower_abyssal),
		Card.new(cardDefs.blue_dragon),
	]
	
	emit_signal("set_deck")
	emit_signal("set_hand")

func play_card_in_hand(card: Card):
	cards_in_hand.erase(card)
	emit_signal("set_hand")
	card.resolve()

func add_card_to_hand(card: Card):
	cards_in_hand.push_back(card)
	emit_signal("set_hand")

func create_entity(cardDef: CardDef): 
	entities_in_board.push_back(EntityInBoard.new(cardDef))
	emit_signal("set_entities")

func update_entity(entity: EntityInBoard):
	if entity.life <= 0:
		entities_in_board.erase(entity)
		emit_signal("set_entities")
	else:
		emit_signal("update_entity", entity)



