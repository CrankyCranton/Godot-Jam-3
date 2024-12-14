extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.number_of_bombs += 1
		queue_free()
