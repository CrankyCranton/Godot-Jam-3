class_name CircuitBoard extends Target


var explosion_chance := 0.1


func explode() -> void:
	if not is_destroyed:
		for basic_target: Target in get_tree().get_nodes_in_group(&"basic_targets"):
			if randf() <= explosion_chance:
				basic_target.explode()
	super()
