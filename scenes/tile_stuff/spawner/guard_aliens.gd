extends Node

var guard_load:PackedScene = preload("res://enemies/guard_alien/guard_alien.tscn")

func _ready() -> void:#will be _ready
	for child:Marker2D in get_children():
		var guard:CharacterBody2D = guard_load.instantiate()
		guard.position = child.global_position
		call_deferred("add_child",guard)
