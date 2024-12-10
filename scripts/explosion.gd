class_name Explosion extends Area2D


@onready var fire: GPUParticles2D = $Fire
@onready var holy_smoke: GPUParticles2D = $"HolySmoke!"
@onready var shape: CollisionShape2D = $Shape
@onready var line_of_fire: RayCast2D = $LineOfFire

@export var radius := 64.0
@export var density := 1.0


func _ready() -> void:
	var avg_speed: float = lerpf(fire.process_material.initial_velocity_min,
			fire.process_material.initial_velocity_max, 0.5)
	var lifetime := radius / avg_speed

	fire.lifetime = lifetime
	fire.amount = roundi(radius * density)
	holy_smoke.amount = fire.amount
	fire.emitting = true

	await create_tween().tween_property(shape.shape, ^"radius", radius, fire.lifetime).finished
	shape.set_deferred(&"disabled", true)
	await get_tree().create_timer(holy_smoke.lifetime, false).timeout
	queue_free()


func _physics_process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		line_of_fire.target_position = line_of_fire.to_local(body.global_position)
		line_of_fire.force_raycast_update()
		if line_of_fire.get_collider() == body:
			pass # Body collided.
