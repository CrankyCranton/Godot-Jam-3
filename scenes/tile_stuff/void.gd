extends RayCast2D

var player:CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	look_at(player.global_position)

	if is_colliding():
		var target = get_collider()
		if target.is_in_group("player"):
			player.velocity = global_position - player.global_position
