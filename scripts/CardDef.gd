class_name CardDef
extends Reference

enum CardType {
	ENTITY,
	INSTANT,
}

var card_type: int
var card_name: String
var element_lvl := {
	fire = 0,
	air = 0,
	water = 0,
	earth = 0,
}
var type: String
var picture: String
var description: String
var power_cost: int
var attack: int
var life: int

var on_play: InstantEffect
var on_destroyed: InstantEffect
var static_effect: StaticEffect

func build_description() -> String:
	var s := ""
	
	if static_effect:
		s += "[center]" + static_effect.build_description() + "[/center]\n"
	
	if on_play:
		s += "[b]Play:[/b] " + on_play.build_description() + ".\n"
	
	if on_destroyed:
		s += "[b]Destroyed:[/b] " + on_destroyed.build_description() + ".\n"
	
	s += "\n[i]" + description + "[/i]"
	
	return s
	
func resolve(player_id: int):
	match card_type:
		CardType.ENTITY:
			game.entities_controller.create_entity(player_id, self)
		
		CardType.INSTANT:
			resolve_on_play(player_id)

func resolve_on_play(player_id: int):
	on_play.resolve(player_id)
	
func resolve_on_play_with_target(player_id: int, target: EntityInBoard, callback: Callback):
	on_play.resolve_with_target(player_id, target, callback)
	
func resolve_on_destroyed(player_id):
	on_destroyed.resolve(player_id)
