class_name CardDef
extends Reference

enum CardType {
	ENTITY,
	INSTANT,
}

var card_type: int
var card_name: String
var type: String
var picture: String
var description: String
var cost: int
var power: int

var on_play: InstantEffect
