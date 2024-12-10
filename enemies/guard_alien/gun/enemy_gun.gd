extends Node2D



var bullet:PackedScene = preload("res://enemies/guard_alien/gun/bullet.tscn")

func shoot(direction):
	var bullet_ins = bullet.instantiate()
	bullet_ins.rotation = direction
	bullet_ins.position = global_position
	get_tree().root.call_deferred("add_child",bullet_ins)
	
