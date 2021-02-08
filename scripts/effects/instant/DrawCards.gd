class_name DrawCards
extends InstantEffect

var cards: int

func _init(cards: int):
	self.cards = cards

func build_description() -> String:
	return "draw %s cards" % cards

func resolve(player_id: int):
	game.draw_cards(player_id, cards)
