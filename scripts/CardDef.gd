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
	
func resolve():
	match card_type:
		CardType.ENTITY:
			entities_controller.create_entity(self)
		
		CardType.INSTANT:
			resolve_on_play()

func resolve_on_play():
	on_play.resolve()
	
func resolve_on_play_with_target(target: EntityInBoard):
	on_play.resolve_with_target(target)
	
func resolve_on_destroyed():
	on_destroyed.resolve()
