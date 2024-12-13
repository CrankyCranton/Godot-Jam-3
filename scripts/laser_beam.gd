class_name LaserBeam extends RayCast2D


@export var bounce_randomization := 30.0
@export var remaining_length := 256.0
@export var remaining_bounces := 10
@export var fade_duration := 1.0

@onready var laser_middle: PointLight2D = $LaserMiddle
@onready var laser_end: PointLight2D = $LaserEnd
@onready var laser_end_2: PointLight2D = $LaserEnd2


func _ready() -> void:
	target_position.x = remaining_length
	await get_tree().physics_frame

	while true:
		force_raycast_update()
		if is_colliding():
			var collider := get_collider()
			if collider is Wall or collider is Target:
				var length := global_position.distance_to(get_collision_point())
				laser_end.position.x = length
				set_laser_length(length)
				remaining_length -= length
				if remaining_length > 0 and remaining_bounces > 0:
					var wall_margin := global_transform.x.normalized()
					bounce(get_collision_point() - wall_margin, get_collision_normal())
				break
			else:
				add_exception(collider)
				hurt(collider)
				continue
		else:
			laser_end.hide()
			laser_end_2.show()
			var length := target_position.length()
			laser_end_2.position.x = length
			set_laser_length(length)
			break
	fade()


func fade() -> void:
	for child in get_children():
		if child is PointLight2D:
			create_tween().tween_property(child, ^"energy", 0.0, fade_duration)
	await get_tree().create_timer(fade_duration, false).timeout
	queue_free()


func hurt(what: Object) -> void:
	pass
#	if what is Player:
#		print("You lose! Sucker! :p")
#	else:
#		print("Alien murder! This is racial descrimination!")


func set_laser_length(length: float) -> void:
	laser_middle.position.x = length / 2.0
	laser_middle.scale.x = length


func bounce(point: Vector2, normal: Vector2) -> void:
	remaining_bounces -= 1
	const LASER_BEAM := preload("res://scenes/laser_beam.tscn")
	var laser_beam: LaserBeam = LASER_BEAM.instantiate()
	laser_beam.global_position = point
	laser_beam.remaining_length = remaining_length
	laser_beam.remaining_bounces = remaining_bounces
	laser_beam.look_at(global_transform.x.bounce(normal))
	laser_beam.rotation_degrees += randf_range(-bounce_randomization, bounce_randomization)
	add_child(laser_beam)
