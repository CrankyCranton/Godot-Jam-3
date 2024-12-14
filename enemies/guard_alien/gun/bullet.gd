extends CharacterBody2D

var direction = Vector2.RIGHT

var spd = 400

func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)

func _physics_process(delta):
	velocity = direction * spd
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_collision_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
