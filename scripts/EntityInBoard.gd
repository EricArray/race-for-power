class_name EntityInBoard
extends Resource

var def
var life: int
var exhausted: bool

func _init(def):
	self.def = def
	self.life = def.life
	self.exhausted = false
