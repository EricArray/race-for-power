class_name Card
extends Reference

var def: CardDef
var owner_player_id: int

func _init(owner_player_id: int, def: CardDef):
	self.owner_player_id = owner_player_id
	self.def = def
