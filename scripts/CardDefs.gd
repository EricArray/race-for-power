extends Node

var lower_abyssal: CardDef = load_lower_abyssal()
var blue_dragon: CardDef = load_blue_dragon()

func load_lower_abyssal() -> CardDef:
	var lower_abyssal = CardDef.new()
	lower_abyssal.card_name = "Lower Abyssal"
	lower_abyssal.type = "Demon"
	lower_abyssal.description = "[b]Play:[/b] [i]Deal 1 {f} damage to target entity.[/i]"
	lower_abyssal.cost = 3
	lower_abyssal.power = 1
	return lower_abyssal
	
func load_blue_dragon() -> CardDef:
	var blue_dragon = CardDef.new()
	blue_dragon.card_name = "Blue Dragon"
	blue_dragon.type = "Monster"
	blue_dragon.description = "A dragon that is blue."
	blue_dragon.cost = 5
	blue_dragon.power = 3
	return blue_dragon
