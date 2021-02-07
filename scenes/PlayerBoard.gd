extends PanelContainer

onready var entities_container := $HBoxContainer/VBoxContainer/EntitiesContainer
onready var set_traps_container := $HBoxContainer/VBoxContainer2/TrapsContainer

var EntityView = preload("res://scenes/EntityView.tscn")
var TrapView = preload("res://scenes/TrapView.tscn")

func _ready():
	entities_controller.connect("entities_updated", self, "_on_Game_set_entities")
	_on_Game_set_entities()

	traps_controller.connect("traps_updated", self, "_on_Game_set_traps")
	_on_Game_set_traps()

func _on_Game_set_entities():
	for child in entities_container.get_children():
		entities_container.remove_child(child)
		child.queue_free()

	for entity in entities_controller.entities:
		var entity_view = EntityView.instance()
		entity_view.entity = entity
		entity_view.connect("mouse_entered", cards_controller, "zoom_card", [entity_view, entity.def])
		entity_view.connect("mouse_exited", cards_controller, "hide_zoom_card")
		entities_container.add_child(entity_view)

func _on_Game_set_traps():
	for child in set_traps_container.get_children():
		set_traps_container.remove_child(child)
		child.queue_free()

	for trap in traps_controller.traps:
		var trap_view = TrapView.instance()
#		trap_view.trap = trap
		trap_view.connect("mouse_entered", cards_controller, "zoom_card", [trap_view, trap.card.def])
		trap_view.connect("mouse_exited", cards_controller, "hide_zoom_card")
		set_traps_container.add_child(trap_view)
