extends Node2D

func _ready() -> void:
	Global.tiles = $walls
	$player.number_of_bombs = 0


func _on_next_room_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/tile_stuff/level.tscn")
