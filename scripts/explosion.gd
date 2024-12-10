class_name Explosion extends Area2D


@onready var fire: GPUParticles2D = $Fire
@onready var holy_smoke: GPUParticles2D = $"HolySmoke!"
@onready var shape: CollisionShape2D = $Shape
@onready var line_of_fire: RayCast2D = $LineOfFire

@export var radius := 64.0
@export var density := 2.0
@export var max_smoke := 2
#@export var smoke_spawns := 2


func _ready() -> void:
	await get_tree().create_timer(randf_range(3.0, 10.0)).timeout
	var avg_speed: float = lerpf(fire.process_material.initial_velocity_min,
			fire.process_material.initial_velocity_max, 0.5)
	var lifetime := radius / avg_speed

	fire.lifetime = lifetime
	fire.amount = roundi(radius * density)
	#fire.process_material.sub_emitter_frequency = smoke_spawns / lifetime
	holy_smoke.amount = fire.amount * max_smoke#fire.process_material.sub_emitter_frequency * lifetime
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