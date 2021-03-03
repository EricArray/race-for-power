class_name CardsController
extends Reference

signal deck_updated()
signal hand_updated()
signal discard_pile_updated()

var fire_deck_defs := [
	card_defs.warlock,
	card_defs.warlock,
#	card_defs.warlock,
#	card_defs.warlock,
#	card_defs.warlock,
#	card_defs.imp,
#	card_defs.imp,
#	card_defs.imp,
#	card_defs.surge_of_power,
	card_defs.fireball,
	card_defs.fireball,
#	card_defs.firestorm,
]

var water_deck_defs := [
	card_defs.polliwog,
	card_defs.polliwog,
#	card_defs.polliwog,
#	card_defs.hydrothermal_vents,
#	card_defs.hydrothermal_vents,
	card_defs.blue_dragon,
	card_defs.blue_dragon,
#	card_defs.freeze,
#	card_defs.exploration,
]

var player_id: int
var cards_in_deck: Array = []
var cards_in_hand: Array = []
var discard_pile: Array = []

func _init(player_id: int):
	self.player_id = player_id

func reset():
	var deck_defs := {
		Players.PlayerId.P1: fire_deck_defs,
		Players.PlayerId.P2: water_deck_defs,
	}
	
	cards_in_deck = []
	for card_def in deck_defs[player_id]:
		cards_in_deck.append(Card.new(player_id, card_def))
	
	cards_in_deck.shuffle()
	emit_signal("deck_updated")
	
	cards_in_hand = []
	emit_signal("hand_updated")
	
	discard_pile = []
	emit_signal("discard_pile_updated")

func draw_cards(cards: int):
	console.log("{player_name} draws {cards} cards".format({
		player_name = Players.name(player_id),
		cards = cards,
	}))
	
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
	
