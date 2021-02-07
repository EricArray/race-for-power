class_name EntityInBoard
extends Resource

var def: CardDef
var life: int

func _init(def: CardDef):
	self.def = def
	self.life = def.power
