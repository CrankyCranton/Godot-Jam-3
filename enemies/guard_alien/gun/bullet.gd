extends CharacterBody2D

var direction = Vector2.RIGHT

var spd = 500

func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)

func _physics_process(delta):
	velocity = direction * spd
	move_and_slide()
