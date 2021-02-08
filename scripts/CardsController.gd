class_name CardsController
extends Reference

signal deck_updated()
signal hand_updated()
signal discard_pile_updated()

var cards_in_deck: Array = []
var cards_in_hand: Array = []
var discard_pile: Array = []

func reset():
	cards_in_deck = [
		Card.new(cardDefs.warlock),
		Card.new(cardDefs.warlock),
#		Card.new(cardDefs.warlock),
#		Card.new(cardDefs.warlock),
#		Card.new(cardDefs.warlock),
#		Card.new(cardDefs.imp),
#		Card.new(cardDefs.imp),
#		Card.new(cardDefs.imp),
#		Card.new(cardDefs.surge_of_power),
		Card.new(cardDefs.fireball),
		Card.new(cardDefs.fireball),
#		Card.new(cardDefs.firestorm),
#		Card.new(cardDefs.polliwog),
#		Card.new(cardDefs.polliwog),
#		Card.new(cardDefs.polliwog),
#		Card.new(cardDefs.hydrothermal_vents),
#		Card.new(cardDefs.hydrothermal_vents),
#		Card.new(cardDefs.blue_dragon),
#		Card.new(cardDefs.blue_dragon),
#		Card.new(cardDefs.freeze),
#		Card.new(cardDefs.exploration),
	]
	cards_in_deck.shuffle()
	emit_signal("deck_updated")
	
	cards_in_hand = []
	emit_signal("hand_updated")
	
	discard_pile = []
	emit_signal("discard_pile_updated")
	
func draw_cards(cards: int):
	console.log("Player draws " + str(cards) + " cards")
	
	for i in range(cards):
		if cards_in_deck.size() > 0:
			cards_in_hand.push_back(cards_in_deck.pop_back())
	cards_in_hand.sort_custom(self, "sort_cards_in_hand")
	
	emit_signal("deck_updated")
	emit_signal("hand_updated")

func sort_cards_in_hand(a: Card, b: Card) -> bool:
	if a.def.card_type != b.def.card_type:
		return a.def.card_type < b.def.card_type
	elif a.def.power_cost != b.def.power_cost:
		return a.def.power_cost < b.def.power_cost
	elif a.def.card_name != b.def.card_name:
		return a.def.card_name < b.def.card_name
	else:
		return a < b

func remove_card_from_hand(card: Card):
	cards_in_hand.erase(card)
	emit_signal("hand_updated")

func discard_card(card: Card):
	discard_pile.append(card)
	emit_signal("discard_pile_updated")
	
