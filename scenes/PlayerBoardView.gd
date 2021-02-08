extends PanelContainer

onready var entities_container := $HBoxContainer/VBoxContainer/EntitiesContainer
onready var set_traps_container := $HBoxContainer/VBoxContainer2/TrapsContainer

export(Players.PlayerId) var player_id: int

var EntityView = preload("res://scenes/EntityView.tscn")
var TrapView = preload("res://scenes/TrapView.tscn")

func _ready():
	game.entities_controller.connect("entities_updated", self, "_on_Game_set_entities")
	_on_Game_set_entities()

	game.traps_controller.connect("traps_updated", self, "_on_Game_set_traps")
	_on_Game_set_traps()

func _on_Game_set_entities():
	for child in entities_container.get_children():
		entities_container.remove_child(child)
		child.queue_free()

	for entity in game.entities_controller.entities_controlled_by_player(player_id):
		var entity_view = EntityView.instance()
		entity_view.entity = entity
		entity_view.connect("mouse_entered", zoom_controller, "zoom_card", [entity_view, entity.def])
		entity_view.connect("mouse_exited", zoom_controller, "hide_zoom_card")
		entities_container.add_child(entity_view)

func _on_Game_set_traps():
	for child in set_traps_container.get_children():
		set_traps_container.remove_child(child)
		child.queue_free()

	for trap in game.traps_controller.traps_controlled_by_player(player_id):
		var trap_view = TrapView.instance()
#		trap_view.trap = trap
		trap_view.connect("mouse_entered", zoom_controller, "zoom_card", [trap_view, trap.card.def])
		trap_view.connect("mouse_exited", zoom_controller, "hide_zoom_card")
		set_traps_container.add_child(trap_view)
