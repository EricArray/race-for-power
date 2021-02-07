class_name IncElementLvl
extends StaticEffect

var element: String
var lvl: int

func _init(element: String, lvl: int):
	self.element = element
	self.lvl = lvl

func build_description() -> String:
	var s := ""
	for i in range(lvl):
		s += "[img]res://textures/icons/element-icon-" + element + ".png[/img]"
	return s
	
func apply():
	game.player_state.element_lvl[element] += lvl
	game.emit_signal("set_player_state")

func undo():
	game.player_state.element_lvl[element] -= lvl
	game.emit_signal("set_player_state")
