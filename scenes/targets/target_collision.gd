extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Grenade:
		body._explode()
		get_parent().explode()
