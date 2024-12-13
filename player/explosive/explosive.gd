extends RigidBody2D

#func _on_fuse_timer_timeout() -> void:
	#linear_velocity = Vector2.ZERO
	#gravity_scale = 0
	#apply_central_impulse(Vector2(0,0))
	#queue_free()

func explode():
	#particle bruh
	queue_free()

func _on_tilemap_detector_area_entered(area: Area2D) -> void:
	explode()
