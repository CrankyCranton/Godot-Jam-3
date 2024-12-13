extends StaticBody2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("hello")
	var player = get_tree().get_first_node_in_group("player")
	player.remove_task(2)
	queue_free()
