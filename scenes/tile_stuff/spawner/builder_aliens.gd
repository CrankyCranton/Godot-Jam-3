extends Node

var builder_load:PackedScene = preload("res://enemies/builder_alien/builder_alien.tscn")

func __ready() -> void:#will be _ready
	for child:Marker2D in get_children():
		var builder:CharacterBody2D = builder_load.instantiate()
		builder.position = child.global_position
		call_deferred("add_child",builder)
