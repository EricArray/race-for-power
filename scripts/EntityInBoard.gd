class_name EntityInBoard
extends Reference

var controller_player_id: int
var def
var life: int
var exhausted: bool

func _init(controller_player_id: int, def):
	self.controller_player_id = controller_player_id
	self.def = def
	self.life = def.life
	self.exhausted = false
