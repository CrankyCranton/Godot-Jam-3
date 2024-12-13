extends RigidBody2D

@onready var timer:Timer = $FuseTimer

func  _ready() -> void:
	timer.start()

func _on_fuse_timer_timeout() -> void:
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
	apply_central_impulse(Vector2(0,0))
	$tilemap_detector.monitorable = true
	$tilemap_detector.monitoring = true
	queue_free()

func _on_tilemap_detector_area_entered(area: Area2D) -> void:
	print('yo')
